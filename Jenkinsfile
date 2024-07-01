pipeline {
    agent any

    environment {
        GRADLE_VERSION = '8.8'
        GRADLE_HOME = "/home/jenkins/workspace/gradle"
        PATH = "$GRADLE_HOME/bin:$PATH"
    }

    stages {
        stage('Install Gradle') {
            steps {
                echo 'Installing Gradle...'
                sh '''
                wget -P /tmp https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
                unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /tmp
                mv /tmp/gradle-${GRADLE_VERSION} ${GRADLE_HOME}
                '''
                echo 'Gradle installed.'
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                sh 'gradle build'
                echo 'Build completed.'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'gradle test'
                echo 'Tests completed.'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh '''
                ssh user@tomcat 'mkdir -p /path/to/your/app'
                scp build/libs/your-app.jar user@tomcat:/path/to/your/app/
                ssh user@tomcat 'cd /path/to/your/app && java -jar your-app.jar &'
                '''
                echo 'Deployment completed.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
        success {
            echo 'Success!'
        }
        failure {
            echo 'Build or deploy failed.'
        }
    }
}
