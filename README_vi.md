# Chatbot dựa trên MCP

（Tiếng Việt | [English](README_en.md) 

## Giới thiệu

👉 [Người dùng: gắn camera cho AI vs AI: phát hiện chủ nhân 3 ngày chưa gội đầu【bilibili】](https://www.bilibili.com/video/BV1bpjgzKEhd/)

👉 [Tự tay dựng “AI bạn gái” – hướng dẫn cho người mới【bilibili】](https://www.bilibili.com/video/BV1XnmFYLEJN/)

Xiaozhi AI Chatbot là cổng giao tiếp giọng nói tận dụng các mô hình lớn như Qwen / DeepSeek và sử dụng giao thức MCP để điều khiển đa thiết bị.

<img src="docs/mcp-based-graph.jpg" alt="Điều khiển vạn vật qua MCP" width="320">

### Thông tin phiên bản

Phiên bản v2 hiện tại không tương thích bảng phân vùng với v1, vì vậy không thể nâng cấp OTA trực tiếp từ v1 lên v2. Xem chi tiết bảng phân vùng tại [partitions/v2/README.md](partitions/v2/README.md).

Tất cả phần cứng dùng v1 đều có thể tự ghi flash để nâng cấp lên v2.

V1 ổn định ở bản 1.9.2, có thể chuyển về bằng `git checkout v1`. Nhánh này sẽ tiếp tục được bảo trì đến tháng 2/2026.

### Tính năng đã hoàn thành

- Wi-Fi / ML307 Cat.1 4G
- Đánh thức bằng giọng offline [ESP-SR](https://github.com/espressif/esp-sr)
- Hỗ trợ hai giao thức truyền thông ([WebSocket](docs/websocket.md) hoặc MQTT+UDP)
- Mã hóa âm thanh OPUS
- Kiến trúc tương tác giọng nói dựa trên ASR + LLM + TTS dạng streaming
- Nhận diện giọng nói người nói hiện tại [3D Speaker](https://github.com/modelscope/3D-Speaker)
- Màn hình OLED / LCD với biểu cảm động
- Hiển thị pin và quản lý nguồn
- Đa ngôn ngữ (Trung, Anh, Nhật)
- Hỗ trợ nền tảng ESP32-C3, ESP32-S3, ESP32-P4
- Điều khiển thiết bị qua MCP chạy trên thiết bị (âm lượng, ánh sáng, động cơ, GPIO…)
- Mở rộng năng lực mô hình lớn qua MCP trên đám mây (điều khiển nhà thông minh, thao tác PC, tìm kiếm tri thức, email…)
- Tùy chỉnh wake word, phông chữ, emoji và nền trò chuyện qua công cụ web ([Trình tạo Assets tùy chỉnh](https://github.com/78/xiaozhi-assets-generator))

## Phần cứng

### Thực hành thủ công với breadboard

Xem hướng dẫn chi tiết trong tài liệu Feishu:

👉 [“Bách khoa toàn thư Xiaozhi AI Chatbot”](https://ccnphfhqs21z.feishu.cn/wiki/F5krwD16viZoF0kKkvDcrZNYnhb?from=from_copylink)

Ảnh mẫu breadboard:

![Breadboard](docs/v1/wiring2.jpg)

### Hỗ trợ hơn 70 phần cứng mã nguồn mở (liệt kê một phần)

- <a href="https://oshwhub.com/li-chuang-kai-fa-ban/li-chuang-shi-zhan-pai-esp32-s3-kai-fa-ban" target="_blank" title="Lichuang ESP32-S3 Board">立创·实战派 ESP32-S3 开发板</a>
- <a href="https://github.com/espressif/esp-box" target="_blank" title="Espressif ESP32-S3-BOX3">乐鑫 ESP32-S3-BOX3</a>
- <a href="https://docs.m5stack.com/zh_CN/core/CoreS3" target="_blank" title="M5Stack CoreS3">M5Stack CoreS3</a>
- <a href="https://docs.m5stack.com/en/atom/Atomic%20Echo%20Base" target="_blank" title="AtomS3R + Echo Base">M5Stack AtomS3R + Echo Base</a>
- <a href="https://gf.bilibili.com/item/detail/1108782064" target="_blank" title="Magic Button 2.4">神奇按钮 2.4</a>
- <a href="https://www.waveshare.net/shop/ESP32-S3-Touch-AMOLED-1.8.htm" target="_blank" title="Waveshare ESP32-S3-Touch-AMOLED-1.8">微雪电子 ESP32-S3-Touch-AMOLED-1.8</a>
- <a href="https://github.com/Xinyuan-LilyGO/T-Circle-S3" target="_blank" title="LILYGO T-Circle-S3">LILYGO T-Circle-S3</a>
- <a href="https://oshwhub.com/tenclass01/xmini_c3" target="_blank" title="XiaGe Mini C3">虾哥 Mini C3</a>
- <a href="https://oshwhub.com/movecall/cuican-ai-pendant-lights-up-y" target="_blank" title="Movecall CuiCan ESP32S3">璀璨·AI 吊坠</a>
- <a href="https://github.com/WMnologo/xingzhi-ai" target="_blank" title="WMnologo XingZhi 1.54">无名科技 Nologo-星智-1.54TFT</a>
- <a href="https://www.seeedstudio.com/SenseCAP-Watcher-W1-A-p-5979.html" target="_blank" title="SenseCAP Watcher">SenseCAP Watcher</a>
- <a href="https://www.bilibili.com/video/BV1BHJtz6E2S/" target="_blank" title="ESP-HI Robot Dog">ESP-HI 超低成本机器狗</a>

<div style="display: flex; justify-content: space-between;">
  <a href="docs/v1/lichuang-s3.jpg" target="_blank" title="Lichuang ESP32-S3">
    <img src="docs/v1/lichuang-s3.jpg" width="240" />
  </a>
  <a href="docs/v1/espbox3.jpg" target="_blank" title="ESP32-S3-BOX3">
    <img src="docs/v1/espbox3.jpg" width="240" />
  </a>
  <a href="docs/v1/m5cores3.jpg" target="_blank" title="M5Stack CoreS3">
    <img src="docs/v1/m5cores3.jpg" width="240" />
  </a>
  <a href="docs/v1/atoms3r.jpg" target="_blank" title="AtomS3R + Echo Base">
    <img src="docs/v1/atoms3r.jpg" width="240" />
  </a>
  <a href="docs/v1/magiclick.jpg" target="_blank" title="Magic Button 2.4">
    <img src="docs/v1/magiclick.jpg" width="240" />
  </a>
  <a href="docs/v1/waveshare.jpg" target="_blank" title="Waveshare ESP32-S3 Touch AMOLED 1.8">
    <img src="docs/v1/waveshare.jpg" width="240" />
  </a>
  <a href="docs/v1/lilygo-t-circle-s3.jpg" target="_blank" title="LILYGO T-Circle-S3">
    <img src="docs/v1/lilygo-t-circle-s3.jpg" width="240" />
  </a>
  <a href="docs/v1/xmini-c3.jpg" target="_blank" title="XiaGe Mini C3">
    <img src="docs/v1/xmini-c3.jpg" width="240" />
  </a>
  <a href="docs/v1/movecall-cuican-esp32s3.jpg" target="_blank" title="CuiCan Pendant">
    <img src="docs/v1/movecall-cuican-esp32s3.jpg" width="240" />
  </a>
  <a href="docs/v1/wmnologo_xingzhi_1.54.jpg" target="_blank" title="WMnologo XingZhi 1.54">
    <img src="docs/v1/wmnologo_xingzhi_1.54.jpg" width="240" />
  </a>
  <a href="docs/v1/sensecap_watcher.jpg" target="_blank" title="SenseCAP Watcher">
    <img src="docs/v1/sensecap_watcher.jpg" width="240" />
  </a>
  <a href="docs/v1/esp-hi.jpg" target="_blank" title="ESP-HI Robot Dog">
    <img src="docs/v1/esp-hi.jpg" width="240" />
  </a>
</div>

## Phần mềm

### Ghi firmware

Nếu lần đầu làm quen, bạn có thể bỏ qua việc dựng môi trường phát triển và chỉ cần ghi firmware sẵn có.

Firmware mặc định kết nối đến máy chủ chính thức [xiaozhi.me](https://xiaozhi.me). Người dùng cá nhân đăng ký tài khoản sẽ được dùng miễn phí mô hình Qwen Realtime.

👉 [Hướng dẫn ghi firmware cho người mới](https://ccnphfhqs21z.feishu.cn/wiki/Zpz4wXBtdimBrLk25WdcXzxcnNS)

### Môi trường phát triển

- Cursor hoặc VSCode
- Cài plugin ESP-IDF, chọn SDK version 5.4 trở lên
- Linux thuận tiện hơn Windows (tốc độ build nhanh, không lo driver)
- Dự án tuân thủ phong cách Google C++; hãy đảm bảo mã nguồn tuân chuẩn trước khi gửi PR

### Tài liệu cho nhà phát triển

- [Hướng dẫn tùy chỉnh bo mạch](docs/custom-board.md) – tạo bo riêng cho Xiaozhi AI
- [Hướng dẫn sử dụng MCP cho điều khiển IoT](docs/mcp-usage.md) – nắm cách điều khiển thiết bị qua MCP
- [Quy trình tương tác MCP](docs/mcp-protocol.md) – chi tiết hiện thực MCP trên thiết bị
- [Tài liệu giao thức MQTT + UDP](docs/mqtt-udp.md)
- [Tài liệu giao thức WebSocket](docs/websocket.md)

## Cấu hình mô hình lớn

Nếu bạn đã sở hữu thiết bị Xiaozhi AI và kết nối với máy chủ chính thức, hãy đăng nhập bảng điều khiển tại [xiaozhi.me](https://xiaozhi.me) để cấu hình.

👉 [Video hướng dẫn (giao diện cũ)](https://www.bilibili.com/video/BV1jUCUY2EKM/)

## Dự án mã nguồn mở liên quan

Muốn tự vận hành máy chủ trên PC cá nhân? Tham khảo các dự án sau:

- [xinnan-tech/xiaozhi-esp32-server](https://github.com/xinnan-tech/xiaozhi-esp32-server) – server Python
- [joey-zhou/xiaozhi-esp32-server-java](https://github.com/joey-zhou/xiaozhi-esp32-server-java) – server Java
- [AnimeAIChat/xiaozhi-server-go](https://github.com/AnimeAIChat/xiaozhi-server-go) – server Golang

Client bên thứ ba sử dụng giao thức Xiaozhi:

- [huangjunsen0406/py-xiaozhi](https://github.com/huangjunsen0406/py-xiaozhi) – client Python
- [TOM88812/xiaozhi-android-client](https://github.com/TOM88812/xiaozhi-android-client) – client Android
- [100askTeam/xiaozhi-linux](http://github.com/100askTeam/xiaozhi-linux) – client Linux của 100ask
- [78/xiaozhi-sf32](https://github.com/78/xiaozhi-sf32) – firmware chip Bluetooth của Siche
- [QuecPython/solution-xiaozhiAI](https://github.com/QuecPython/solution-xiaozhiAI) – firmware QuecPython do Quectel cung cấp




