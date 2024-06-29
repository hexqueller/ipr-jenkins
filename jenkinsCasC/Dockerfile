FROM jenkins/jenkins

ARG JAVA_OPTS
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

ENV JENKINS_HOME /var/jenkins_home

# Установка плагинов
USER jenkins
RUN jenkins-plugin-cli --plugins configuration-as-code:1810.v9b_c30a_249a_4c && \
    jenkins-plugin-cli --plugins dark-theme:479.v661b_1b_911c01