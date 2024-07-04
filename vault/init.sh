#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

# Проверяем, инициализирован ли Vault
vault operator init -status
if [ $? -eq 0 ]; then
  echo "Vault is already initialized"
else
  # Инициализируем Vault и захватываем root token и ключи
  vault operator init -key-shares=1 -key-threshold=1 > /vault/init.file
fi

VAULT_UNSEAL_KEY=$(grep 'Unseal Key 1:' /vault/init.file | awk '{print $NF}')
VAULT_ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/init.file | awk '{print $NF}')

# Распечатываем Vault
vault operator unseal $VAULT_UNSEAL_KEY

# Логинимся с root token
vault login $VAULT_ROOT_TOKEN

# Создаем путь для секретов и добавляем секреты
vault secrets enable -path=jenkins kv
vault kv put jenkins/api-token value=my-secret-api-token
