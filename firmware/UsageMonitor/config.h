// =====================================================================
//  Claude Usage Monitor – Einstellungen
//  Normalerweise musst du hier NICHTS aendern.
// =====================================================================
#pragma once

// ---- Board-Version ---------------------------------------------------
// Das Waveshare ESP32-S3-LCD-1.69 gibt es als V1 und V2.
// Neue Boards (ab ca. Mitte 2024) sind V2. Wenn das Geraet im
// Akkubetrieb sofort wieder ausgeht, auf 1 stellen und neu flashen.
#define BOARD_VERSION 2

// ---- Pins (aus Waveshare-Unterlagen) ---------------------------------
#define PIN_LCD_DC    4
#define PIN_LCD_CS    5
#define PIN_LCD_SCK   6
#define PIN_LCD_MOSI  7
#define PIN_LCD_RST   8
#define PIN_LCD_BL    15
#define PIN_BAT_ADC   1     // Akkuspannung ueber Spannungsteiler 200k/100k
#define PIN_BOOT_BTN  0     // mittlere Taste "BOOT"

#if BOARD_VERSION == 1
  #define PIN_SYS_EN  35    // haelt den Akkustrom an
  #define PIN_SYS_OUT 36    // liest die PWR-Taste
#else
  #define PIN_SYS_EN  41
  #define PIN_SYS_OUT 40
#endif

// ---- Sprache / Language --------------------------------------------
// 0 = Deutsch, 1 = English
#ifndef LANGUAGE_EN
  #define LANGUAGE_EN 0
#endif

// ---- Verhalten -------------------------------------------------------
#define POLL_INTERVAL_S   120   // alle 2 Minuten neue Werte holen
#define SETUP_AP_NAME     "UsageMonitor-Setup"   // WLAN-Name im Einrichtungsmodus / setup Wi-Fi name
#define DISPLAY_INVERT    true  // falls Farben "negativ" aussehen: false
// Querformat: 1 = Gehaeuse "direkt" (USB oben), 3 = Gehaeuse "hinten" (USB unten).
// Steht das Bild auf dem Kopf, den anderen Wert nehmen.
#ifndef DISPLAY_ROTATION
  #define DISPLAY_ROTATION 1
#endif
#define WARN_PERCENT      75    // ab hier orange
#define CRIT_PERCENT      90    // ab hier rot
