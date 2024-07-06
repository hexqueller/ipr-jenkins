pipeline {
    agent any

    environment {
        GRADLE_VERSION = '8.8'
        GRADLE_HOME = "${env.WORKSPACE}/gradle"
        PATH = "${GRADLE_HOME}/bin:${env.PATH}"

        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "nexus:8081"
        NEXUS_REPOSITORY = "WebApp"

        NEXUS_CREDENTIAL_ID = "vault-jenkins"
        ARTIFACT_NAME = "myapp.war"
        DOWNLOAD_DIR = "${env.WORKSPACE}/download"
    }

    triggers {
        pollSCM('* * * * *')
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

        stage('Rename and Upload to Nexus') {
            steps {
                echo 'Renaming artifact...'
                sh 'mv /home/jenkins/build-repo/build/libs/build-repo-1.0.war /home/jenkins/build-repo/build/libs/myapp.war'
                echo 'Uploading artifact to Nexus...'
                nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'myapp',
                        classifier: '',
                        file: '/home/jenkins/build-repo/build/libs/myapp.war',
                        type: 'war'
                    ]
                ],
                credentialsId: "${NEXUS_CREDENTIAL_ID}",
                groupId: 'com.yourcompany',
                nexusUrl: "${NEXUS_URL}",
                nexusVersion: "${NEXUS_VERSION}",
                protocol: "${NEXUS_PROTOCOL}",
                repository: "${NEXUS_REPOSITORY}",
                version: 'latest'
                echo 'Artifact uploaded to Nexus.'
            }
        }

    post {
        always {
            echo 'Cleaning workspace...'
            dir("${env.WORKSPACE}") {
                sh "rm -rf ${DOWNLOAD_DIR}"
            }
        }
        success {
            echo 'Success!'
        }
        failure {
            echo 'Download or deploy failed.'
        }
    }
}
