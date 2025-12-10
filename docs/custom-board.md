# Hướng dẫn tùy chỉnh bo mạch

Tài liệu này mô tả cách tạo mới trình khởi tạo bo mạch cho dự án trợ lý giọng nói Xiaozhi AI. Dự án hiện hỗ trợ hơn 70 bo mạch ESP32, mỗi bo mạch có thư mục và mã khởi tạo riêng.

## Lưu ý quan trọng

> **Cảnh báo**: Khi cấu hình IO của bo mạch tùy chỉnh khác với bo mạch gốc, tuyệt đối không sửa đè cấu hình cũ rồi biên dịch firmware. Hãy tạo một loại bo mạch mới, hoặc trong `config.json` dùng các mục `builds` với `name` và macro `sdkconfig` khác nhau. Sử dụng `python scripts/release.py [tên thư mục bo mạch]` để biên dịch và đóng gói.
>
> Nếu sửa đè cấu hình có sẵn, firmware tùy chỉnh có thể bị OTA sau này ghi đè bằng firmware chuẩn và làm thiết bị hỏng. Mỗi bo mạch có định danh và kênh nâng cấp riêng; hãy luôn giữ định danh bo mạch duy nhất.

## Cấu trúc thư mục

Một thư mục bo mạch thường gồm:

- `xxx_board.cc`: mã khởi tạo chính, cấu hình phần cứng và tính năng của bo
- `config.h`: khai báo chân và các tham số phần cứng
- `config.json`: cấu hình biên dịch, chỉ định loại chip và tùy chọn đặc biệt
- `README.md`: tài liệu mô tả bo mạch

## Các bước tạo bo mạch mới

### 1. Tạo thư mục bo mạch

Trong thư mục `boards/`, tạo thư mục mới theo định dạng `[hãng]-[tên-bo]`, ví dụ `m5stack-tab5`:

```bash
mkdir main/boards/my-custom-board
```

### 2. Tạo tệp cấu hình

#### config.h

Định nghĩa toàn bộ cấu hình phần cứng trong `config.h`, bao gồm:

- Tần số lấy mẫu âm thanh và chân I2S
- Địa chỉ codec âm thanh, chân I2C
- Cấu hình nút bấm, LED
- Thông số màn hình và sơ đồ chân

Ví dụ (trích từ `lichuang-c3-dev`):

```c
#ifndef _BOARD_CONFIG_H_
#define _BOARD_CONFIG_H_

#include <driver/gpio.h>

// Cấu hình âm thanh
#define AUDIO_INPUT_SAMPLE_RATE  24000
#define AUDIO_OUTPUT_SAMPLE_RATE 24000

#define AUDIO_I2S_GPIO_MCLK GPIO_NUM_10
#define AUDIO_I2S_GPIO_WS   GPIO_NUM_12
#define AUDIO_I2S_GPIO_BCLK GPIO_NUM_8
#define AUDIO_I2S_GPIO_DIN  GPIO_NUM_7
#define AUDIO_I2S_GPIO_DOUT GPIO_NUM_11

#define AUDIO_CODEC_PA_PIN       GPIO_NUM_13
#define AUDIO_CODEC_I2C_SDA_PIN  GPIO_NUM_0
#define AUDIO_CODEC_I2C_SCL_PIN  GPIO_NUM_1
#define AUDIO_CODEC_ES8311_ADDR  ES8311_CODEC_DEFAULT_ADDR

// Cấu hình nút bấm
#define BOOT_BUTTON_GPIO        GPIO_NUM_9

// Cấu hình màn hình
#define DISPLAY_SPI_SCK_PIN     GPIO_NUM_3
#define DISPLAY_SPI_MOSI_PIN    GPIO_NUM_5
#define DISPLAY_DC_PIN          GPIO_NUM_6
#define DISPLAY_SPI_CS_PIN      GPIO_NUM_4

#define DISPLAY_WIDTH   320
#define DISPLAY_HEIGHT  240
#define DISPLAY_MIRROR_X true
#define DISPLAY_MIRROR_Y false
#define DISPLAY_SWAP_XY true

#define DISPLAY_OFFSET_X  0
#define DISPLAY_OFFSET_Y  0

#define DISPLAY_BACKLIGHT_PIN GPIO_NUM_2
#define DISPLAY_BACKLIGHT_OUTPUT_INVERT true

#endif // _BOARD_CONFIG_H_
```

