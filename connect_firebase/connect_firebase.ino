#include <Arduino.h>

// Pin GPIO untuk tes PWM
#define TEST_PIN 25
#define TEST_CHANNEL 0
#define PWM_FREQUENCY 5000
#define PWM_RESOLUTION 8

void setup() {
  Serial.begin(115200);

  // Konfigurasi PWM
  ledcSetup(TEST_CHANNEL, PWM_FREQUENCY, PWM_RESOLUTION);
  ledcAttachPin(TEST_PIN, TEST_CHANNEL);

  Serial.println("PWM Test Initialized");
}

void loop() {
  // Fade in
  for (int dutyCycle = 0; dutyCycle <= 255; dutyCycle++) {
    ledcWrite(TEST_CHANNEL, dutyCycle);
    delay(10);
  }

  // Fade out
  for (int dutyCycle = 255; dutyCycle >= 0; dutyCycle--) {
    ledcWrite(TEST_CHANNEL, dutyCycle);
    delay(10);
  }
}
