FROM jenkins/jenkins

USER root
ARG JAVA_OPTS
ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

COPY jenkins-config.yaml /user/local/jenkins-config.yaml

# Установка плагинов
RUN chmod 744 /user/local/jenkins-config.yaml && \
    jenkins-plugin-cli --plugins ssh-slaves && \
    jenkins-plugin-cli --plugins configuration-as-code && \
    jenkins-plugin-cli --plugins dark-theme && \
    jenkins-plugin-cli --plugins git && \
    jenkins-plugin-cli --plugins gradle && \
    jenkins-plugin-cli --plugins workflow-aggregator && \
    jenkins-plugin-cli --plugins job-dsl && \
    jenkins-plugin-cli --plugins hashicorp-vault-plugin && \
    jenkins-plugin-cli --plugins hashicorp-vault-pipeline
