# 🇻🇳 Hướng Dẫn Build Dự Án ESP32 OTTO

## 🚀 Giới Thiệu

Dự án **Xiaozhi ESP32 OTTO** là firmware dành cho thiết bị hiển thị và điều khiển bằng LVGL trên chip **ESP32-S3**, hỗ trợ:
- Giao diện đồ họa LVGL.
- Đa ngôn ngữ (tự động sinh từ JSON).
- Wi-Fi cấu hình và OTA update.
- Âm thanh `.ogg` tích hợp sẵn trong firmware.

---

## 📦 1. Chuẩn Bị Môi Trường

### Cài ESP-IDF
Yêu cầu **ESP-IDF v5.1 trở lên**.

```bash
git clone -b v5.1 --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
./install.sh
. ./export.sh
