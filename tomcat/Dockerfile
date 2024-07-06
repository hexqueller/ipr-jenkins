FROM tomcat:latest

COPY id_rsa.pub /tmp/

RUN mkdir -p /scripts
COPY start-tomcat.sh /scripts/start-tomcat.sh
COPY stop-tomcat.sh /scripts/stop-tomcat.sh

RUN echo 'deb http://ru.archive.ubuntu.com/ubuntu/ jammy main restricted' > /etc/apt/sources.list && \
    apt-get update && apt-get install -y openssh-server && \
    mkdir -p /root/.ssh/ && \
    echo "$(cat /tmp/id_rsa.pub)" >> /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh/ && \
    chmod 600 /root/.ssh/authorized_keys && \
    rm /tmp/id_rsa.pub && \
    mkdir -p /run/sshd && \
    chmod +x /scripts/start-tomcat.sh /scripts/stop-tomcat.sh

CMD ["/usr/sbin/sshd", "-D"]
