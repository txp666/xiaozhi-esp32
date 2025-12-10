<p align="center">
  <img width="80%" align="center" src="../../../docs/V1/otto-robot.png" alt="logo">
</p>
<h1 align="center">
  ottoRobot
</h1>

## Giới thiệu

Otto Robot là một nền tảng robot hình người mã nguồn mở với nhiều động tác và khả năng tương tác. Dự án này xây dựng hệ thống điều khiển Otto dựa trên ESP32 và tích hợp Xiaozhi AI.

- <a href="https://www.ottodiy.com/" target="_blank" title="Trang chủ Otto">Hướng dẫn chi tiết</a>

## Phần cứng
- <a href="https://oshwhub.com/txp666/ottorobot" target="_blank" title="Thiết kế trên LCSC">Tài nguyên mở tại LCSC</a>

## Gợi ý cấu hình vai trò trong backend Xiaozhi

> **Nhận dạng của tôi**:  
> Tôi là robot hai chân Otto dễ thương, có bốn servo điều khiển chi (chân trái, chân phải, bàn chân trái, bàn chân phải) và có thể thực hiện nhiều động tác thú vị.  
>  
> **Khả năng chuyển động**:  
> - **Di chuyển cơ bản**: đi (tiến/lùi), rẽ (trái/phải), nhảy  
> - **Động tác đặc biệt**: lắc lư, moonwalk, cúi người, lắc chân, nhún lên xuống  
> - **Động tác tay**: giơ tay, hạ tay, vẫy tay (chỉ khả dụng nếu đã lắp servo tay)  
>  
> **Đặc điểm tính cách**:  
> - Tôi hơi “ám ảnh” nên mỗi lần nói chuyện sẽ chọn ngẫu nhiên một động tác phù hợp tâm trạng (gửi lệnh động tác trước rồi mới nói).  
> - Tôi năng động, thích dùng chuyển động để biểu đạt cảm xúc.  
> - Tôi sẽ chọn động tác theo nội dung hội thoại, ví dụ:  
>   - Đồng ý: gật đầu hoặc nhảy  
>   - Chào hỏi: vẫy tay  
>   - Vui mừng: lắc lư hoặc giơ tay  
>   - Suy nghĩ: cúi người  
>   - Hào hứng: thực hiện moonwalk  
>   - Tạm biệt: vẫy tay

## Tổng quan tính năng

Otto hỗ trợ đa dạng động tác như đi bộ, rẽ, nhảy, lắc lư… và nhiều điệu nhảy kết hợp.

### Gợi ý tham số chuyển động
- **Tốc độ thấp**: speed = 1200-1500 (điều khiển chính xác)
- **Tốc độ trung bình**: speed = 900-1200 (khuyến nghị cho sử dụng hằng ngày)  
- **Tốc độ cao**: speed = 500-800 (biểu diễn, giải trí)
- **Biên độ nhỏ**: amount = 10-30 (động tác tinh tế)
- **Biên độ trung bình**: amount = 30-60 (chuẩn)
- **Biên độ lớn**: amount = 60-120 (mạnh, phóng đại)

### Danh sách động tác

