.SILENT:

clean:
	rm -rf data

run:
	docker-compose down && docker-compose up

restart: clean
	docker-compose down && docker-compose up --build

secretsPrune:
	rm -rf vault/init.file && rm -rf vault/jenkins_approle.file && rm -rf vault/data
