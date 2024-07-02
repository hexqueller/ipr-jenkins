FROM tomcat:latest

COPY id_rsa.pub /tmp/

RUN mkdir -p /root/.ssh/ && \
    echo "$(cat /tmp/id_rsa.pub)" >> /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh/ && \
    chmod 600 /root/.ssh/authorized_keys && \
    rm /tmp/id_rsa.pub