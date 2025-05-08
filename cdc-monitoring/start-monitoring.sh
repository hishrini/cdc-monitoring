#!/bin/bash

# Define the monitoring directory
MONITORING_DIR=~/cdc-monitoring

# Function to start a process in the background
start_process() {
  echo "Starting $1..."
  $2 &
  PID=$!
  echo "$1 started with PID $PID"
  sleep 3
}

# Start Kafka Zookeeper
start_process "Kafka Zookeeper" "$MONITORING_DIR/start-kafka-zookeeper.sh"

# Start Kafka with JMX exporter
start_process "Kafka Brokers" "$MONITORING_DIR/start-kafka-with-metrics.sh"

# Start Kafka Connect with JMX exporter
start_process "Kafka Connect" "$MONITORING_DIR/start-kafka-connect-with-metrics.sh"

# Start PostgreSQL exporter
start_process "PostgreSQL Exporter" "$MONITORING_DIR/start-postgres-exporter.sh"

# Start Prometheus
start_process "Prometheus" "$MONITORING_DIR/start-prometheus.sh"

# Check if Grafana container is running
if ! podman ps | grep grafana; then
  echo "Starting Grafana..."
  podman run -d --name grafana -p 3000:3000 grafana/grafana
  echo "Grafana started"
else
  echo "Grafana is already running"
fi

echo ""
echo "All CDC monitoring components are running:"
echo "- Kafka JMX exporter on port 9999"
echo "- Kafka Connect JMX exporter on port 9998"
echo "- PostgreSQL exporter on port 9187"
echo "- Prometheus on port 9090"
echo "- Grafana on port 3000"
echo ""
echo "Next steps:"
echo "1. Configure Prometheus data source in Grafana (http://localhost:3000)"
echo "2. Import the dashboard JSON files"
echo ""
echo "Press CTRL+C to stop all processes"

# Wait for CTRL+C
wait