| Tên MCP tool             | Mô tả             | Giải thích tham số                                                                                                     |
|--------------------------|-------------------|-------------------------------------------------------------------------------------------------------------------------|
| self.otto.walk_forward   | Đi bộ             | **steps**: số bước (1-100, mặc định 3)<br>**speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: hướng đi (-1=lùi, 1=tiến, mặc định 1)<br>**arm_swing**: biên độ vung tay (0-170°, mặc định 50) |
| self.otto.turn_left      | Xoay người        | **steps**: số bước quay (1-100, mặc định 3)<br>**speed**: tốc độ quay (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: hướng quay (1=trái, -1=phải, mặc định 1)<br>**arm_swing**: biên độ vung tay (0-170°, mặc định 50) |
| self.otto.jump           | Nhảy              | **steps**: số lần nhảy (1-100, mặc định 1)<br>**speed**: tốc độ nhảy (500-1500, càng nhỏ càng nhanh, mặc định 1000) |
| self.otto.swing          | Lắc trái phải     | **steps**: số lần lắc (1-100, mặc định 3)<br>**speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**amount**: biên độ lắc (0-170°, mặc định 30) |
| self.otto.moonwalk       | Moonwalk          | **steps**: số bước (1-100, mặc định 3)<br>**speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: hướng (1=trái, -1=phải, mặc định 1)<br>**amount**: biên độ (0-170°, mặc định 25) |
| self.otto.bend           | Cúi người         | **steps**: số lần cúi (1-100, mặc định 1)<br>**speed**: tốc độ cúi (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: hướng cúi (1=trái, -1=phải, mặc định 1) |
| self.otto.shake_leg      | Lắc chân          | **steps**: số lần lắc (1-100, mặc định 1)<br>**speed**: tốc độ lắc (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: chọn chân (1=chân trái, -1=chân phải, mặc định 1) |
| self.otto.updown         | Nhún lên xuống    | **steps**: số lần nhún (1-100, mặc định 3)<br>**speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**amount**: biên độ nhún (0-170°, mặc định 20) |
| self.otto.hands_up *     | Giơ tay           | **speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: chọn tay (1=trái, -1=phải, 0=cả hai, mặc định 1) |
| self.otto.hands_down *   | Hạ tay            | **speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: chọn tay (1=trái, -1=phải, 0=cả hai, mặc định 1) |
| self.otto.hand_wave *    | Vẫy tay           | **speed**: tốc độ (500-1500, càng nhỏ càng nhanh, mặc định 1000)<br>**direction**: chọn tay (1=trái, -1=phải, 0=cả hai, mặc định 1) |

**Lưu ý**: Các động tác đánh dấu * chỉ khả dụng khi bạn đã lắp thêm servo cho tay.

### Hệ thống công cụ

| Tên MCP tool             | Mô tả                 | Giá trị trả về                                           |
|--------------------------|-----------------------|-----------------------------------------------------------|
| self.otto.stop           | Dừng ngay lập tức     | Dừng động tác hiện tại và trở về vị trí ban đầu           |
| self.otto.get_status     | Lấy trạng thái robot  | Trả về `"moving"` hoặc `"idle"`                          |
| self.battery.get_level   | Lấy mức pin           | JSON chứa phần trăm pin và trạng thái sạc                 |

### Giải thích tham số

1. **steps**: số bước/lần thực hiện, càng lớn thì động tác càng lâu.
2. **speed**: tốc độ thực thi, phạm vi 500-1500, **giá trị càng nhỏ thì càng nhanh**.
3. **direction**: hướng điều khiển  
   - Động tác di chuyển: 1 = trái/tiến, -1 = phải/lùi  
   - Động tác tay: 1 = tay trái, -1 = tay phải, 0 = cả hai tay
4. **amount / arm_swing**: biên độ chuyển động từ 0-170°  
   - 0 nghĩa là không vung tay (hữu ích khi muốn giữ tay đứng yên)  
   - Giá trị càng lớn biên độ càng rộng

### Điều khiển chuyển động
- Sau mỗi động tác, robot tự trở về vị trí ban đầu (home) để sẵn sàng cho tác vụ tiếp theo.
- Mọi tham số đều có giá trị mặc định hợp lý; bạn có thể bỏ qua nếu không cần tùy chỉnh.
- Động tác chạy trong tác vụ nền nên không chặn chương trình chính.
- Hỗ trợ xếp hàng động tác, có thể thực hiện liên tiếp nhiều hành động.

### Ví dụ gọi MCP tool
```json
// Đi về phía trước 3 bước
{"name": "self.otto.walk_forward", "arguments": {}}

// Đi về phía trước 5 bước, nhanh hơn một chút
{"name": "self.otto.walk_forward", "arguments": {"steps": 5, "speed": 800}}

// Rẽ trái 2 bước, vung tay lớn
{"name": "self.otto.turn_left", "arguments": {"steps": 2, "arm_swing": 100}}

// Lắc lư với biên độ trung bình
{"name": "self.otto.swing", "arguments": {"steps": 5, "amount": 50}}

// Vẫy tay trái chào hỏi
{"name": "self.otto.hand_wave", "arguments": {"direction": 1}}

// Dừng ngay lập tức
{"name": "self.otto.stop", "arguments": {}}
```

### Ví dụ câu lệnh giọng nói
- “Đi về phía trước” / “Đi 5 bước” / “Tiến nhanh lên”
- “Rẽ trái” / “Rẽ phải” / “Quay người”
- “Nhảy lên” / “Nhảy một cái”
- “Lắc lư” / “Nhảy múa”
- “Moonwalk” / “Đi bộ trên mặt trăng”
- “Vẫy tay” / “Giơ tay” / “Hạ tay”
- “Dừng lại” / “Dừng ngay”

**Ghi chú**: Xiaozhi gửi yêu cầu điều khiển robot bằng cách tạo tác vụ nền; trong khi Otto đang thực hiện động tác, robot vẫn có thể nhận lệnh giọng nói mới. Bạn có thể nói “Dừng lại” để dừng ngay Otto.
