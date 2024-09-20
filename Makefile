.SILENT:

build:
	DOCKER_DEFAULT_PLATFORM="linux/amd64" docker build -t hexqueller/jenkinscasc ./jenkinsCasC

push: build
	docker push hexqueller/jenkinscasc