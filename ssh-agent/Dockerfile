FROM jenkins/ssh-agent:latest-debian-jdk21

COPY id_rsa /tmp/

RUN echo 'deb http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list && \
    apt-get update && apt-get install -y wget unzip && \
    mkdir -p /home/jenkins/.ssh/ && \
    echo "$(cat /tmp/id_rsa)" >> /home/jenkins/.ssh/id_rsa && \
    chmod 700 /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/id_rsa && \
    chown jenkins:jenkins /home/jenkins/.ssh && \
    rm /tmp/id_rsa