#### config.json

`config.json` chứa cấu hình cho script `scripts/release.py`:

```json
{
    "target": "esp32s3",  // Loại chip: esp32, esp32s3, esp32c3, esp32c6, esp32p4...
    "builds": [
        {
            "name": "my-custom-board",  // Tên bo mạch, dùng để đặt tên gói firmware
            "sdkconfig_append": [
                // Cấu hình dung lượng Flash
                "CONFIG_ESPTOOLPY_FLASHSIZE_8MB=y",
                // Cấu hình bảng phân vùng
                "CONFIG_PARTITION_TABLE_CUSTOM_FILENAME=\"partitions/v2/8m.csv\""
            ]
        }
    ]
}
```

**Giải thích:**
- `target`: loại chip, phải khớp phần cứng
- `name`: tiền tố của firmware xuất ra, nên trùng với tên thư mục
- `sdkconfig_append`: danh sách dòng cấu hình bổ sung cho sdkconfig mặc định

**Một số cấu hình `sdkconfig_append` thường dùng:**
```json
// Dung lượng Flash
"CONFIG_ESPTOOLPY_FLASHSIZE_4MB=y"
"CONFIG_ESPTOOLPY_FLASHSIZE_8MB=y"
"CONFIG_ESPTOOLPY_FLASHSIZE_16MB=y"

// Bảng phân vùng
"CONFIG_PARTITION_TABLE_CUSTOM_FILENAME=\"partitions/v2/4m.csv\""
"CONFIG_PARTITION_TABLE_CUSTOM_FILENAME=\"partitions/v2/8m.csv\""
"CONFIG_PARTITION_TABLE_CUSTOM_FILENAME=\"partitions/v2/16m.csv\""

// Ngôn ngữ giao diện
"CONFIG_LANGUAGE_EN_US=y"
"CONFIG_LANGUAGE_ZH_CN=y"

// Cấu hình wake word
"CONFIG_USE_DEVICE_AEC=y"        // Bật AEC trên thiết bị
"CONFIG_WAKE_WORD_DISABLED=y"    // Tắt từ khóa đánh thức
```

### 3. Viết mã khởi tạo bo mạch

Tạo file `my_custom_board.cc` và triển khai toàn bộ logic khởi tạo.

Một lớp bo mạch cơ bản gồm:

1. **Khai báo lớp**: kế thừa `WifiBoard` hoặc `Ml307Board`
2. **Hàm khởi tạo**: cấu hình I2C, màn hình, nút bấm, IoT...
3. **Ghi đè hàm ảo**: `GetAudioCodec()`, `GetDisplay()`, `GetBacklight()`...
4. **Đăng ký bo mạch**: dùng macro `DECLARE_BOARD`

