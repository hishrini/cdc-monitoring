# Monitoring
Monitoring Kafka, Kafka Connect &amp; Postgresql Connector using Prometheus grafana

# Monitoring Kafka, Kafka Connect, and PostgreSQL Debezium with Prometheus and Grafana

Monitoring solution for the Kafka ecosystem using Prometheus and Grafana on your local environment with Grafana hosted on Podman.

## Overview of the Monitoring Setup

1. Set up JMX exporters for Kafka and Kafka Connect to expose metrics to Prometheus
2. Configure Debezium PostgreSQL connector metrics
3. Configure Prometheus to scrape metrics from all services
4. Connect Prometheus as a data source in your Podman-hosted Grafana
5. Create dashboards to visualize the data

Here is the step-by-step implementation plan:

## 1. Set up JMX Exporters for Kafka and Kafka Connect

First, you'll need the JMX exporter to expose Kafka metrics to Prometheus:

### For Kafka Brokers:

Download the JMX exporter JAR file and create a configuration file:

```bash
mkdir -p ~/kafka-monitoring
cd ~/kafka-monitoring
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.2/jmx_prometheus_javaagent-0.17.2.jar
```

Create a Kafka JMX exporter config file:

### For Kafka Connect:

Create a Kafka Connect JMX exporter config file:

## 2. Modify Kafka and Kafka Connect Startup Scripts

Update your Kafka and Kafka Connect startup scripts to include the JMX exporter:

Make the scripts executable:

```bash
chmod +x start-kafka-with-metrics.sh
chmod +x start-kafka-connect-with-metrics.sh
```

## 3. Configure PostgreSQL and Debezium Monitoring

For PostgreSQL monitoring, you'll need a PostgreSQL exporter:

```bash
# Download and extract PostgreSQL exporter
cd ~/kafka-monitoring
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.11.1/postgres_exporter-0.11.1.linux-amd64.tar.gz
tar xvfz postgres_exporter-*.tar.gz
cd postgres_exporter-*
```

Create a PostgreSQL exporter configuration file:

Create a script to run the PostgreSQL exporter:

Make it executable:

```bash
chmod +x start-postgres-exporter.sh
```

## 4. Configure Prometheus to Scrape Metrics

Create a Prometheus configuration file:

Set up and start Prometheus locally:

```bash
cd ~/kafka-monitoring
wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
cd prometheus-*
cp ~/kafka-monitoring/prometheus.yml .
```

Create a script to start Prometheus:

Make it executable:

```bash
chmod +x start-prometheus.sh
```

## 5. Configure Grafana on Podman

Assuming you already have Grafana running on Podman, you need to connect it to your Prometheus instance.

### Pull and Run Grafana on Podman (if not already running):

```bash
podman pull docker.io/grafana/grafana:latest
podman run -d --name grafana -p 3000:3000 grafana/grafana
```

### Configure Grafana to Connect to Prometheus:

1. Access Grafana at http://localhost:3000 (default credentials: admin/admin)
2. Add a new data source:
   - Click on "Configuration" (gear icon) > "Data Sources" > "Add data source"
   - Select "Prometheus"
   - Set URL to `http://<your-host-ip>:9090` (use your host's IP, not localhost, as Grafana is running in a container)
   - Click "Save & Test"

## 6. Debezium Specific Configuration

For the Debezium PostgreSQL connector, ensure you have metrics enabled in your connector configuration:

Use the Kafka Connect REST API to create the connector:

```bash
curl -X POST -H "Content-Type: application/json" --data @postgres-connector-config.json http://localhost:8083/connectors
```

## 7. Create Grafana Dashboards

Now, let's create some example dashboards for monitoring your systems:
Let me continue with the Kafka Connect dashboard configuration:

Now let's create a PostgreSQL dashboard:

## Import Dashboards into Grafana

To import the dashboards into Grafana:

1. Access Grafana at http://localhost:3000
2. Click the "+" icon in the left sidebar and select "Import"
3. Click "Upload JSON file" and select one of the dashboard JSON files
4. Select the Prometheus data source and click "Import"
5. Repeat for each dashboard

## Running the Complete Monitoring Setup

Here's a complete script to start all the monitoring components:

Make it executable:

```bash
chmod +x start-monitoring.sh
```

## Summary of Setup

Here's a summary of what we've set up:

1. **JMX Exporters**: For both Kafka and Kafka Connect to expose metrics for Prometheus to scrape
2. **PostgreSQL Exporter**: To monitor your PostgreSQL database
3. **Prometheus**: To collect and store metrics from all services
4. **Grafana**: Running in Podman to visualize metrics

### Components and Ports:

- Kafka JMX Exporter: Port 9999
- Kafka Connect JMX Exporter: Port 9998
- PostgreSQL Exporter: Port 9187
- Prometheus: Port 9090
- Grafana: Port 3000 (in Podman)

### Dashboards Created:

1. **Kafka Metrics Dashboard**: For monitoring Kafka broker metrics
2. **Kafka Connect and Debezium Metrics**: For monitoring Kafka Connect and Debezium PostgreSQL connector
3. **PostgreSQL Metrics**: For monitoring PostgreSQL database metrics

## Additional Considerations

1. **Security**: This setup doesn't include authentication for Prometheus or the exporters. In a production environment, consider adding authentication and TLS.

2. **Data Retention**: Configure Prometheus data retention in `prometheus.yml` based on your needs.

3. **High Availability**: For production, consider setting up Prometheus in a high-availability configuration.

4. **Alert Manager**: Add Prometheus Alert Manager for alerting on critical metrics.

5. **Fine-tuning**: Adjust the JMX exporter configurations to include/exclude metrics based on your specific needs.

6. **Network Configuration**: If running Grafana in Podman, make sure your Prometheus server is accessible from the Grafana container. You might need to use your host's IP instead of `localhost` when configuring the Prometheus data source in Grafana.

7. **Persistence**: For production, configure persistent volumes for Prometheus and Grafana to preserve data across restarts.

To get started, simply run the `start-monitoring.sh` script, configure the Prometheus data source in Grafana, and import the dashboards. This will give you a comprehensive monitoring solution for your Kafka, Kafka Connect, and PostgreSQL with Debezium environment.
