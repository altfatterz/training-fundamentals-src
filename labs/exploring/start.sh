#! /bin/bash

docker-compose up -d

echo "Checking Kafka connection..."
while ! nc -z localhost 19092; do
  sleep 1.0
  echo "Kafka not yet ready..."
done 
echo "Kafka is now ready!"

echo "Creating vehicle-positions topic..."
kafka-topics --bootstrap-server localhost:19092 \
    --topic vehicle-positions \
    --create \
    --partitions 6 \
    --replication-factor 1

echo "Currently available topics:"
kafka-topics --bootstrap-server localhost:19092 --list

echo "Starting cnfltraining/vp-producer:v2 producer..."
docker container run -d \
    --name producer \
    --net exploring_confluent \
    cnfltraining/vp-producer:v2

echo "Running containers:"
docker ps