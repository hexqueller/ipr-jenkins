FROM jenkins/ssh-agent:latest-debian-jdk21

RUN echo 'deb http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list

RUN apt-get update && apt-get install -y wget unzip