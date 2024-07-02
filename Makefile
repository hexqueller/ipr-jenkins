.SILENT:

clean:
	rm -rf data

run:
	docker-compose down && docker-compose up

restart: clean
	docker-compose down && docker-compose up --build
