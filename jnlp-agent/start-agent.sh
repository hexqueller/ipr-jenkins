#!/bin/sh

JENKINS_URL="http://jenkins:8080"

AGENT_NAME="jnlp-agent"

# Получаем секретный ключ из Jenkins мастера
SECRET=$(curl -s "${JENKINS_URL}/computer/${AGENT_NAME}/slave-agent.jnlp" | grep -oP '(?<=<argument>).*(?=</argument>)')

# Проверка, что секретный ключ был успешно получен
if [ -z "$SECRET" ]; then
  echo "Failed to retrieve the secret key for the agent."
  exit 1
fi

# Запуск JNLP-агента
exec java -jar /usr/share/jenkins/agent.jar -jnlpUrl ${JENKINS_URL}/computer/${AGENT_NAME}/slave-agent.jnlp -secret ${SECRET} -workDir "/home/jenkins/agent"
