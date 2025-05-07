# Monitoring
Monitoring Kafka, Kafka Connect &amp; Postgresql Connector using Prometheus grafana

# Monitoring Kafka, Kafka Connect, and PostgreSQL Debezium with Prometheus and Grafana

Monitoring solution for the Kafka ecosystem using Prometheus and Grafana on your local environment with Grafana hosted on Podman.

## Assumption/Prerequisites to run the monitoring setup 
The Monitoring setup assumes you have:
1. Red Hat Streams for Apache Kafka(or community Kafka) setup on local machine or RHEL server
2. Red Hat Kafka Connect on local machine or RHEL server
3. PostgreSQL runs locally or on Podman Desktop(I am currently running this on Podman) 
4. Debezium PostgreSQL Connector Configuration to run the PostgreSQL Debezium Connector on Kafka Connect

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

Step1 : Download the JMX exporter JAR file and create a configuration file:

```bash
mkdir -p ~/kafka-monitoring
cd ~/kafka-monitoring
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.2/jmx_prometheus_javaagent-0.17.2.jar
```

======= Alternate using podman desktop =======  

Alternatively you can pull the prometheus image and host the same on Podman Desktop as well..

======= XXXXXXXXXXX =======  

Step2 : Create a Kafka JMX exporter config file:
Refer file : kafka-monitoring/kafka-jmx-config.yml


### For Kafka Connect:

Create a Kafka Connect JMX exporter config file:
Refer file : kafka-monitoring/kafka-connect-jmx-config.yml

## 2. Modify Kafka and Kafka Connect Startup Scripts

Update your Kafka and Kafka Connect startup scripts to include the JMX exporter:

======= Refer Script Files here =======  
Kafka Metrics Script File Location :   kafka-monitoring/start-kafka-with-metrics.sh
Kafka Connect Metrics Script File Location:  kafka-monitoring/start-kafka-connect-with-metrics.sh

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


======= Alternate Using podman desktop =======  

Alternatively if you have PostgreSQL is running as container you may need to follow below steps to run the postgres_exporter
postgres_exporter Image: This exporter will expose PostgreSQL metrics.​

Step1: Pull the image onto your podman desktop
```bash
pull quay.io/prometheuscommunity/postgres-exporter
```
Step2: run the postgres-exporter on your podman while setting environment variable:
       ```bash
       DATA_SOURCE_NAME="postgresql://postgres:yourpassword@localhost:5432/postgres?sslmode=disable"
       ```
       Ensure the DATA_SOURCE_NAME matches your PostgreSQL credentials.

Step3: Verify the pod is running and Open a browser or use curl to access:​
       ```bash
       http://localhost:9187/metrics
       ```
       
Note:  You may face issues while pods running independently of connection refused you can change the by replacing localhost with ip address of your local machine/server in the DATA_SOURCE_NAME environment variable


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

======= Refer Script Files here =======  
Prometheus Script File Location :   kafka-monitoring/start-prometheus.sh

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

======= Refer Postgres Debezium Connector Config File here =======  
Postgres Debezium Connector Config File Location :   kafka-monitoring/postgres-connector-config.json

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

======= Refer Script Files here =======  
Monitoring Script File Location :   kafka-monitoring/start-monitoring.sh

Make it executable:

```bash
chmod +x start-monitoring.sh
```

_**Please noe** you may see minor issues while running the script which tries to run all the scripts file together in sequence, 
in whcih case you may want to run the individual script files in the sequence mentioned in the file and that should work..
_

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
- Grafana: Port 3000 (on Podman)

### For Grafana Dashboards Import below dashboard files and make changes as required :

1. **Kafka Metrics Dashboard**: For monitoring Kafka broker metrics  -> **Refer file location**: kafka-monitoring/grafana-dashboard-config/kafka-dashboard.json
2. **Kafka Connect and Debezium Metrics**: For monitoring Kafka Connect and Debezium PostgreSQL connector -> **Refer file location**: kafka-monitoring/grafana-dashboard-config/kafka-connect-dashboard.json
3. **PostgreSQL Metrics**: For monitoring PostgreSQL database metrics -> **Refer file location**: kafka-monitoring/grafana-dashboard-config/postgres-dashboard.json


## Additional Considerations

1. **Security**: This setup doesn't include authentication for Prometheus or the exporters. In a production environment, consider adding authentication and TLS.

2. **Data Retention**: Configure Prometheus data retention in `prometheus.yml` based on your needs.

3. **High Availability**: For production, consider setting up Prometheus in a high-availability configuration.

4. **Alert Manager**: Add Prometheus Alert Manager for alerting on critical metrics.

5. **Fine-tuning**: Adjust the JMX exporter configurations to include/exclude metrics based on your specific needs.

6. **Network Configuration**: If running Grafana in Podman, make sure your Prometheus server is accessible from the Grafana container. You might need to use your host's IP instead of `localhost` when configuring the Prometheus data source in Grafana.

7. **Persistence**: For production, configure persistent volumes for Prometheus and Grafana to preserve data across restarts.

To get started, simply run the `start-monitoring.sh` script, configure the Prometheus data source in Grafana, and import the dashboards. This will give you a comprehensive monitoring solution for your Kafka, Kafka Connect, and PostgreSQL with Debezium environment.
