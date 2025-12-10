# Hướng dẫn sử dụng giao thức MCP cho điều khiển IoT

> Tài liệu này mô tả cách hiện thực điều khiển IoT trên thiết bị ESP32 dựa vào giao thức MCP. Quy trình chi tiết của giao thức vui lòng xem [`mcp-protocol.md`](./mcp-protocol.md).

## Giới thiệu

MCP (Model Context Protocol) là giao thức thế hệ mới được khuyến nghị dùng trong điều khiển IoT. Nó sử dụng định dạng JSON-RPC 2.0 chuẩn để giúp backend phát hiện và gọi các “tool” trên thiết bị, qua đó điều khiển thiết bị linh hoạt.

## Quy trình sử dụng điển hình

1. Sau khi khởi động, thiết bị kết nối với backend thông qua giao thức cơ sở (WebSocket/MQTT).
2. Backend gọi phương thức `initialize` của MCP để khởi tạo phiên làm việc.
3. Backend gọi `tools/list` để lấy toàn bộ danh sách tool (chức năng) cùng mô tả tham số mà thiết bị hỗ trợ.
4. Backend gọi `tools/call` với tool cụ thể để điều khiển thiết bị.

Định dạng thông điệp và trình tự tương tác xem tại [`mcp-protocol.md`](./mcp-protocol.md).

## Ghi chú về việc đăng ký tool ở phía thiết bị

Thiết bị đăng ký các tool có thể được backend gọi thông qua `McpServer::AddTool`. Chữ ký hàm thường dùng:

```cpp
void AddTool(
    const std::string& name,           // Tên tool, nên duy nhất và có cấu trúc, ví dụ self.dog.forward
    const std::string& description,    // Mô tả tool, ngắn gọn giúp mô hình dễ hiểu
    const PropertyList& properties,    // Danh sách tham số đầu vào (có thể rỗng), hỗ trợ bool/int/string
    std::function<ReturnValue(const PropertyList&)> callback // Hàm callback được chạy khi tool bị gọi
);
```
- name: Định danh duy nhất của tool, khuyến nghị đặt theo dạng “module.chức_năng”.
- description: Mô tả tự nhiên giúp AI/người dùng hiểu nhanh.
- properties: Danh sách tham số, hỗ trợ bool/int/string, có thể chỉ định phạm vi và giá trị mặc định.
- callback: Logic thực thi khi nhận yêu cầu gọi, trả về bool/int/string tùy nhu cầu.

## Ví dụ đăng ký điển hình (ESP-Hi)

```cpp
void InitializeTools() {
    auto& mcp_server = McpServer::GetInstance();
    // Ví dụ 1: Không có tham số, điều khiển robot tiến về phía trước
    mcp_server.AddTool("self.dog.forward", "Robot di chuyển về phía trước", PropertyList(), [this](const PropertyList&) -> ReturnValue {
        servo_dog_ctrl_send(DOG_STATE_FORWARD, NULL);
        return true;
    });
    // Ví dụ 2: Có tham số, đặt màu RGB cho đèn
    mcp_server.AddTool("self.light.set_rgb", "Thiết lập màu RGB", PropertyList({
        Property("r", kPropertyTypeInteger, 0, 255),
        Property("g", kPropertyTypeInteger, 0, 255),
        Property("b", kPropertyTypeInteger, 0, 255)
    }), [this](const PropertyList& properties) -> ReturnValue {
        int r = properties["r"].value<int>();
        int g = properties["g"].value<int>();
        int b = properties["b"].value<int>();
        led_on_ = true;
        SetLedColor(r, g, b);
        return true;
    });
}
```

## Ví dụ JSON-RPC phổ biến khi gọi tool

### 1. Lấy danh sách tool
```json
{
  "jsonrpc": "2.0",
  "method": "tools/list",
  "params": { "cursor": "" },
  "id": 1
}
```

### 2. Điều khiển khung gầm tiến về trước
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "self.chassis.go_forward",
    "arguments": {}
  },
  "id": 2
}
```

### 3. Chuyển chế độ đèn
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "self.chassis.switch_light_mode",
    "arguments": { "light_mode": 3 }
  },
  "id": 3
}
```

### 4. Lật góc camera
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "self.camera.set_camera_flipped",
    "arguments": {}
  },
  "id": 4
}
```

## Ghi chú
- Tên tool, tham số và giá trị trả về lấy theo đăng ký `AddTool` ở phía thiết bị.
- Khuyến nghị tất cả dự án mới thống nhất dùng giao thức MCP để điều khiển IoT.
- Các thông tin chi tiết và nâng cao vui lòng tham khảo [`mcp-protocol.md`](./mcp-protocol.md).