```cpp
#include "wifi_board.h"
#include "codecs/es8311_audio_codec.h"
#include "display/lcd_display.h"
#include "application.h"
#include "button.h"
#include "config.h"
#include "mcp_server.h"

#include <esp_log.h>
#include <driver/i2c_master.h>
#include <driver/spi_common.h>

#define TAG "MyCustomBoard"

class MyCustomBoard : public WifiBoard {
private:
    i2c_master_bus_handle_t codec_i2c_bus_;
    Button boot_button_;
    LcdDisplay* display_;

    // Khởi tạo I2C
    void InitializeI2c() {
        i2c_master_bus_config_t i2c_bus_cfg = {
            .i2c_port = I2C_NUM_0,
            .sda_io_num = AUDIO_CODEC_I2C_SDA_PIN,
            .scl_io_num = AUDIO_CODEC_I2C_SCL_PIN,
            .clk_source = I2C_CLK_SRC_DEFAULT,
            .glitch_ignore_cnt = 7,
            .intr_priority = 0,
            .trans_queue_depth = 0,
            .flags = {
                .enable_internal_pullup = 1,
            },
        };
        ESP_ERROR_CHECK(i2c_new_master_bus(&i2c_bus_cfg, &codec_i2c_bus_));
    }

    // Khởi tạo SPI cho màn hình
    void InitializeSpi() {
        spi_bus_config_t buscfg = {};
        buscfg.mosi_io_num = DISPLAY_SPI_MOSI_PIN;
        buscfg.miso_io_num = GPIO_NUM_NC;
        buscfg.sclk_io_num = DISPLAY_SPI_SCK_PIN;
        buscfg.quadwp_io_num = GPIO_NUM_NC;
        buscfg.quadhd_io_num = GPIO_NUM_NC;
        buscfg.max_transfer_sz = DISPLAY_WIDTH * DISPLAY_HEIGHT * sizeof(uint16_t);
        ESP_ERROR_CHECK(spi_bus_initialize(SPI2_HOST, &buscfg, SPI_DMA_CH_AUTO));
    }

    // Khởi tạo nút bấm
    void InitializeButtons() {
        boot_button_.OnClick([this]() {
            auto& app = Application::GetInstance();
            if (app.GetDeviceState() == kDeviceStateStarting && !WifiStation::GetInstance().IsConnected()) {
                ResetWifiConfiguration();
            }
            app.ToggleChatState();
        });
    }

    // Khởi tạo màn hình (ví dụ ST7789)
    void InitializeDisplay() {
        esp_lcd_panel_io_handle_t panel_io = nullptr;
        esp_lcd_panel_handle_t panel = nullptr;
        
        esp_lcd_panel_io_spi_config_t io_config = {};
        io_config.cs_gpio_num = DISPLAY_SPI_CS_PIN;
        io_config.dc_gpio_num = DISPLAY_DC_PIN;
        io_config.spi_mode = 2;
        io_config.pclk_hz = 80 * 1000 * 1000;
        io_config.trans_queue_depth = 10;
        io_config.lcd_cmd_bits = 8;
        io_config.lcd_param_bits = 8;
        ESP_ERROR_CHECK(esp_lcd_new_panel_io_spi(SPI2_HOST, &io_config, &panel_io));

        esp_lcd_panel_dev_config_t panel_config = {};
        panel_config.reset_gpio_num = GPIO_NUM_NC;
        panel_config.rgb_ele_order = LCD_RGB_ELEMENT_ORDER_RGB;
        panel_config.bits_per_pixel = 16;
        ESP_ERROR_CHECK(esp_lcd_new_panel_st7789(panel_io, &panel_config, &panel));
        
        esp_lcd_panel_reset(panel);
        esp_lcd_panel_init(panel);
        esp_lcd_panel_invert_color(panel, true);
        esp_lcd_panel_swap_xy(panel, DISPLAY_SWAP_XY);
        esp_lcd_panel_mirror(panel, DISPLAY_MIRROR_X, DISPLAY_MIRROR_Y);
        
        // Tạo đối tượng màn hình
        display_ = new SpiLcdDisplay(panel_io, panel,
                                    DISPLAY_WIDTH, DISPLAY_HEIGHT, 
                                    DISPLAY_OFFSET_X, DISPLAY_OFFSET_Y, 
                                    DISPLAY_MIRROR_X, DISPLAY_MIRROR_Y, DISPLAY_SWAP_XY);
    }

    // Khởi tạo MCP tools
    void InitializeTools() {
        // Tham khảo tài liệu MCP
    }

public:
    MyCustomBoard() : boot_button_(BOOT_BUTTON_GPIO) {
        InitializeI2c();
        InitializeSpi();
        InitializeDisplay();
        InitializeButtons();
        InitializeTools();
        GetBacklight()->SetBrightness(100);
    }

    // Trả về codec âm thanh
    AudioCodec* GetAudioCodec() override {
        static Es8311AudioCodec audio_codec(
            codec_i2c_bus_, 
            I2C_NUM_0, 
            AUDIO_INPUT_SAMPLE_RATE, 
            AUDIO_OUTPUT_SAMPLE_RATE,
            AUDIO_I2S_GPIO_MCLK, 
            AUDIO_I2S_GPIO_BCLK, 
            AUDIO_I2S_GPIO_WS, 
            AUDIO_I2S_GPIO_DOUT, 
            AUDIO_I2S_GPIO_DIN,
            AUDIO_CODEC_PA_PIN, 
            AUDIO_CODEC_ES8311_ADDR);
        return &audio_codec;
    }

    // Trả về đối tượng hiển thị
    Display* GetDisplay() override {
        return display_;
    }
    
    // Trả về điều khiển đèn nền
    Backlight* GetBacklight() override {
        static PwmBacklight backlight(DISPLAY_BACKLIGHT_PIN, DISPLAY_BACKLIGHT_OUTPUT_INVERT);
        return &backlight;
    }
};

// Đăng ký bo mạch
DECLARE_BOARD(MyCustomBoard);
```

