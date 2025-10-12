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

## 🧩 2. Cấu Trúc Dự Án
xiaozhi-esp32-OTTO/
├── main/
│   ├── display/
│   │   └── lvgl_display/      # Giao diện LVGL
│   ├── assets/                # Ngôn ngữ, âm thanh, hình ảnh
│   └── main.cc                # Điểm khởi đầu chương trình
├── components/                # Thư viện mở rộng
├── scripts/                   # Script sinh mã tự động
│   └── gen_lang.py            # Sinh file lang_config.h
├── sdkconfig.defaults
├── CMakeLists.txt
└── README_vi.md
