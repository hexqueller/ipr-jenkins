pipeline {
    agent any

    environment {
        // Получение секрета из Vault
        API_TOKEN = vault(vaultCredentialsId: 'my-vault-config',
                          path: 'jenkins/api-token',
                          engineVersion: '2',
                          secretValues: 'value')
    }

    stages {
        stage('Example') {
            steps {
                script {
                    // Использование секрета в качестве переменной окружения
                    echo "API token: ${env.API_TOKEN}"
                }
            }
        }
    }
}

