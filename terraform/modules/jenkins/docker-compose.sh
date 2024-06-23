#!/bin/bash
yum update -y
yum install docker -y
# yum install -y docker-compose

# docker-compose 설치
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
docker-compose -v

# Start Docker service
systemctl start docker
systemctl enable docker

# docker image 빌드
docker build -t jenkins-terraform-kubectl:v1 .

# Create Docker Compose file for Jenkins
mkdir -p /opt/jenkins
cat <<EOT > /opt/jenkins/docker-compose.yml
version: '3.8'

services:
  jenkins:
    image: jenkins-terraform-kubectl:v1
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
    environment:
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false
    restart: unless-stopped

volumes:
  jenkins_home:
    driver: local
EOT

# Start Jenkins using Docker Compose
docker-compose -f /opt/jenkins/docker-compose.yml up -d