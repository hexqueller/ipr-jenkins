pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://vault:8200'
        VAULT_CREDENTIALS_ID = 'vault-api'
    }
    
    stages {
        stage('Retrieve Secret from Vault') {
            steps {
                script {
                    withCredentials([vaultString(credentialsId: VAULT_CREDENTIALS_ID, variable: 'SECRET_API')]) {
                        writeFile file: 'secret.txt', text: "${SECRET_API}"
                        sh 'cat secret.txt'
                    }
                }
            }
        }
    }
}
