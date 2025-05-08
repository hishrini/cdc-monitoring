#!/bin/bash

cd ~/cdc-monitoring/prometheus-*
prometheus --config.file=prometheus.yml