### 4. Cập nhật cấu hình build

#### Thêm lựa chọn bo mạch vào `Kconfig.projbuild`

Mở `main/Kconfig.projbuild`, bổ sung mục trong `choice BOARD_TYPE`:

```kconfig
choice BOARD_TYPE
    prompt "Board Type"
    default BOARD_TYPE_BREAD_COMPACT_WIFI
    help
        Board type. Loại bo mạch
    
    # ... các lựa chọn khác ...
    
    config BOARD_TYPE_MY_CUSTOM_BOARD
        bool "My Custom Board (Bo tùy chỉnh)"
        depends on IDF_TARGET_ESP32S3  # Chỉnh theo loại chip của bạn
endchoice
```

**Lưu ý:**
- Tên cấu hình phải viết hoa và dùng dấu gạch dưới, ví dụ `BOARD_TYPE_MY_CUSTOM_BOARD`
- `depends on` chỉ rõ loại chip (`IDF_TARGET_ESP32S3`, `IDF_TARGET_ESP32C3`...)
- Phần mô tả có thể dùng song ngữ

#### Bổ sung cấu hình trong `CMakeLists.txt`

Trong `main/CMakeLists.txt`, thêm nhánh xử lý cho bo mới:

```cmake
# Thêm vào chuỗi elseif
elseif(CONFIG_BOARD_TYPE_MY_CUSTOM_BOARD)
    set(BOARD_TYPE "my-custom-board")  # Khớp với tên thư mục
    set(BUILTIN_TEXT_FONT font_puhui_basic_20_4)  # Chọn font theo kích thước màn hình
    set(BUILTIN_ICON_FONT font_awesome_20_4)
    set(DEFAULT_EMOJI_COLLECTION twemoji_64)  # Tùy chọn nếu cần emoji
endif()
```

**Font và bộ emoji:**

- Màn hình nhỏ (128x64 OLED): `font_puhui_basic_14_1` / `font_awesome_14_1`
- Màn hình nhỏ vừa (240x240): `font_puhui_basic_16_4` / `font_awesome_16_4`
- Màn hình trung bình (240x320): `font_puhui_basic_20_4` / `font_awesome_20_4`
- Màn hình lớn (≥480x320): `font_puhui_basic_30_4` / `font_awesome_30_4`

