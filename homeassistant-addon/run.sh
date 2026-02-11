#!/usr/bin/with-contenv bashio

# Get configuration
export MQTT_BROKER=$(bashio::config 'mqtt_broker')
export MQTT_PORT=$(bashio::config 'mqtt_port')
export MQTT_USERNAME=$(bashio::config 'mqtt_username')
export MQTT_PASSWORD=$(bashio::config 'mqtt_password')
export COMMUNICATION_MODE=$(bashio::config 'communication_mode')
export WINDOWS_SERVICE_IP=$(bashio::config 'windows_service_ip')
export LOG_LEVEL=$(bashio::config 'log_level')

# Get Home Assistant token
export HA_TOKEN=${SUPERVISOR_TOKEN}

bashio::log.info "Starting Windows Notification Bridge..."
bashio::log.info "MQTT Broker: ${MQTT_BROKER}:${MQTT_PORT}"
bashio::log.info "Communication Mode: ${COMMUNICATION_MODE}"

# Run the application
cd /app
python3 main.py
