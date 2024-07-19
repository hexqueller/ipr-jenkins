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

# Получаем и сохраняем Role ID и Secret ID в файл
if [ -f /vault/jenkins_approle.file ]; then
  echo "Jenkins_approle.file is already initialized"
else
  ROLE_ID=$(vault read auth/approle/role/jenkins-role/role-id -format=json | grep '"role_id"' | sed -E 's/.*"role_id": "(.*)".*/\1/')
  SECRET_ID=$(vault write -f auth/approle/role/jenkins-role/secret-id -format=json | grep '"secret_id"' | sed -E 's/.*"secret_id": "(.*)".*/\1/')

  echo "ROLE_ID: ${ROLE_ID}" > /vault/jenkins_approle.file
  echo "SECRET_ID: ${SECRET_ID}" >> /vault/jenkins_approle.file
  echo "ROOT_TOKEN: $VAULT_ROOT_TOKEN" >> /vault/jenkins_approle.file
fi

# Создаем путь для секретов и добавляем секреты
vault secrets enable -path=secrets kv
vault write secrets/creds/jenkins username=jenkins password=jenkins
vault write secrets/creds/api-key secret=SuperDuperSecretApiKey
vault write secrets/ssh/jenkins private_key=@/vault/id_rsa

# Загружаем политику
vault policy write jenkins vault/jenkins-policy.hcl
