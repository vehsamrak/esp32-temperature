# ESP32 Temperature & Humidity Monitor

Reads a DHT11 sensor and serves over HTTP.

## Requirements

- [arduino-cli](https://arduino.github.io/arduino-cli/)
- ESP32 core for arduino-cli

```bash
arduino-cli config init
arduino-cli config add board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
arduino-cli core update-index
arduino-cli core install esp32:esp32
arduino-cli lib install "DHT sensor library"
```

## Configuration

> `credentials.h` is git-ignored. Keep your credentials private and only commit the `.dist` template.

Copy the credentials template and fill in Wi-Fi network:

```bash
# this will create new config if it does not exists
make check-config
```

Fill wifi credentials in `dht11_read/credentials.h`:

## Wiring

| DHT11 | ESP32     |
|-------|-----------|
| VCC   | 3V3       |
| GND   | GND       |
| DATA  | GPIO 13   |

## Build & Upload

```bash
make build    # compile and configure
make deploy   # build and upload to /dev/ttyUSB0
```

To deploy to the board, connect it to USB and run `make deploy`.

## Usage

### Request

```bash
curl http://<device-ip>/
```

### Response

```json
{"temperature":27.2,"humidity":46.1}
```

If the sensor read fails, the response includes an `error` field instead.
