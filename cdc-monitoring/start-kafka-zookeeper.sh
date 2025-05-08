#!/bin/bash

# Define the paths
KAFKA_HOME=~/kafka_2.13-3.7.0.redhat-00007

# Start Kafka Zookeeper
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
