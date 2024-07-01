FROM jenkins/jenkins

USER root
ARG JAVA_OPTS
ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

# Установка плагинов
RUN jenkins-plugin-cli --plugins configuration-as-code:1810.v9b_c30a_249a_4c && \
    jenkins-plugin-cli --plugins dark-theme:479.v661b_1b_911c01 && \
    jenkins-plugin-cli --plugins ssh-slaves:2.973.v0fa_8c0dea_f9f && \
    jenkins-plugin-cli --plugins git:5.2.2 && \
    jenkins-plugin-cli --plugins gradle:2.12