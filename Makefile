BOARD_PORT ?= /dev/ttyUSB0
FQBN = esp32:esp32:esp32

monitor:
	arduino-cli monitor -p $(BOARD_PORT) --config 115200

monitor-raw:
	stty -F $(BOARD_PORT) 115200 raw -echo 2>/dev/null; timeout 8 cat $(BOARD_PORT) 2>&1

build: check-config
	arduino-cli compile --fqbn $(FQBN) ./dht11_read 2>&1 | tail -15

check-config:
	@test -f ./dht11_read/credentials.h || { \
		cp ./dht11_read/credentials.h.dist ./dht11_read/credentials.h; \
		echo "credentials.h created from template. Fill in your Wi-Fi credentials."; \
	}

upload:
	arduino-cli upload -p $(BOARD_PORT) --fqbn $(FQBN) ./dht11_read 2>&1 | tail -5

deploy: build upload
