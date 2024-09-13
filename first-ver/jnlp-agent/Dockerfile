FROM jenkins/inbound-agent:latest

USER root
COPY id_rsa /tmp/
COPY start-agent.sh /usr/local/bin/start-agent.sh

ENV GRADLE_VERSION="8.8"
ENV JENKINS_URL="http://jenkins:8080"
ENV JENKINS_SECRET="SuperDuperSecretApiKey"
ENV JENKINS_AGENT_NAME="jnpl-agent"
ENV JENKINS_AGENT_WORKDIR="/home/jenkins/agent"

RUN apt-get update && apt-get install -y wget unzip curl && \
    wget -P /tmp https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    mkdir /opt/gradle && \
    unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /opt/gradle && \
    mkdir -p /home/jenkins/.ssh/ && \
    echo "$(cat /tmp/id_rsa)" >> /home/jenkins/.ssh/id_rsa && \
    chmod 700 /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/id_rsa && \
    chown jenkins:jenkins /home/jenkins/.ssh && \
    rm /tmp/id_rsa && \
    chmod +x /usr/local/bin/start-agent.sh

ENTRYPOINT ["/usr/local/bin/start-agent.sh"]
