.SILENT:

clean:
	rm -rf JenkinsHome

run:
	docker-compose down && docker-compose up

restart: clean
	docker-compose down && docker-compose up --build

secretsPrune:
	rm -rf vault/init.file && rm -rf vault/jenkins_approle.file && rm -rf vault/data

build:
	docker build -t jenkins ./jenkinsCasC
	docker build -t jnlp-agent ./jnlp-agent
	docker build -t tomcat ./tomcat
	docker build -t vault ./vault

load:
	minikube image load jenkins
	minikube image load jnlp-agent
	minikube image load tomcat
	minikube image load vault