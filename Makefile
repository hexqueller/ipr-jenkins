.SILENT:

reset:
	rm -rf data

run:
	docker-compose down && docker-compose up

restart: reset
	docker-compose down && docker-compose up --build
