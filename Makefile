.SILENT:

build:
	docker build -t hexqueller/jenkinscasc ./jenkinsCasC

push: build
	docker push hexqueller/jenkinscasc