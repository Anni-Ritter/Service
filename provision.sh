#!/bin/bash

echo "* Add hosts ..."
echo "192.168.100.100 website docker" >> /etc/hosts

echo "* Add any prerequisites ..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

echo "* Add Docker repository and key ..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Install Docker ..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin
usermod -aG docker vagrant

echo "version: '3.4'

networks:
  services-network:
    driver: bridge

services:
  serviceone:
    container_name: serviceone
    image: serviceone:latest
    depends_on:
      - "servicetwo"
    build:
      context: serviceone
      dockerfile: Dockerfile
    environment: 
      - URI_ENV=http://servicetwo:80/
    ports:
      - "8080:80"
    networks:
      - services-network
  
  servicetwo:
    container_name: servicetwo
    image: servicetwo:latest
    build:
      context: servicetwo
      dockerfile: Dockerfile
    networks:
      - services-network" >> service/docker-compose.yml
cd service
docker-compose build
docker-compose up