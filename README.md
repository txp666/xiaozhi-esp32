# 小智 AI 聊天机器人 — 期末作业参考代码

> 🎓 **ESP32-S3 OttoRobot 形态 | ESP-IDF 5.3.2 适配版**
>
> 基于 [78/xiaozhi-esp32](https://github.com/78/xiaozhi-esp32) v2.2.4 修改，使其可在 **Ubuntu + ESP-IDF 5.3.2** 环境下编译运行。

---

## 📋 项目简介

本项目是 [小智 AI 聊天机器人](https://github.com/78/xiaozhi-esp32) 的**课程适配版本**。原始项目要求 ESP-IDF >= 5.5.2，但学校/个人环境通常安装的是较旧的 5.3.2。本仓库对依赖版本、第三方组件及部分源码进行了**完整降级适配**，使其可以在 IDF 5.3.2 下成功编译。

### 核心功能（与原版一致）

- 🌐 Wi-Fi 连接 + 4G 网络（ML307）
- 🎤 离线语音唤醒（ESP-SR）
- 🤖 流式 ASR → LLM → TTS 语音对话
- 🖥️ OLED / LCD 屏幕显示、表情动画
- 🔋 电池电量检测
- 🌍 多语言支持（中/英/日）
- 🐶 OttoRobot 形态支持（本分支重点适配）

---

## 🔧 环境要求

| 工具 | 版本 | 说明 |
|------|------|------|
| **Ubuntu** | 22.04 / 24.04 | 推荐，其他 Linux 发行版亦可 |
| **ESP-IDF** | **v5.3.2** | ⚠️ 必须使用此版本，其他版本需自行调整 |
| **目标芯片** | ESP32-S3 | OttoRobot / 面包板通用 |
| **Python** | 3.8+ | ESP-IDF 依赖 |
| **Git** | 2.x | 克隆仓库 |

### 安装 ESP-IDF 5.3.2

```bash
# 克隆 ESP-IDF
cd ~
git clone -b v5.3.2 --recursive https://github.com/espressif/esp-idf.git

# 安装工具链
cd esp-idf
./install.sh esp32s3

# 激活环境（每次新终端都要执行）
source ~/esp-idf/export.sh
```

---

## 🚀 快速开始

### 1. 克隆仓库

```bash
cd ~/code
git clone https://github.com/<你的GitHub>/final_pro_xiaozhi_robot.git
cd final_pro_xiaozhi_robot/esp/xiaozhi-esp32
```

### 2. 激活 ESP-IDF 环境

```bash
source ~/esp-idf/export.sh
```

### 3. 设定目标芯片

```bash
idf.py set-target esp32s3
```

### 4. 打开配置菜单（可选）

```bash
idf.py menuconfig
```

> 在 `XIAOZHI Assistant` → `Board Type` 中选择你的板子类型（如 Otto Robot）。

### 5. 编译 & 烧录

```bash
# 只编译
idf.py build

# 编译 + 烧录 + 串口监视
idf.py build flash monitor
```

---

## 🔄 从原始项目做了哪些修改？

### 一、依赖版本降级 (`main/idf_component.yml`)

| 组件 | 原始版本 | 适配版本 | 原因 |
|------|----------|----------|------|
| `idf` | `>=5.5.2` | `>=5.3.0` | 当前 IDF 为 5.3.2 |
| `espressif/esp_lcd_co5300` | `^2.0.3` | `~1.0.0` | v2.x 要求 IDF >=5.4 |
| `78/esp-ml307` | `~3.6.4` | `>=3.0.0,<3.6.0` | v3.6.x 要求 IDF >=5.5.2 |
| `78/uart-eth-modem` | `~0.3.3` | `>=0.1.0,<0.3.0` | v0.3.x 要求 IDF >=5.5.2 |
| `espressif/esp_video` | `==1.3.1` | **已删除** | 支持 S3 的版本全线要求 IDF >=5.4 |

> 完整依赖清单见 [`DEPENDENCY_CHANGES.txt`](DEPENDENCY_CHANGES.txt)

### 二、源码适配修改

| 文件 | 改动 | 原因 |
|------|------|------|
| `CMakeLists.txt` | 添加 `-Wno-error=maybe-uninitialized` 和 `-Wno-missing-field-initializers` | 第三方组件 freetype 编译警告转错误 |
| `main/CMakeLists.txt` | S3 下移除 `esp_video.cc` 编译 | esp_video 组件已删除 |
| `main/idf_component.yml` | 移除 `espressif/esp_video` 依赖块 | IDF 5.3 + S3 无兼容版本 |
| `managed_components/espressif__freetype/.../ttsvg.c` | `doc_length` 初始化为 0 | 修复 `-Wmaybe-uninitialized` |
| `managed_components/78__esp-wifi-connect/wifi_configuration_ap.cc` | `esp_wifi_set_band_mode()` 包裹 `#if ESP_IDF_VERSION >= 5.4` | API 5.4+ 才存在 |
| `managed_components/78__uart-eth-modem/src/uart_eth_modem.cc` | 移除 `.allow_pd = 0` | 字段 5.4+ 才存在 |
| `managed_components/78__uart-eth-modem/src/uart_uhci.cc` | **整体桩化**为 11 个空壳函数 | UHCI 底层与 5.3 不兼容 |
| `managed_components/tny-robotics__sh1106-.../esp_lcd_panel_sh1106.c` | 注释 `ESP_COMPILER_DIAGNOSTIC_PUSH/POP` | 宏 5.4+ 才引入 |
| `managed_components/espressif__esp_lcd_co5300/esp_lcd_co5300.c` | 添加 `(void)vendor_config;` | 消除 unused-variable 警告 |
| `main/display/lvgl_display/jpg/image_to_jpeg.h` | S3 不再 `#include <linux/videodev2.h>` | ESP-IDF 无 Linux 头文件 |
| `main/boards/common/esp_video.h` | 注释 `#include "esp_video_init.h"` 和构造函数 | esp_video 组件已删除 |
| `main/boards/otto-robot/otto_robot.cc` | `InitializeCamera()` 清空返回 `false` | 无摄像头硬件 |
| `main/boards/otto-robot/websocket_control_server.cc` | `ws_handler`/`Start` 桩化 | `CONFIG_HTTPD_WS_SUPPORT` 未开启 |
| `main/boards/otto-robot/config.h` | `#include <driver/adc.h>` 包裹 `#pragma GCC diagnostic` | Legacy ADC 废弃警告 |
| `main/assets.cc` | `esp_partition_get_main_flash_sector_size()` → `4096` | API 5.4+ 才存在 |
| `main/boards/common/esp32_camera.cc` | `%ld` → `%d` | 格式字符串匹配 |

### 三、构建配置 (`CMakeLists.txt` 根目录)

```cmake
cmake_minimum_required(VERSION 3.16)
add_compile_options(-Wno-missing-field-initializers)
add_compile_options(-Wno-error=maybe-uninitialized)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
idf_build_set_property(MINIMAL_BUILD ON)
set(PROJECT_VER "2.2.4")
project(xiaozhi)
```

---

## ⚠️ 已知限制

| 限制 | 说明 |
|------|------|
| **无摄像头** | `esp_video` 组件已完全移除，`InitializeCamera()` 返回 `false` |
| **无 WebSocket 网页控制** | `websocket_control_server.cc` 已桩化 |
| **无 UHCI DMA** | `uart_uhci.cc` 已桩化（WiFi 形态不受影响） |
| **仅 ESP32-S3** | 其他芯片未测试，可能需要额外适配 |
| **ESP-IDF 5.3.2 限定** | 其他 IDF 版本不保证可编译 |

---

## 📁 关键文件结构

```
xiaozhi-esp32/
├── CMakeLists.txt              # 根构建配置（含警告屏蔽）
├── DEPENDENCY_CHANGES.txt      # 详细依赖修改记录
├── README_ORIGINAL.md          # 原始项目 README（备份）
├── main/
│   ├── idf_component.yml       # 组件依赖清单（已降级）
│   ├── CMakeLists.txt          # 主程序构建（已移除 esp_video.cc）
│   ├── assets.cc               # 资源管理（flash 扇区大小修复）
│   ├── boards/
│   │   ├── common/
│   │   │   ├── esp_video.h     # 视频类（已屏蔽）
│   │   │   └── esp32_camera.cc # 摄像头（格式修复）
│   │   └── otto-robot/
│   │       ├── config.h        # ADC 头文件（警告消除）
│   │       ├── otto_robot.cc   # 初始化逻辑（摄像头清空）
│   │       └── websocket_control_server.cc  # WebSocket（已桩化）
│   └── display/lvgl_display/jpg/
│       └── image_to_jpeg.h     # JPEG 编码（V4L2 头文件修复）
├── managed_components/         # 第三方组件（多处源码修复）
│   ├── 78__esp-wifi-connect/   # WiFi AP 配置
│   ├── 78__uart-eth-modem/     # 以太网模组（UHCI 已桩化）
│   ├── espressif__freetype/    # 字体渲染
│   ├── espressif__esp_lcd_co5300/  # LCD 驱动
│   └── tny-robotics__sh1106-esp-idf/  # OLED 驱动
└── sdkconfig.defaults          # 默认 Kconfig 配置
```

---

## 🔍 常见问题

### Q: `idf.py set-target esp32s3` 报 version solving failed？

A: 确认 `main/idf_component.yml` 没有被覆盖。执行前务必清理缓存：
```bash
rm -rf build dependencies.lock managed_components
```

### Q: 编译报 `#include <linux/videodev2.h>` 找不到？

A: 确认 `main/display/lvgl_display/jpg/image_to_jpeg.h` 中 ESP32-S3 不走 `#include <linux/videodev2.h>` 分支。

### Q: 如何切换板子类型？

A: 运行 `idf.py menuconfig` → `XIAOZHI Assistant` → `Board Type` 选择你的硬件。

### Q: 如何恢复原始 README？

A: 原始 README 备份在 `README_ORIGINAL.md`，包含原项目的完整介绍、硬件列表、功能说明。

### Q: 想恢复原版 xiaozhi-esp32？

A: 将 ESP-IDF 升级到 5.5.2，还原 `main/idf_component.yml` 中的原始版本，撤销所有源码修改。

---

## 🙏 致谢

- 原始项目 [78/xiaozhi-esp32](https://github.com/78/xiaozhi-esp32)
- 虾哥及小智社区的所有贡献者
- ESP-IDF 框架 [espressif/esp-idf](https://github.com/espressif/esp-idf)

---

> 📝 **期末作业提示**：本文档可作为课程报告附录。请结合自己的硬件接线图、实际运行截图、以及个人理解补充到报告中。建议同时提交 [`DEPENDENCY_CHANGES.txt`](DEPENDENCY_CHANGES.txt) 作为修改记录附件。
