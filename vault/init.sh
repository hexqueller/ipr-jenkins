#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'
UNSEAL_KEY_FILE="/vault/unseal.key"
INIT_FILE="/vault/init.file"

# Проверяем наличие файла init.file
if [ -f $INIT_FILE ]; then
  echo "Vault is already initialized"
else
  # Проверяем, инициализирован ли Vault
  vault operator init -status
  if [ $? -eq 0 ]; then
    echo "Vault is already initialized"
  else
    # Инициализируем Vault и захватываем root token и ключи
    vault operator init -key-shares=1 -key-threshold=1 > $INIT_FILE
    
    # Извлекаем и сохраняем ключ распечатки
    grep 'Unseal Key 1:' $INIT_FILE | awk '{print $NF}' > $UNSEAL_KEY_FILE
  fi
fi

# Проверяем наличие файла unseal.key и используем его для распечатки Vault
if [ -f $UNSEAL_KEY_FILE ]; then
  VAULT_UNSEAL_KEY=$(cat $UNSEAL_KEY_FILE)
  vault operator unseal $VAULT_UNSEAL_KEY
else
  echo "Unseal key file not found!"
  exit 1
fi

# Извлекаем root token для входа
VAULT_ROOT_TOKEN=$(grep 'Initial Root Token:' $INIT_FILE | awk '{print $NF}')

# Логинимся с root token
vault login $VAULT_ROOT_TOKEN

# Создаем AppRole для Jenkins
vault auth enable approle
vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"

ROLE_ID=$(vault read auth/approle/role/jenkins-role/role-id -format=json | grep '"role_id"' | sed -E 's/.*"role_id": "(.*)".*/\1/')
SECRET_ID=$(vault write -f auth/approle/role/jenkins-role/secret-id -format=json | grep '"secret_id"' | sed -E 's/.*"secret_id": "(.*)".*/\1/')
echo "ROLE_ID: ${ROLE_ID}" > /secrets.file
echo "SECRET_ID: ${SECRET_ID}" >> /secrets.file
echo "ROOT_TOKEN: $VAULT_ROOT_TOKEN" >> /secrets.file

# Создаем путь для секретов и добавляем секреты
vault secrets enable -path=secrets kv
vault write secrets/creds/jenkins username=jenkins password=jenkins
vault write secrets/creds/api-key secret=SuperDuperSecretApiKey

# Загружаем политику
vault policy write jenkins vault/jenkins-policy.hcl


# Отправляем на Jenkins обновленные данные!
VAULT_CREDENTIALS=$(cat <<EOF
{
  "scope": "GLOBAL",
  "usePolicies": false,
  "vaultAppRoleCredential": {
    "description": "vault-jenkins-role",
    "id": "vault-jenkins-role",
    "path": "approle",
    "roleId": "$ROLE_ID",
    "secretId": "$SECRET_ID"
  }
}
EOF
)

JENKINS_URL="http://jenkins:8080"
JENKINS_USER="jenkins-admin"
JENKINS_PASSWORD="admin"

# Получаем CSRF-токен и поле токена
CRUMB_RESPONSE=$(curl -s -u "$JENKINS_USER:$JENKINS_PASSWORD" "$JENKINS_URL/crumbIssuer/api/json")
CRUMB=$(echo $CRUMB_RESPONSE | jq -r '.crumb')
CRUMB_FIELD=$(echo $CRUMB_RESPONSE | jq -r '.crumbRequestField')

# Проверка значений
echo "CRUMB: $CRUMB"
echo "CRUMB_FIELD: $CRUMB_FIELD"

# Получаем ID существующей записи
VAULT_CREDENTIAL_ID=$(curl -s -u "$JENKINS_USER:$JENKINS_PASSWORD" "$JENKINS_URL/credentials/store/system/domain/_/credential/vaultAppRoleCredential/config.xml" | grep '<id>' | sed -E 's/.*<id>(.*)<\/id>.*/\1/')

# Проверка значения ID
echo "VAULT_CREDENTIAL_ID: $VAULT_CREDENTIAL_ID"

# Обновляем vaultAppRoleCredential
curl -X POST -u "$JENKINS_USER:$JENKINS_PASSWORD" -H "$CRUMB_FIELD:$CRUMB" --data-urlencode "json=$VAULT_CREDENTIALS" "$JENKINS_URL/credentials/store/system/domain/_/credential/$VAULT_CREDENTIAL_ID/config.xml"