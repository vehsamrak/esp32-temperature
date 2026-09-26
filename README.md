# ESP32 Temperature & Humidity Monitor

Reads a DHT11 sensor and serves over HTTP as json or Prometheus output

<img width="600" height="668" alt="photo-1" src="https://github.com/user-attachments/assets/9ce77b8d-ccb6-4daf-8e4f-4a8551f5fed6" />
<img width="1000" height="250" alt="grafana_small" src="https://github.com/user-attachments/assets/8eb1c8e5-2439-4430-b3d7-966179c9f893" />

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

Fill wifi credentials in `dht11/credentials.h`:

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
make monitor  # tail for microcontroller output log (must be connected as USB)
```

To deploy to the board, connect it to USB and run `make deploy`.

## Usage

### Json

```bash
curl http://<device-ip>
```

### Response

```json
{"temperature":27.2,"humidity":46.1}
```

If the sensor read fails, the response includes an `error` field instead.

### Prometheus metrics

```bash
curl http://<device-ip>/metrics
```

### Response

```
# TYPE temperature gauge
temperature 27.20
# TYPE humidity gauge
humidity 46.10
```

## Local monitoring

To view the metrics locally, Prometheus + Grafana are available in `monitoring/`.

```bash
make monitoring          # start grafana and prometheus
make monitoring-stop     # stop it
```

Open `http://localhost:3000` login/pass: admin/admin.
Dashboard with temperature and humidity provisioned automatically. Prometheus scrapes the device at `http://<device-ip>/metrics`.

Configure your device IP in `.env` (created automatically from `.env.dist` on first run):

```
ESP32_IP=192.168.0.100
```
