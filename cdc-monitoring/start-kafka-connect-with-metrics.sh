#!/bin/bash

# Define the paths
KAFKA_HOME=~/kafka_2.13-3.7.0.redhat-00007
JMX_EXPORTER_JAR=~/cdc-monitoring/jmx_prometheus_javaagent-0.20.0.jar
JMX_EXPORTER_CONFIG=~/cdc-monitoring/kafka-connect-jmx-config.yml
JMX_PORT=9998
# Port 9998 is used by Prometheus JMX exporter agent to scrap and expose metrics in Prometheus format.

# Set JMX and Java agent environment variables
export KAFKA_OPTS="$KAFKA_OPTS -javaagent:$JMX_EXPORTER_JAR=$JMX_PORT:$JMX_EXPORTER_CONFIG"
export JMX_PORT=9582
# Port 9582 is for standard JMX remote management and monitoring like JConsole,, VisualVM etc ..
# This dual configuration allows you to monitor Kafka Connect both through standard JMX tools like JConsole and through Prometheus


# Start Kafka Connect Distributed mode
$KAFKA_HOME/bin/connect-distributed.sh $KAFKA_HOME/config/connect-distributed.properties


# Start Kafka Connect Standalone mode
#$KAFKA_HOME/bin/connect-standalone.sh $KAFKA_HOME/config/connect-standalone.properties $KAFKA_HOME/config/postgress14-connector-default-14Apr25_Final.properties
