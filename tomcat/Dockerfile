FROM tomcat:latest

COPY id_rsa.pub /tmp/

RUN echo 'deb http://ru.archive.ubuntu.com/ubuntu/ jammy main restricted' > /etc/apt/sources.list && \
    apt-get update && apt-get install -y openssh-server && \
    mkdir -p /root/.ssh/ && \
    echo "$(cat /tmp/id_rsa.pub)" >> /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh/ && \
    chmod 600 /root/.ssh/authorized_keys && \
    rm /tmp/id_rsa.pub && \
    mkdir -p /run/sshd && \
    mkdir -p /scripts && \
    echo '#!/bin/bash' > /scripts/start-tomcat.sh && \
    echo 'catalina.sh start' >> /scripts/start-tomcat.sh && \
    echo '#!/bin/bash' > /scripts/stop-tomcat.sh && \
    echo 'catalina.sh stop' >> /scripts/stop-tomcat.sh && \
    chmod +x /scripts/start-tomcat.sh /scripts/stop-tomcat.sh

CMD ["/usr/sbin/sshd", "-D"]
