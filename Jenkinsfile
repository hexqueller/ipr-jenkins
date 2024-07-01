pipeline {
    agent any

    environment {
        GRADLE_VERSION = '8.8'
        GRADLE_HOME = "${env.WORKSPACE}/gradle"
        PATH = "$GRADLE_HOME/bin:$PATH"
    }

    stages {
        stage('Install Gradle') {
            steps {
                sh '''
                wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
                unzip gradle-${GRADLE_VERSION}-bin.zip -d ${env.WORKSPACE}
                mv ${env.WORKSPACE}/gradle-${GRADLE_VERSION} ${env.WORKSPACE}/gradle
                '''
            }
        }
        stage('Build') {
            steps {
                sh 'gradle build'
            }
        }

        stage('Test') {
            steps {
                sh 'gradle test'
            }
        }

        stage('Deploy') {
            steps {
                // Деплой приложения (пример, деплой на сервер через SCP)
                sh '''
                ssh user@tomcat 'mkdir -p /path/to/your/app'
                scp build/libs/your-app.jar user@tomcat:/path/to/your/app/
                ssh user@tomcat 'cd /path/to/your/app && java -jar your-app.jar &'
                '''
            }
        }
    }

    post {
        always {
            // Очистка рабочих пространств
            cleanWs()
        }
        success {
            // Уведомление об успешной сборке
            echo 'Build and deploy successful!'
        }
        failure {
            // Уведомление о неудачной сборке
            echo 'Build or deploy failed.'
        }
    }
}
