#!/bin/sh
sed "s/\${ESP32_IP}/${ESP32_IP}/g" /etc/prometheus/prometheus.yml.tmpl > /etc/prometheus/prometheus.yml
exec /bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.retention.time=30d