Bộ emoji sẵn có:
- `twemoji_32`: emoji 32x32 (phù hợp màn hình nhỏ)
- `twemoji_64`: emoji 64x64 (màn hình lớn)

### 5. Cấu hình và biên dịch

#### Phương án 1: dùng `idf.py`

1. **Chọn chip mục tiêu** (khi cấu hình lần đầu hoặc thay đổi dòng chip):
   ```bash
   # ESP32-S3
   idf.py set-target esp32s3
   
   # ESP32-C3
   idf.py set-target esp32c3
   
   # ESP32
   idf.py set-target esp32
   ```

2. **Xóa cấu hình cũ**:
   ```bash
   idf.py fullclean
   ```

3. **Mở menu cấu hình**:
   ```bash
   idf.py menuconfig
   ```
   Trong menu, đi tới `Xiaozhi Assistant` -> `Board Type` và chọn bo tùy chỉnh.

4. **Biên dịch và nạp**:
   ```bash
   idf.py build
   idf.py flash monitor
   ```

#### Phương án 2: dùng script `release.py` (khuyến nghị)

Khi thư mục bo mạch có `config.json`, có thể dùng script để tự động cấu hình và biên dịch:

```bash
python scripts/release.py my-custom-board
```

Script sẽ:
- Đọc `target` và cài đặt chip mục tiêu
- Áp dụng các mục `sdkconfig_append`
- Biên dịch và đóng gói firmware

### 6. Viết README cho bo mạch

Trong `README.md`, mô tả tính năng phần cứng, yêu cầu, cách biên dịch và nạp firmware của bo.

## Các thành phần phổ biến

### 1. Màn hình

Hỗ trợ nhiều driver:
- ST7789 (SPI)
- ILI9341 (SPI)
- SH8601 (QSPI)
- ...

### 2. Codec âm thanh

Các codec khả dụng:
- ES8311 (phổ biến)
- ES7210 (mảng microphone)
- AW88298 (khuếch đại)
- ...

### 3. Quản lý nguồn

Một số bo dùng chip nguồn:
- AXP2101
- Các PMIC khác

### 4. Điều khiển qua MCP

Có thể thêm nhiều MCP tool để AI sử dụng:
- Speaker (điều khiển loa)
- Screen (điều chỉnh độ sáng màn hình)
- Battery (đọc dung lượng pin)
- Light (điều khiển đèn)
- ...

## Kế thừa lớp bo mạch

- `Board`: lớp cơ sở
  - `WifiBoard`: bo dùng Wi-Fi
  - `Ml307Board`: bo dùng module 4G
  - `DualNetworkBoard`: bo hỗ trợ Wi-Fi và 4G song song

## Mẹo phát triển

1. **Tham khảo bo tương tự**: nếu bo mới giống với bo đã có, hãy đọc và tái sử dụng mã hiện có.
2. **Kiểm thử theo từng bước**: hoàn thiện tính năng cơ bản (ví dụ hiển thị) trước rồi mới thêm chức năng phức tạp (âm thanh).
3. **Ánh xạ chân**: đảm bảo `config.h` liệt kê đúng mọi chân kết nối.
4. **Kiểm tra tương thích phần cứng**: xác thực các chip và driver đi kèm hoạt động với nhau.

## Sự cố thường gặp

1. **Màn hình hiển thị sai**: kiểm tra cấu hình SPI, thiết lập mirror và invert màu.
2. **Không có âm thanh**: xem lại cấu hình I2S, chân bật PA và địa chỉ codec.
3. **Không vào được mạng**: kiểm tra thông tin Wi-Fi và cấu hình mạng.
4. **Không liên lạc được với server**: kiểm tra cấu hình MQTT hoặc WebSocket.

## Tài liệu tham khảo

- ESP-IDF: https://docs.espressif.com/projects/esp-idf/
- LVGL: https://docs.lvgl.io/
- ESP-SR: https://github.com/espressif/esp-sr
