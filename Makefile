BOARD_PORT ?= /dev/ttyUSB0
FQBN = esp32:esp32:esp32

.PHONY: logs
logs:
	arduino-cli monitor -p $(BOARD_PORT) --config 115200

.PHONY: logs-raw
logs-raw:
	stty -F $(BOARD_PORT) 115200 raw -echo 2>/dev/null; timeout 8 cat $(BOARD_PORT) 2>&1

.PHONY: build
build: check-config
	arduino-cli compile --fqbn $(FQBN) ./dht11_read 2>&1 | tail -15

.PHONY: check-config
check-config:
	@test -f ./dht11_read/credentials.h || { \
		cp ./dht11_read/credentials.h.dist ./dht11_read/credentials.h; \
		echo "credentials.h created from template. Fill in your Wi-Fi credentials."; \
	}

.PHONY: upload
upload:
	arduino-cli upload -p $(BOARD_PORT) --fqbn $(FQBN) ./dht11_read 2>&1 | tail -5

.PHONY: deploy
deploy: build upload

.PHONY: monitoring-check-env
monitoring-check-env:
	@test -f ./monitoring/.env || { \
		cp ./monitoring/.env.dist ./monitoring/.env; \
		echo ".env created from .env.dist. Edit it with your settings."; \
	}

.PHONY: monitoring
monitoring: monitoring-check-env ## start Prometheus + Grafana
	docker compose -f monitoring/docker-compose.yml up -d

.PHONY: monitoring-stop
monitoring-stop: ## stop Prometheus + Grafana
	docker compose -f monitoring/docker-compose.yml down
