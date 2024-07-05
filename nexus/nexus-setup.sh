# nexus-setup.sh

# Подождем, пока Nexus станет доступен
until $(curl --output /dev/null --silent --head --fail http://localhost:8081); do
    printf '.'
    sleep 5
done

# Читаем пароль администратора из файла
admin_password=$(cat /nexus-data/admin.password)

# Создадим административного пользователя
curl -u admin:${admin_password} -X POST -H "Content-Type: application/json" \
--data '{
  "userId": "jenkins",
  "firstName": "Jenkins",
  "lastName": "User",
  "emailAddress": "jenkins@example.com",
  "password": "jenkins",
  "status": "active",
  "roles": ["nx-admin"]
}' http://localhost:8081/service/rest/v1/security/users

# Создадим Maven2 Hosted репозиторий
curl -u jenkins:jenkins -X POST -H "Content-Type: application/json" \
--data '{
  "name": "WebApp",
  "online": true,
  "storage": {
    "blobStoreName": "default",
    "strictContentTypeValidation": true,
    "writePolicy": "ALLOW"
  },
  "cleanup": {
    "policyNames": ["weekly"]
  },
  "component": {
    "proprietaryComponents": true
  },
  "maven": {
    "versionPolicy": "RELEASE",
    "layoutPolicy": "STRICT"
  }
}' http://localhost:8081/service/rest/v1/repositories/maven/hosted
