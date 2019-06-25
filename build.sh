#!/bin/bash
if [ -e .env ]; then
    source .env
else
    echo "Please set up your .env file before starting your enviornment."
    exit 1
fi

echo 'Creation of $MACHINE_NAME environment'

echo "."
echo ".."
echo "..."
echo "Set $MACHINE_NAME as active."
docker-machine env $MACHINE_NAME
eval $(docker-machine env $MACHINE_NAME)

echo "."
echo ".."
echo "..."
echo "Copy conf to the server"
docker-machine scp  -r elasticsearch $MACHINE_NAME:.
docker-machine scp  -r kibana $MACHINE_NAME:.
docker-machine scp  -r logstash $MACHINE_NAME:.
docker-machine scp  -r logstash $MACHINE_NAME:.

echo "."
echo ".."
echo "..."
echo "Create $MACHINE_NAME networks"
docker network create -d bridge $MACHINE_NAME-network

echo "."
echo ".."
echo "..."
echo "Create and start nginx containers"
docker-compose -f docker-compose.yml -p elk up -d
