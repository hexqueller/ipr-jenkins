FROM tomcat:latest

COPY id_rsa.pub /tmp/

RUN echo 'deb http://ru.archive.ubuntu.com/ubuntu/ jammy main restricted' > /etc/apt/sources.list && \
    apt-get update && apt-get install -y openssh-server procps supervisor && \
    mkdir -p /root/.ssh/ && \
    echo "$(cat /tmp/id_rsa.pub)" >> /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh/ && \
    chmod 600 /root/.ssh/authorized_keys && \
    rm /tmp/id_rsa.pub && \
    mkdir -p /run/sshd && \
    mkdir -p /scripts && \
    echo '#!/bin/bash' > /scripts/start-tomcat.sh && \
    echo 'export JAVA_HOME=/opt/java/openjdk' >> /scripts/start-tomcat.sh && \
    echo 'export JRE_HOME=/opt/java/openjdk' >> /scripts/start-tomcat.sh && \
    echo '/usr/local/tomcat/bin/catalina.sh start' >> /scripts/start-tomcat.sh && \
    chmod +x /scripts/start-tomcat.sh


COPY splunkforwarder-7.2.1-be11b2c46e23-linux-2.6-amd64.deb /tmp
RUN dpkg -i /tmp/splunkforwarder-7.2.1-be11b2c46e23-linux-2.6-amd64.deb &&\
    /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --auto-ports --no-prompt && \
    mkdir -p /var/log/webapp

COPY inputs.conf /opt/splunkforwarder/etc/system/local
COPY outputs.conf /opt/splunkforwarder/etc/system/local
COPY user-seed.conf /opt/splunkforwarder/etc/system/local
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/sbin/sshd", "-D"]
