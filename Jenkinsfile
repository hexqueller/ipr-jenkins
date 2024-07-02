pipeline {
    agent any

    environment {
        GRADLE_VERSION = '8.8'
        GRADLE_HOME = "${env.WORKSPACE}/gradle"
        PATH = "${GRADLE_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Install Gradle') {
            steps {
                echo 'Installing Gradle...'
                sh '''
                wget -P /tmp https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
                unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /tmp
                mv /tmp/gradle-${GRADLE_VERSION} ${GRADLE_HOME}
                ls -la ${GRADLE_HOME}/bin
                '''
                echo 'Gradle installed.'
            }
        }

        stage('Build') {
            steps {
                echo 'Checking out build repository...'
                dir('/home/jenkins/build-repo') {
                    git branch: 'master', url: 'https://github.com/hexqueller/devops-webapp.git'
                }
                echo 'Building project from build repository...'
                dir('/home/jenkins/build-repo') {
                    sh 'gradle build'
                }
                echo 'Build completed from build repository.'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                dir('/home/jenkins/build-repo') {
                    sh 'gradle test'
                }
                echo 'Tests completed.'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh '''
                scp -o StrictHostKeyChecking=no /home/jenkins/build-repo/build/libs/build-repo-1.0.war root@tomcat:/usr/local/tomcat/webapps/

                ssh -o StrictHostKeyChecking=no root@tomcat <<EOF
                systemctl stop tomcat
                systemctl start tomcat
                EOF
                '''
                echo 'Deployment completed.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            dir("${env.WORKSPACE}") {
                sh "rm -rf ${env.WORKSPACE}/* && rm -rf /tmp/gradle*"
            }
        }
        success {
            echo 'Success!'
        }
        failure {
            echo 'Build or deploy failed.'
        }
    }
}
