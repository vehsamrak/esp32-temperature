#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include "credentials.h"

#define DHTPIN 13
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);
WebServer server(80);

float temperature = 0.0;
float humidity = 0.0;

void handleRoot() {
  StaticJsonDocument<128> data;

  if (isnan(temperature) || isnan(humidity)) {
    data["error"] = "sensor read error";
  } else {
    data["temperature"] = temperature;
    data["humidity"] = humidity;
  }

  char response[128];
  serializeJson(data, response);
  server.send(200, "application/json", response);
}

void handleNotFound() {
  StaticJsonDocument<64> data;
  data["error"] = "not found";

  char response[64];
  serializeJson(data, response);
  server.send(404, "application/json", response);
}

void setup() {
  Serial.begin(115200);
  dht.begin();

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println();
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.onNotFound(handleNotFound);
  server.begin();

  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();

  temperature = dht.readTemperature();
  humidity = dht.readHumidity();

  Serial.print("IP: ");
  Serial.print(WiFi.localIP());
  Serial.print(", Temperature: ");
  Serial.print(temperature);
  Serial.print(" C, Humidity: ");
  Serial.println(humidity);

  delay(5000);
}
