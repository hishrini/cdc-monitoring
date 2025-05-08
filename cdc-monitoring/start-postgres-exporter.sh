#!/bin/bash

cd ~/cdc-monitoring/postgres_exporter-*
export $(cat postgres_exporter.env | xargs)
postgres_exporter