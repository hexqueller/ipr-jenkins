FROM jenkins/jenkins

USER root
ARG JAVA_OPTS
ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true ${JAVA_OPTS:-}"

COPY jenkins-config.yaml /user/local/jenkins-config.yaml
COPY plugins /user/local/plugins.txt

# Установка плагинов
RUN chmod 744 /user/local/jenkins-config.yaml && \
    jenkins-plugin-cli --plugin-file /user/local/plugins.txt && \
    mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
