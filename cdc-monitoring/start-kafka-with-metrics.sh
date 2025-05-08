#!/bin/bash

# Define the paths
KAFKA_HOME=~/kafka_2.13-3.7.0.redhat-00007
JMX_EXPORTER_JAR=~/cdc-monitoring/jmx_prometheus_javaagent-0.20.0.jar
JMX_EXPORTER_CONFIG=~/cdc-monitoring/kafka-jmx-config.yml
JMX_PORT=9999
# Port 9999 is used by Prometheus JMX exporter agent to scrap and expose metrics in Prometheus format.

# Set JMX and Java agent environment variables
export KAFKA_OPTS="$KAFKA_OPTS -javaagent:$JMX_EXPORTER_JAR=$JMX_PORT:$JMX_EXPORTER_CONFIG"
export JMX_PORT=9581
# Port 9581 is for standard JMX remote management and monitoring like JConsole, VisualVM etc ..
# This dual configuration allows you to monitor Kafka both through standard JMX tools like JConsole and through Prometheus

# Start Kafka server
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
