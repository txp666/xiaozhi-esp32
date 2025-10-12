/* Automatically generated file; DO NOT EDIT */
/* Espressif IoT Development Framework Linker Script */
/* Generated from: /data/xiaozhi-esp32-OTTO/build-otto/esp-idf/esp_system/ld/sections.ld.in */

/*
 * SPDX-FileCopyrightText: 2021 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * Automatically generated file. DO NOT EDIT.
 * Espressif IoT Development Framework (ESP-IDF) 5.5.0 Configuration Header
 */
       
/* List of deprecated options */
/* CPU instruction prefetch padding size for flash mmap scenario */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
        /**
         * The ESP_BOOTLOADER_RESERVE_RTC size must have the same alignment of RTC_TIMER_RESERVE_RTC, else
         * the segment will overflow at link time because not enough bytes are allocated for the RTC segment.
         */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
/* Default entry point */
ENTRY(call_start_cpu0);
SECTIONS
{
  /**
   * RTC fast memory holds RTC wake stub code,
   * including from any source file named rtc_wake_stub*.c
   */
  .rtc.text :
  {
    
 . = ALIGN(4); 
 _rtc_fast_start = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _rtc_text_start = ABSOLUTE(.);
    HIDDEN(_rtc_code_start = .);
    *(.rtc.entry.literal .rtc.entry.text)
    *(.rtc.literal .rtc.text .rtc.text.*)
    *rtc_wake_stub*.*(.literal .text .literal.* .text.*)
    *(.rtc_text_end_test)
    HIDDEN(_rtc_code_end = .);
    /* Padding for possible CPU prefetch + 4B alignment for PMS split lines. */
    . = ((_rtc_code_end - _rtc_code_start) == 0) ?
        ALIGN(0) : 16 + ALIGN(4);
    _rtc_text_end = ABSOLUTE(.);
  } > rtc_iram_seg
  /**
   * This section located in RTC FAST Memory area.
   * It holds data marked with RTC_FAST_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_fast :
  {
    
 . = ALIGN(4); 
 _rtc_force_fast_start = ABSOLUTE(.);
    _coredump_rtc_fast_start = ABSOLUTE(.);
    *(.rtc.fast.coredump .rtc.fast.coredump.*)
    _coredump_rtc_fast_end = ABSOLUTE(.);
    *(.rtc.force_fast .rtc.force_fast.*)
    
 . = ALIGN(4); 
 _rtc_force_fast_end = ABSOLUTE(.);
  } > rtc_data_seg
  /**
   * RTC data section holds RTC wake stub
   * data/rodata, including from any source file
   * named rtc_wake_stub*.c and the data marked with
   * RTC_DATA_ATTR, RTC_RODATA_ATTR attributes.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc.data :
  {
    _rtc_data_start = ABSOLUTE(.);
    _coredump_rtc_start = ABSOLUTE(.);
    *(.rtc.coredump .rtc.coredump.*)
    _coredump_rtc_end = ABSOLUTE(.);
    *(.rtc.data .rtc.data.*)
    *(.rtc.rodata .rtc.rodata.*)
    *rtc_wake_stub*.*(.data .rodata .data.* .rodata.*)
    _rtc_data_end = ABSOLUTE(.);
  } > rtc_data_location
  /* RTC bss, from any source file named rtc_wake_stub*.c */
  .rtc.bss (NOLOAD) :
  {
    _rtc_bss_start = ABSOLUTE(.);
    *rtc_wake_stub*.*(.bss .bss.*)
    *rtc_wake_stub*.*(COMMON)
    *(.rtc.bss)
    _rtc_bss_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section holds data that should not be initialized at power up
   * and will be retained during deep sleep.
   * User data marked with RTC_NOINIT_ATTR will be placed
   * into this section. See the file "esp_attr.h" for more information.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc_noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_noinit_start = ABSOLUTE(.);
    *(.rtc_noinit .rtc_noinit.*)
    
 . = ALIGN(4); 
 _rtc_noinit_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section located in RTC SLOW Memory area.
   * It holds data marked with RTC_SLOW_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_slow :
  {
    
 . = ALIGN(4); 
 _rtc_force_slow_start = ABSOLUTE(.);
    *(.rtc.force_slow .rtc.force_slow.*)
    
 . = ALIGN(4); 
 _rtc_force_slow_end = ABSOLUTE(.);
  } > rtc_slow_seg
  /**
   * This section holds RTC data that should have fixed addresses.
   * The data are not initialized at power-up and are retained during deep
   * sleep.
   */
  .rtc_reserved (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_reserved_start = ABSOLUTE(.);
    /**
     * New data can only be added here to ensure existing data are not moved.
     * Because data have adhered to the end of the segment and code is relied
     * on it.
     * >> put new data here <<
     */
    *(.rtc_timer_data_in_rtc_mem .rtc_timer_data_in_rtc_mem.*)
    KEEP(*(.bootloader_data_rtc_mem .bootloader_data_rtc_mem.*))
    _rtc_reserved_end = ABSOLUTE(.);
  } > rtc_reserved_seg
  _rtc_reserved_length = _rtc_reserved_end - _rtc_reserved_start;
  ASSERT((_rtc_reserved_length <= LENGTH(rtc_reserved_seg)),
          "RTC reserved segment data does not fit.")
  /* Get size of rtc slow data based on rtc_data_location alias */
  _rtc_slow_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_slow_end - _rtc_data_start)
                        : (_rtc_force_slow_end - _rtc_force_slow_start);
  _rtc_fast_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_fast_end - _rtc_fast_start)
                        : (_rtc_noinit_end - _rtc_fast_start);
  ASSERT((_rtc_slow_length <= LENGTH(rtc_slow_seg)),
          "RTC_SLOW segment data does not fit.")
  ASSERT((_rtc_fast_length <= LENGTH(rtc_data_seg)),
          "RTC_FAST segment data does not fit.")
  /* Send .iram0 code to iram */
  .iram0.vectors :
  {
    _iram_start = ABSOLUTE(.);
    /* Vectors go to IRAM */
    _vector_table = ABSOLUTE(.);
    . = 0x0;
    KEEP(*(.WindowVectors.text));
    . = 0x180;
    KEEP(*(.Level2InterruptVector.text));
    . = 0x1c0;
    KEEP(*(.Level3InterruptVector.text));
    . = 0x200;
    KEEP(*(.Level4InterruptVector.text));
    . = 0x240;
    KEEP(*(.Level5InterruptVector.text));
    . = 0x280;
    KEEP(*(.DebugExceptionVector.text));
    . = 0x2c0;
    KEEP(*(.NMIExceptionVector.text));
    . = 0x300;
    KEEP(*(.KernelExceptionVector.text));
    . = 0x340;
    KEEP(*(.UserExceptionVector.text));
    . = 0x3C0;
    KEEP(*(.DoubleExceptionVector.text));
    . = 0x400;
    KEEP(*(._invalid_pc_placeholder.text));
    *(.*Vector.literal)
  } > iram0_0_seg
  .iram0.text :
  {
    /* Code marked as running out of IRAM */
    _iram_text_start = ABSOLUTE(.);
    *(.iram1 .iram1.*)
    *libapp_trace.a:app_trace.*(.literal .literal.* .text .text.*)
    *libapp_trace.a:app_trace_util.*(.literal .literal.* .text .text.*)
    *libapp_trace.a:port_uart.*(.literal .literal.* .text .text.*)
    *libclang_rt.builtins.a:_divsf3.*(.literal .literal.* .text .text.*)
    *libesp_driver_gptimer.a:gptimer.*(.literal.gptimer_default_isr .text.gptimer_default_isr)
    *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_master_isr_handler_default .text.i2c_master_isr_handler_default)
    *libesp_driver_mcpwm.a:mcpwm_cap.*(.literal.mcpwm_capture_default_isr .text.mcpwm_capture_default_isr)
    *libesp_driver_mcpwm.a:mcpwm_cmpr.*(.literal.mcpwm_comparator_default_isr .text.mcpwm_comparator_default_isr)
    *libesp_driver_mcpwm.a:mcpwm_fault.*(.literal.mcpwm_gpio_fault_default_isr .text.mcpwm_gpio_fault_default_isr)
    *libesp_driver_mcpwm.a:mcpwm_oper.*(.literal.mcpwm_operator_default_isr .text.mcpwm_operator_default_isr)
    *libesp_driver_mcpwm.a:mcpwm_timer.*(.literal.mcpwm_timer_default_isr .text.mcpwm_timer_default_isr)
    *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_encoder_reset .text.rmt_encoder_reset)
    *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_dma_rx_one_block_cb .text.rmt_dma_rx_one_block_cb)
    *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_done .text.rmt_isr_handle_rx_done)
    *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_threshold .text.rmt_isr_handle_rx_threshold)
    *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_rx_default_isr .text.rmt_rx_default_isr)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_dma_tx_eof_cb .text.rmt_dma_tx_eof_cb)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_encode_check_result .text.rmt_encode_check_result)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_done .text.rmt_isr_handle_tx_done)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_loop_end .text.rmt_isr_handle_tx_loop_end)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_threshold .text.rmt_isr_handle_tx_threshold)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_default_isr .text.rmt_tx_default_isr)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_do_transaction .text.rmt_tx_do_transaction)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_mark_eof .text.rmt_tx_mark_eof)
    *libesp_driver_uart.a:uart_vfs.*(.literal.select_notif_callback_isr .text.select_notif_callback_isr)
    *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.*(.literal.select_notif_callback_isr .text.select_notif_callback_isr)
    *libesp_event.a:default_event_loop.*(.literal.esp_event_isr_post .text.esp_event_isr_post)
    *libesp_event.a:esp_event.*(.literal.esp_event_isr_post_to .text.esp_event_isr_post_to)
    *libesp_hw_support.a:adc_share_hw_ctrl.*(.literal.adc_apb_periph_claim .text.adc_apb_periph_claim)
    *libesp_hw_support.a:adc_share_hw_ctrl.*(.literal.adc_apb_periph_free .text.adc_apb_periph_free)
    *libesp_hw_support.a:clk_utils.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:cpu.*(.literal.esp_cpu_compare_and_set .text.esp_cpu_compare_and_set)
    *libesp_hw_support.a:cpu.*(.literal.esp_cpu_reset .text.esp_cpu_reset)
    *libesp_hw_support.a:cpu.*(.literal.esp_cpu_stall .text.esp_cpu_stall)
    *libesp_hw_support.a:cpu.*(.literal.esp_cpu_unstall .text.esp_cpu_unstall)
    *libesp_hw_support.a:cpu.*(.literal.esp_cpu_wait_for_intr .text.esp_cpu_wait_for_intr)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_clk_private_lock .text.esp_clk_private_lock)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_clk_private_unlock .text.esp_clk_private_unlock)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_clk_slowclk_cal_get .text.esp_clk_slowclk_cal_get)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_clk_slowclk_cal_set .text.esp_clk_slowclk_cal_set)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_rtc_get_time_us .text.esp_rtc_get_time_us)
    *libesp_hw_support.a:esp_memory_utils.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:gdma.*(.literal.gdma_append .text.gdma_append)
    *libesp_hw_support.a:gdma.*(.literal.gdma_default_rx_isr .text.gdma_default_rx_isr)
    *libesp_hw_support.a:gdma.*(.literal.gdma_default_tx_isr .text.gdma_default_tx_isr)
    *libesp_hw_support.a:gdma.*(.literal.gdma_reset .text.gdma_reset)
    *libesp_hw_support.a:gdma.*(.literal.gdma_start .text.gdma_start)
    *libesp_hw_support.a:gdma.*(.literal.gdma_stop .text.gdma_stop)
    *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:mspi_timing_config.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:mspi_timing_tuning.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_module_reset .text.periph_module_reset)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_enter .text.periph_rcc_acquire_enter)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_exit .text.periph_rcc_acquire_exit)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_enter .text.periph_rcc_enter)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_exit .text.periph_rcc_exit)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_enter .text.periph_rcc_release_enter)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_exit .text.periph_rcc_release_exit)
    *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_disable .text.wifi_module_disable)
    *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_enable .text.wifi_module_enable)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_read_reg .text.regi2c_ctrl_read_reg)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_read_reg_mask .text.regi2c_ctrl_read_reg_mask)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_write_reg .text.regi2c_ctrl_write_reg)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_write_reg_mask .text.regi2c_ctrl_write_reg_mask)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_enter_critical .text.regi2c_enter_critical)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_exit_critical .text.regi2c_exit_critical)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_saradc_disable .text.regi2c_saradc_disable)
    *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_saradc_enable .text.regi2c_saradc_enable)
    *libesp_hw_support.a:rtc_clk.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_get_config .text.rtc_vddsdio_get_config)
    *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_set_config .text.rtc_vddsdio_set_config)
    *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_get_default_config .text.rtc_sleep_get_default_config)
    *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_init .text.rtc_sleep_init)
    *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_low_init .text.rtc_sleep_low_init)
    *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_pu .text.rtc_sleep_pu)
    *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_start .text.rtc_sleep_start)
    *libesp_hw_support.a:rtc_time.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:sar_periph_ctrl.*(.literal.sar_periph_ctrl_power_disable .text.sar_periph_ctrl_power_disable)
    *libesp_hw_support.a:sar_periph_ctrl.*(.literal.sar_periph_ctrl_power_enable .text.sar_periph_ctrl_power_enable)
    *libesp_hw_support.a:sar_periph_ctrl_common.*(.literal.temp_sensor_get_raw_value .text.temp_sensor_get_raw_value)
    *libesp_hw_support.a:sar_periph_ctrl_common.*(.literal.temperature_sensor_power_acquire .text.temperature_sensor_power_acquire)
    *libesp_hw_support.a:sar_periph_ctrl_common.*(.literal.temperature_sensor_power_release .text.temperature_sensor_power_release)
    *libesp_hw_support.a:sleep_console.*(.literal .literal.* .text .text.*)
    *libesp_hw_support.a:sleep_cpu.*(.literal.cpu_domain_pd_allowed .text.cpu_domain_pd_allowed)
    *libesp_hw_support.a:sleep_cpu.*(.literal.sleep_enable_cpu_retention .text.sleep_enable_cpu_retention)
    *libesp_hw_support.a:sleep_modem.*(.literal.modem_domain_pd_allowed .text.modem_domain_pd_allowed)
    *libesp_hw_support.a:sleep_modem.*(.literal.periph_inform_out_light_sleep_overhead .text.periph_inform_out_light_sleep_overhead)
    *libesp_hw_support.a:sleep_modem.*(.literal.sleep_modem_reject_triggers .text.sleep_modem_reject_triggers)
    *libesp_hw_support.a:sleep_modes.*(.literal.esp_light_sleep_start .text.esp_light_sleep_start)
    *libesp_hw_support.a:sleep_modes.*(.literal.esp_sleep_enable_timer_wakeup .text.esp_sleep_enable_timer_wakeup)
    *libesp_hw_support.a:systimer.*(.literal .literal.* .text .text.*)
    *libesp_mm.a:esp_cache_msync.*(.literal .literal.* .text .text.*)
    *libesp_mm.a:esp_cache_utils.*(.literal .literal.* .text .text.*)
    *libesp_phy.a:phy_override.*(.literal.phy_get_tsens_value .text.phy_get_tsens_value)
    *libesp_pm.a:pm_impl.*(.literal.esp_pm_impl_get_cpu_freq .text.esp_pm_impl_get_cpu_freq)
    *libesp_psram.a:esp_psram_impl_octal.*(.literal .literal.* .text .text.*)
    *libesp_psram.a:mmu_psram_flash.*(.literal .literal.* .text .text.*)
    *libesp_ringbuf.a:(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_print.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_spiflash.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_sys.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_systimer.*(.literal .literal.* .text .text.*)
    *libesp_rom.a:esp_rom_wdt.*(.literal .literal.* .text .text.*)
    *libesp_system.a:esp_err.*(.literal .literal.* .text .text.*)
    *libesp_system.a:esp_system_chip.*(.literal.esp_system_abort .text.esp_system_abort)
    *libesp_system.a:image_process.*(.literal .literal.* .text .text.*)
    *libesp_system.a:ubsan.*(.literal .literal.* .text .text.*)
    *libesp_timer.a:esp_timer_impl_common.*(.literal.esp_timer_impl_lock .text.esp_timer_impl_lock)
    *libesp_timer.a:esp_timer_impl_common.*(.literal.esp_timer_impl_unlock .text.esp_timer_impl_unlock)
    *libesp_timer.a:esp_timer_impl_systimer.*(.literal.esp_timer_impl_advance .text.esp_timer_impl_advance)
    *libesp_timer.a:esp_timer_impl_systimer.*(.literal.esp_timer_impl_set .text.esp_timer_impl_set)
    *libfreertos.a:(EXCLUDE_FILE(*libfreertos.a:app_startup.* *libfreertos.a:freertos_compatibility.* *libfreertos.a:idf_additions.* *libfreertos.a:idf_additions_event_groups.* *libfreertos.a:tasks.*) .literal EXCLUDE_FILE(*libfreertos.a:app_startup.* *libfreertos.a:freertos_compatibility.* *libfreertos.a:idf_additions.* *libfreertos.a:idf_additions_event_groups.* *libfreertos.a:tasks.*) .literal.* EXCLUDE_FILE(*libfreertos.a:app_startup.* *libfreertos.a:freertos_compatibility.* *libfreertos.a:idf_additions.* *libfreertos.a:idf_additions_event_groups.* *libfreertos.a:tasks.*) .text EXCLUDE_FILE(*libfreertos.a:app_startup.* *libfreertos.a:freertos_compatibility.* *libfreertos.a:idf_additions.* *libfreertos.a:idf_additions_event_groups.* *libfreertos.a:tasks.*) .text.*)
    *libfreertos.a:tasks.*(.literal.__getreent .literal.eTaskGetState .literal.pcTaskGetName .literal.prvAddCurrentTaskToDelayedList .literal.prvAddNewTaskToReadyList .literal.prvCheckTaskCanBeScheduledSMP .literal.prvDeleteTCB .literal.prvIdleTask .literal.prvInitialiseNewTask$constprop$0 .literal.prvIsYieldRequiredSMP .literal.prvListTasksWithinSingleList .literal.prvReleaseKernelLock .literal.prvResetNextTaskUnblockTime .literal.prvSearchForNameWithinSingleList .literal.prvTakeKernelLock .literal.prvTaskCreateDynamicPinnedToCoreWithCaps .literal.prvTaskPriorityRaise .literal.prvTaskPriorityRestore .literal.prvWriteNameToBuffer .literal.pvTaskGetCurrentTCBForCore .literal.pvTaskGetThreadLocalStoragePointer .literal.pvTaskIncrementMutexHeldCount .literal.pxTaskGetStackStart .literal.ulTaskGenericNotifyTake .literal.ulTaskGenericNotifyValueClear .literal.ulTaskGetIdleRunTimeCounter .literal.ulTaskGetIdleRunTimeCounterForCore .literal.ulTaskGetIdleRunTimePercent .literal.ulTaskGetIdleRunTimePercentForCore .literal.uxTaskGetNumberOfTasks .literal.uxTaskGetStackHighWaterMark .literal.uxTaskGetStackHighWaterMark2 .literal.uxTaskGetSystemState .literal.uxTaskPriorityGet .literal.uxTaskPriorityGetFromISR .literal.uxTaskResetEventItemValue .literal.vTaskDelay .literal.vTaskDelete .literal.vTaskEndScheduler .literal.vTaskGenericNotifyGiveFromISR .literal.vTaskGetInfo .literal.vTaskGetRunTimeStats .literal.vTaskGetSnapshot .literal.vTaskInternalSetTimeOutState .literal.vTaskList .literal.vTaskMissedYield .literal.vTaskPlaceOnEventList .literal.vTaskPlaceOnEventListRestricted .literal.vTaskPlaceOnUnorderedEventList .literal.vTaskPriorityDisinheritAfterTimeout .literal.vTaskPrioritySet .literal.vTaskRemoveFromUnorderedEventList .literal.vTaskResume .literal.vTaskSetThreadLocalStoragePointer .literal.vTaskSetThreadLocalStoragePointerAndDelCallback .literal.vTaskSetTimeOutState .literal.vTaskStartScheduler .literal.vTaskSuspend .literal.vTaskSuspendAll .literal.vTaskSwitchContext .literal.xTaskAbortDelay .literal.xTaskCatchUpTicks .literal.xTaskCheckForTimeOut .literal.xTaskCreatePinnedToCore .literal.xTaskCreateStaticPinnedToCore .literal.xTaskDelayUntil .literal.xTaskGenericNotify .literal.xTaskGenericNotifyFromISR .literal.xTaskGenericNotifyStateClear .literal.xTaskGenericNotifyWait .literal.xTaskGetCoreID .literal.xTaskGetCurrentTaskHandle .literal.xTaskGetCurrentTaskHandleForCore .literal.xTaskGetHandle .literal.xTaskGetIdleTaskHandle .literal.xTaskGetIdleTaskHandleForCore .literal.xTaskGetSchedulerState .literal.xTaskGetStaticBuffers .literal.xTaskGetTickCount .literal.xTaskGetTickCountFromISR .literal.xTaskIncrementTick .literal.xTaskIncrementTickOtherCores .literal.xTaskPriorityDisinherit .literal.xTaskPriorityInherit .literal.xTaskRemoveFromEventList .literal.xTaskResumeAll .literal.xTaskResumeFromISR .text .text.__getreent .text.eTaskGetState .text.pcTaskGetName .text.prvAddCurrentTaskToDelayedList .text.prvAddNewTaskToReadyList .text.prvCheckTaskCanBeScheduledSMP .text.prvDeleteTCB .text.prvIdleTask .text.prvInitialiseNewTask$constprop$0 .text.prvIsYieldRequiredSMP .text.prvListTasksWithinSingleList .text.prvReleaseKernelLock .text.prvResetNextTaskUnblockTime .text.prvSearchForNameWithinSingleList .text.prvTakeKernelLock .text.prvTaskCreateDynamicPinnedToCoreWithCaps .text.prvTaskPriorityRaise .text.prvTaskPriorityRestore .text.prvWriteNameToBuffer .text.pvTaskGetCurrentTCBForCore .text.pvTaskGetThreadLocalStoragePointer .text.pvTaskIncrementMutexHeldCount .text.pxTaskGetStackStart .text.ulTaskGenericNotifyTake .text.ulTaskGenericNotifyValueClear .text.ulTaskGetIdleRunTimeCounter .text.ulTaskGetIdleRunTimeCounterForCore .text.ulTaskGetIdleRunTimePercent .text.ulTaskGetIdleRunTimePercentForCore .text.uxTaskGetNumberOfTasks .text.uxTaskGetStackHighWaterMark .text.uxTaskGetStackHighWaterMark2 .text.uxTaskGetSystemState .text.uxTaskGetTaskNumber .text.uxTaskPriorityGet .text.uxTaskPriorityGetFromISR .text.uxTaskResetEventItemValue .text.vTaskDelay .text.vTaskDelete .text.vTaskEndScheduler .text.vTaskGenericNotifyGiveFromISR .text.vTaskGetInfo .text.vTaskGetRunTimeStats .text.vTaskGetSnapshot .text.vTaskInternalSetTimeOutState .text.vTaskList .text.vTaskMissedYield .text.vTaskPlaceOnEventList .text.vTaskPlaceOnEventListRestricted .text.vTaskPlaceOnUnorderedEventList .text.vTaskPriorityDisinheritAfterTimeout .text.vTaskPrioritySet .text.vTaskRemoveFromUnorderedEventList .text.vTaskResume .text.vTaskSetTaskNumber .text.vTaskSetThreadLocalStoragePointer .text.vTaskSetThreadLocalStoragePointerAndDelCallback .text.vTaskSetTimeOutState .text.vTaskStartScheduler .text.vTaskSuspend .text.vTaskSuspendAll .text.vTaskSwitchContext .text.xTaskAbortDelay .text.xTaskCatchUpTicks .text.xTaskCheckForTimeOut .text.xTaskCreatePinnedToCore .text.xTaskCreateStaticPinnedToCore .text.xTaskDelayUntil .text.xTaskGenericNotify .text.xTaskGenericNotifyFromISR .text.xTaskGenericNotifyStateClear .text.xTaskGenericNotifyWait .text.xTaskGetCoreID .text.xTaskGetCurrentTaskHandle .text.xTaskGetCurrentTaskHandleForCore .text.xTaskGetHandle .text.xTaskGetIdleTaskHandle .text.xTaskGetIdleTaskHandleForCore .text.xTaskGetSchedulerState .text.xTaskGetStaticBuffers .text.xTaskGetTickCount .text.xTaskGetTickCountFromISR .text.xTaskIncrementTick .text.xTaskIncrementTickOtherCores .text.xTaskPriorityDisinherit .text.xTaskPriorityInherit .text.xTaskRemoveFromEventList .text.xTaskResumeAll .text.xTaskResumeFromISR .text.xTimerCreateTimerTask)
    *libgcc.a:_divsf3.*(.literal .literal.* .text .text.*)
    *libgcc.a:lib2funcs.*(.literal .literal.* .text .text.*)
    *libgcov.a:(.literal .literal.* .text .text.*)
    *libhal.a:cache_hal.*(.literal .literal.* .text .text.*)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_append .text.gdma_ahb_hal_append)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_clear_intr .text.gdma_ahb_hal_clear_intr)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_get_eof_desc_addr .text.gdma_ahb_hal_get_eof_desc_addr)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_read_intr_status .text.gdma_ahb_hal_read_intr_status)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_reset .text.gdma_ahb_hal_reset)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_start_with_desc .text.gdma_ahb_hal_start_with_desc)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_stop .text.gdma_ahb_hal_stop)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_append .text.gdma_hal_append)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_clear_intr .text.gdma_hal_clear_intr)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_get_eof_desc_addr .text.gdma_hal_get_eof_desc_addr)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_read_intr_status .text.gdma_hal_read_intr_status)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_reset .text.gdma_hal_reset)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_start_with_desc .text.gdma_hal_start_with_desc)
    *libhal.a:gdma_hal_top.*(.literal.gdma_hal_stop .text.gdma_hal_stop)
    *libhal.a:gpio_hal.*(.literal.gpio_hal_isolate_in_sleep .text.gpio_hal_isolate_in_sleep)
    *libhal.a:i2c_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:ledc_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:mmu_hal.*(.literal .literal.* .text .text.*)
    *libhal.a:rtc_cntl_hal.*(.literal.rtc_cntl_hal_enable_cpu_retention .text.rtc_cntl_hal_enable_cpu_retention)
    *libhal.a:rtc_cntl_hal.*(.literal.rtc_cntl_hal_enable_tagmem_retention .text.rtc_cntl_hal_enable_tagmem_retention)
    *libhal.a:spi_flash_encrypt_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:spi_flash_hal_gpspi.*(.literal .literal.* .text .text.*)
    *libhal.a:spi_flash_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:spi_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:spi_slave_hal_iram.*(.literal .literal.* .text .text.*)
    *libhal.a:systimer_hal.*(.literal .literal.* .text .text.*)
    *libhal.a:timer_hal.*(.literal.timer_hal_capture_and_get_counter_value .text.timer_hal_capture_and_get_counter_value)
    *libhal.a:uart_hal_iram.*(.literal .literal.* .text .text.*)
    *libheap.a:multi_heap.*(.literal.assert_valid_block .text.assert_valid_block)
    *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl .text.multi_heap_aligned_alloc_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl_offs .text.multi_heap_aligned_alloc_impl_offs)
    *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_offs .text.multi_heap_aligned_alloc_offs)
    *libheap.a:multi_heap.*(.literal.multi_heap_free_impl .text.multi_heap_free_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_get_allocated_size_impl .text.multi_heap_get_allocated_size_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_get_block_address_impl .text.multi_heap_get_block_address_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_get_first_block .text.multi_heap_get_first_block)
    *libheap.a:multi_heap.*(.literal.multi_heap_get_full_block_size .text.multi_heap_get_full_block_size)
    *libheap.a:multi_heap.*(.literal.multi_heap_get_next_block .text.multi_heap_get_next_block)
    *libheap.a:multi_heap.*(.literal.multi_heap_internal_lock .text.multi_heap_internal_lock)
    *libheap.a:multi_heap.*(.literal.multi_heap_internal_unlock .text.multi_heap_internal_unlock)
    *libheap.a:multi_heap.*(.literal.multi_heap_is_free .text.multi_heap_is_free)
    *libheap.a:multi_heap.*(.literal.multi_heap_malloc_impl .text.multi_heap_malloc_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_realloc_impl .text.multi_heap_realloc_impl)
    *libheap.a:multi_heap.*(.literal.multi_heap_set_lock .text.multi_heap_set_lock)
    *libheap.a:tlsf.*(.literal.tlsf_alloc_overhead .text.tlsf_alloc_overhead)
    *libheap.a:tlsf.*(.literal.tlsf_block_size .text.tlsf_block_size)
    *libheap.a:tlsf.*(.literal.tlsf_free .text.tlsf_free)
    *libheap.a:tlsf.*(.literal.tlsf_get_pool .text.tlsf_get_pool)
    *libheap.a:tlsf.*(.literal.tlsf_malloc .text.tlsf_malloc)
    *libheap.a:tlsf.*(.literal.tlsf_memalign .text.tlsf_memalign)
    *libheap.a:tlsf.*(.literal.tlsf_memalign_offs .text.tlsf_memalign_offs)
    *libheap.a:tlsf.*(.literal.tlsf_realloc .text.tlsf_realloc)
    *libheap.a:tlsf.*(.literal.tlsf_size .text.tlsf_size)
    *liblog.a:log.*(.literal .literal.* .text .text.*)
    *liblog.a:log_format_text.*(.literal .literal.* .text .text.*)
    *liblog.a:log_lock.*(.literal .literal.* .text .text.*)
    *liblog.a:log_print.*(.literal .literal.* .text .text.*)
    *liblog.a:log_timestamp.*(.literal.esp_log_early_timestamp .text.esp_log_early_timestamp)
    *liblog.a:log_timestamp.*(.literal.esp_log_timestamp .text.esp_log_timestamp)
    *liblog.a:log_timestamp_common.*(.literal .literal.* .text .text.*)
    *liblog.a:log_write.*(.literal.esp_log_write .text.esp_log_write)
    *liblog.a:log_write.*(.literal.esp_log_writev .text.esp_log_writev)
    *liblog.a:tag_log_level.*(.literal.esp_log_level_get_timeout .text.esp_log_level_get_timeout)
    *liblog.a:util.*(.literal .literal.* .text .text.*)
    *liblwip.a:vfs_lwip.*(.literal.lwip_stop_socket_select_isr .text.lwip_stop_socket_select_isr)
    *libnewlib.a:abort.*(.literal .literal.* .text .text.*)
    *libnewlib.a:assert.*(.literal .literal.* .text .text.*)
    *libnewlib.a:esp_time_impl.*(.literal.esp_set_time_from_rtc .text.esp_set_time_from_rtc)
    *libnewlib.a:esp_time_impl.*(.literal.esp_time_impl_get_boot_time .text.esp_time_impl_get_boot_time)
    *libnewlib.a:esp_time_impl.*(.literal.esp_time_impl_set_boot_time .text.esp_time_impl_set_boot_time)
    *libnewlib.a:heap.*(.literal .literal.* .text .text.*)
    *libnewlib.a:stdatomic.*(.literal .literal.* .text .text.*)
    *libnewlib.a:stdatomic_s32c1i.*(.literal .literal.* .text .text.*)
    *librtc.a:(.literal .literal.* .text .text.*)
    *libsoc.a:lldesc.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:esp_flash_api.*(.literal.check_chip_pointer_default .text.check_chip_pointer_default)
    *libspi_flash.a:esp_flash_api.*(.literal.detect_spi_flash_chip .text.detect_spi_flash_chip)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_chip_driver_initialized .text.esp_flash_chip_driver_initialized)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_chip .text.esp_flash_erase_chip)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_region .text.esp_flash_erase_region)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_chip_write_protect .text.esp_flash_get_chip_write_protect)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_io_mode .text.esp_flash_get_io_mode)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_physical_size .text.esp_flash_get_physical_size)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_protected_region .text.esp_flash_get_protected_region)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_size .text.esp_flash_get_size)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init .text.esp_flash_init)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init_main .text.esp_flash_init_main)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read .text.esp_flash_read)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read_encrypted .text.esp_flash_read_encrypted)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_chip_write_protect .text.esp_flash_set_chip_write_protect)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_io_mode .text.esp_flash_set_io_mode)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_protected_region .text.esp_flash_set_protected_region)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write .text.esp_flash_write)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write_encrypted .text.esp_flash_write_encrypted)
    *libspi_flash.a:esp_flash_api.*(.literal.flash_end_flush_cache .text.flash_end_flush_cache)
    *libspi_flash.a:esp_flash_api.*(.literal.read_unique_id .text.read_unique_id)
    *libspi_flash.a:esp_flash_api.*(.literal.spiflash_end_default .text.spiflash_end_default)
    *libspi_flash.a:esp_flash_api.*(.literal.spiflash_start_default .text.spiflash_start_default)
    *libspi_flash.a:flash_brownout_hook.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:memspi_host_driver.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_boya.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_gd.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_generic.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_issi.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_mxic.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_mxic_opi.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_th.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_chip_winbond.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_hpm_enable.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_oct_flash_init.*(.literal .literal.* .text .text.*)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.delay_us .text.delay_us)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.get_buffer_malloc .text.get_buffer_malloc)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_op_status .text.main_flash_op_status)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_region_protected .text.main_flash_region_protected)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.release_buffer_malloc .text.release_buffer_malloc)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_end .text.spi23_end)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_start .text.spi23_start)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_check_yield .text.spi_flash_os_check_yield)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_yield .text.spi_flash_os_yield)
    *libspi_flash.a:spi_flash_os_func_noos.*(.literal.delay_us .text.delay_us)
    *libspi_flash.a:spi_flash_os_func_noos.*(.literal.esp_flash_app_disable_os_functions .text.esp_flash_app_disable_os_functions)
    *libspi_flash.a:spi_flash_os_func_noos.*(.literal.get_temp_buffer_not_supported .text.get_temp_buffer_not_supported)
    *libspi_flash.a:spi_flash_wrap.*(.literal .literal.* .text .text.*)
    *libvfs.a:vfs.*(.literal.esp_vfs_select_triggered_isr .text.esp_vfs_select_triggered_isr)
    *libxt_hal.a:(.literal .literal.* .text .text.*)
    *libxtensa.a:(EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal.* EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text.*)
  } > iram0_0_seg
  /**
   * This section is required to skip .iram0.text area because iram0_0_seg and
   * dram0_0_seg reflect the same address space on different buses.
   */
  .dram0.dummy (NOLOAD):
  {
    . = ORIGIN(dram0_0_seg) + MAX(_iram_end - _diram_i_start, 0);
  } > dram0_0_seg
  .dram0.data :
  {
    _data_start = ABSOLUTE(.);
    *(.gnu.linkonce.d.*)
    *(.data1)
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.gnu.linkonce.s2.*)
    *(.jcr)
    *(.data .data.*)
    *(.dram1 .dram1.*)
    _coredump_dram_start = ABSOLUTE(.);
    *(.dram2.coredump .dram2.coredump.*)
    _coredump_dram_end = ABSOLUTE(.);
    *libapp_trace.a:app_trace.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libapp_trace.a:app_trace_util.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libapp_trace.a:port_uart.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libclang_rt.builtins.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:clk_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:esp_memory_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:mspi_timing_config.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:mspi_timing_tuning.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:rtc_clk.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:sleep_console.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_hw_support.a:systimer.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_mm.a:esp_cache_msync.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_mm.a:esp_cache_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_psram.a:esp_psram_impl_octal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_psram.a:mmu_psram_flash.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_spiflash.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_sys.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_systimer.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_rom.a:esp_rom_wdt.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_system.a:esp_err.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_system.a:image_process.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libesp_system.a:ubsan.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libgcc.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libgcov.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:cache_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:i2c_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:ledc_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:mmu_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:spi_flash_encrypt_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:spi_flash_hal_gpspi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:spi_flash_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:spi_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:spi_slave_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:systimer_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libhal.a:uart_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:log.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:log_format_text.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:log_lock.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:log_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:log_timestamp_common.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *liblog.a:util.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libnewlib.a:abort.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libnewlib.a:assert.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libnewlib.a:heap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libnewlib.a:stdatomic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libnewlib.a:stdatomic_s32c1i.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libphy.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libsoc.a:lldesc.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libsoc.a:temperature_sensor_periph.*(.rodata.temperature_sensor_attributes .sdata2.temperature_sensor_attributes .srodata.temperature_sensor_attributes)
    *libspi_flash.a:flash_brownout_hook.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:memspi_host_driver.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_boya.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_gd.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_generic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_issi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_mxic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_mxic_opi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_th.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_chip_winbond.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_hpm_enable.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_oct_flash_init.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    *libspi_flash.a:spi_flash_wrap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
    _data_end = ABSOLUTE(.);
  } > dram0_0_seg
  /**
   * This section holds data that should not be initialized at power up.
   * The section located in Internal SRAM memory region. The macro _NOINIT
   * can be used as attribute to place data into this section.
   * See the "esp_attr.h" file for more information.
   */
  .noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _noinit_start = ABSOLUTE(.);
    *(.noinit .noinit.*)
    
 . = ALIGN(4); 
 _noinit_end = ABSOLUTE(.);
  } > dram0_0_seg
  /* Shared RAM */
  .dram0.bss (NOLOAD) :
  {
    
 . = ALIGN(8); 
 _bss_start = ABSOLUTE(.);
    /**
     * ldgen places all bss-related data to mapping[dram0_bss]
     * (See components/esp_system/app.lf).
     */
    *(.bss .bss.*)
    *(.dynbss .dynsbss .gnu.linkonce.b .gnu.linkonce.b.* .gnu.linkonce.sb .gnu.linkonce.sb.* .gnu.linkonce.sb2 .gnu.linkonce.sb2.* .sbss .sbss.* .sbss2 .sbss2.* .scommon .share.mem)
    *(.ext_ram.bss .ext_ram.bss.*)
    *(COMMON)
    
 . = ALIGN(8); 
 _bss_end = ABSOLUTE(.);
  } > dram0_0_seg
  ASSERT(((_bss_end - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
         "DRAM segment data does not fit.")
  .flash.text :
  {
    _stext = .;
    /**
     * Mark the start of flash.text.
     * This can be used by the MMU driver to maintain the virtual address.
     */
    _instruction_reserved_start = ABSOLUTE(.);
    _text_start = ABSOLUTE(.);
    *(EXCLUDE_FILE(*libesp_ringbuf.a *libfreertos.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_driver_uart.a:uart_vfs.* *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hw_support.a:adc_share_hw_ctrl.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:gdma.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:sar_periph_ctrl.* *libesp_hw_support.a:sar_periph_ctrl_common.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:sleep_cpu.* *libesp_hw_support.a:sleep_modem.* *libesp_hw_support.a:sleep_modes.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_phy.a:phy_override.* *libesp_pm.a:pm_impl.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libesp_timer.a:esp_timer_impl_common.* *libesp_timer.a:esp_timer_impl_systimer.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:gdma_hal_ahb_v1.* *libhal.a:gdma_hal_top.* *libhal.a:gpio_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:rtc_cntl_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:timer_hal.* *libhal.a:uart_hal_iram.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *liblwip.a:vfs_lwip.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:esp_time_impl.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.* *libvfs.a:vfs.*) .literal EXCLUDE_FILE(*libesp_ringbuf.a *libfreertos.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_driver_uart.a:uart_vfs.* *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hw_support.a:adc_share_hw_ctrl.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:gdma.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:sar_periph_ctrl.* *libesp_hw_support.a:sar_periph_ctrl_common.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:sleep_cpu.* *libesp_hw_support.a:sleep_modem.* *libesp_hw_support.a:sleep_modes.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_phy.a:phy_override.* *libesp_pm.a:pm_impl.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libesp_timer.a:esp_timer_impl_common.* *libesp_timer.a:esp_timer_impl_systimer.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:gdma_hal_ahb_v1.* *libhal.a:gdma_hal_top.* *libhal.a:gpio_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:rtc_cntl_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:timer_hal.* *libhal.a:uart_hal_iram.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *liblwip.a:vfs_lwip.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:esp_time_impl.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.* *libvfs.a:vfs.*) .literal.* EXCLUDE_FILE(*libesp_ringbuf.a *libfreertos.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_driver_uart.a:uart_vfs.* *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hw_support.a:adc_share_hw_ctrl.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:gdma.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:sar_periph_ctrl.* *libesp_hw_support.a:sar_periph_ctrl_common.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:sleep_cpu.* *libesp_hw_support.a:sleep_modem.* *libesp_hw_support.a:sleep_modes.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_phy.a:phy_override.* *libesp_pm.a:pm_impl.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libesp_timer.a:esp_timer_impl_common.* *libesp_timer.a:esp_timer_impl_systimer.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:gdma_hal_ahb_v1.* *libhal.a:gdma_hal_top.* *libhal.a:gpio_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:rtc_cntl_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:timer_hal.* *libhal.a:uart_hal_iram.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *liblwip.a:vfs_lwip.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:esp_time_impl.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.* *libvfs.a:vfs.*) .text EXCLUDE_FILE(*libesp_ringbuf.a *libfreertos.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_driver_uart.a:uart_vfs.* *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hw_support.a:adc_share_hw_ctrl.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:gdma.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:sar_periph_ctrl.* *libesp_hw_support.a:sar_periph_ctrl_common.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:sleep_cpu.* *libesp_hw_support.a:sleep_modem.* *libesp_hw_support.a:sleep_modes.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_phy.a:phy_override.* *libesp_pm.a:pm_impl.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libesp_timer.a:esp_timer_impl_common.* *libesp_timer.a:esp_timer_impl_systimer.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:gdma_hal_ahb_v1.* *libhal.a:gdma_hal_top.* *libhal.a:gpio_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:rtc_cntl_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:timer_hal.* *libhal.a:uart_hal_iram.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *liblwip.a:vfs_lwip.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:esp_time_impl.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.* *libvfs.a:vfs.*) .text.*)
    *(.wifi0iram .wifi0iram.*)
    *(.wifiextrairam .wifiextrairam.*)
    *(.wifiorslpiram .wifiorslpiram.*)
    *(.wifirxiram .wifirxiram.*)
    *(.wifislpiram .wifislpiram.*)
    *(.wifislprxiram .wifislprxiram.*)
    *libesp_driver_gptimer.a:gptimer.*(.literal.gptimer_del_timer .literal.gptimer_destroy .literal.gptimer_disable .literal.gptimer_enable .literal.gptimer_get_captured_count .literal.gptimer_get_raw_count .literal.gptimer_get_resolution .literal.gptimer_new_timer .literal.gptimer_register_event_callbacks .literal.gptimer_set_alarm_action .literal.gptimer_set_raw_count .literal.gptimer_start .literal.gptimer_stop .text .text.gptimer_del_timer .text.gptimer_destroy .text.gptimer_disable .text.gptimer_enable .text.gptimer_get_captured_count .text.gptimer_get_raw_count .text.gptimer_get_resolution .text.gptimer_new_timer .text.gptimer_register_event_callbacks .text.gptimer_set_alarm_action .text.gptimer_set_raw_count .text.gptimer_start .text.gptimer_stop)
    *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_del_master_bus .literal.i2c_master_bus_add_device .literal.i2c_master_bus_destroy .literal.i2c_master_bus_reset .literal.i2c_master_bus_rm_device .literal.i2c_master_bus_wait_all_done .literal.i2c_master_device_change_address .literal.i2c_master_execute_defined_operations .literal.i2c_master_get_bus_handle .literal.i2c_master_multi_buffer_transmit .literal.i2c_master_probe .literal.i2c_master_receive .literal.i2c_master_register_event_callbacks .literal.i2c_master_transmit .literal.i2c_master_transmit_receive .literal.i2c_new_master_bus .literal.s_i2c_asynchronous_transaction .literal.s_i2c_hw_fsm_reset$isra$0 .literal.s_i2c_read_command .literal.s_i2c_send_command_async .literal.s_i2c_send_commands .literal.s_i2c_start_end_command .literal.s_i2c_synchronous_transaction .literal.s_i2c_transaction_start .literal.s_i2c_write_command .text .text.i2c_del_master_bus .text.i2c_master_bus_add_device .text.i2c_master_bus_destroy .text.i2c_master_bus_reset .text.i2c_master_bus_rm_device .text.i2c_master_bus_wait_all_done .text.i2c_master_device_change_address .text.i2c_master_execute_defined_operations .text.i2c_master_get_bus_handle .text.i2c_master_multi_buffer_transmit .text.i2c_master_probe .text.i2c_master_receive .text.i2c_master_register_event_callbacks .text.i2c_master_transmit .text.i2c_master_transmit_receive .text.i2c_new_master_bus .text.s_i2c_asynchronous_transaction .text.s_i2c_hw_fsm_reset$isra$0 .text.s_i2c_read_command .text.s_i2c_send_command_async .text.s_i2c_send_commands .text.s_i2c_start_end_command .text.s_i2c_synchronous_transaction .text.s_i2c_transaction_start .text.s_i2c_write_command)
    *libesp_driver_mcpwm.a:mcpwm_cap.*(.literal.mcpwm_cap_timer_destroy .literal.mcpwm_capture_channel_destroy .literal.mcpwm_capture_channel_disable .literal.mcpwm_capture_channel_enable .literal.mcpwm_capture_channel_register_event_callbacks .literal.mcpwm_capture_channel_trigger_soft_catch .literal.mcpwm_capture_timer_disable .literal.mcpwm_capture_timer_enable .literal.mcpwm_capture_timer_get_resolution .literal.mcpwm_capture_timer_set_phase_on_sync .literal.mcpwm_capture_timer_start .literal.mcpwm_capture_timer_stop .literal.mcpwm_del_capture_channel .literal.mcpwm_del_capture_timer .literal.mcpwm_new_capture_channel .literal.mcpwm_new_capture_timer .text .text.mcpwm_cap_timer_destroy .text.mcpwm_capture_channel_destroy .text.mcpwm_capture_channel_disable .text.mcpwm_capture_channel_enable .text.mcpwm_capture_channel_register_event_callbacks .text.mcpwm_capture_channel_trigger_soft_catch .text.mcpwm_capture_timer_disable .text.mcpwm_capture_timer_enable .text.mcpwm_capture_timer_get_resolution .text.mcpwm_capture_timer_set_phase_on_sync .text.mcpwm_capture_timer_start .text.mcpwm_capture_timer_stop .text.mcpwm_del_capture_channel .text.mcpwm_del_capture_timer .text.mcpwm_new_capture_channel .text.mcpwm_new_capture_timer)
    *libesp_driver_mcpwm.a:mcpwm_cmpr.*(.literal.mcpwm_comparator_destroy .literal.mcpwm_comparator_register_event_callbacks .literal.mcpwm_comparator_set_compare_value .literal.mcpwm_del_comparator .literal.mcpwm_new_comparator .text .text.mcpwm_comparator_destroy .text.mcpwm_comparator_register_event_callbacks .text.mcpwm_comparator_set_compare_value .text.mcpwm_del_comparator .text.mcpwm_new_comparator)
    *libesp_driver_mcpwm.a:mcpwm_fault.*(.literal.mcpwm_del_fault .literal.mcpwm_del_gpio_fault .literal.mcpwm_del_soft_fault .literal.mcpwm_fault_register_event_callbacks .literal.mcpwm_gpio_fault_destroy .literal.mcpwm_new_gpio_fault .literal.mcpwm_new_soft_fault .literal.mcpwm_soft_fault_activate .text .text.mcpwm_del_fault .text.mcpwm_del_gpio_fault .text.mcpwm_del_soft_fault .text.mcpwm_fault_register_event_callbacks .text.mcpwm_gpio_fault_destroy .text.mcpwm_new_gpio_fault .text.mcpwm_new_soft_fault .text.mcpwm_soft_fault_activate)
    *libesp_driver_mcpwm.a:mcpwm_oper.*(.literal.mcpwm_del_operator .literal.mcpwm_new_operator .literal.mcpwm_operator_apply_carrier .literal.mcpwm_operator_connect_timer .literal.mcpwm_operator_destroy .literal.mcpwm_operator_recover_from_fault .literal.mcpwm_operator_register_event_callbacks .literal.mcpwm_operator_set_brake_on_fault .text .text.mcpwm_del_operator .text.mcpwm_new_operator .text.mcpwm_operator_apply_carrier .text.mcpwm_operator_connect_timer .text.mcpwm_operator_destroy .text.mcpwm_operator_recover_from_fault .text.mcpwm_operator_register_event_callbacks .text.mcpwm_operator_set_brake_on_fault)
    *libesp_driver_mcpwm.a:mcpwm_timer.*(.literal.mcpwm_del_timer .literal.mcpwm_new_timer .literal.mcpwm_timer_destroy .literal.mcpwm_timer_disable .literal.mcpwm_timer_enable .literal.mcpwm_timer_get_phase .literal.mcpwm_timer_register_event_callbacks .literal.mcpwm_timer_set_period .literal.mcpwm_timer_set_phase_on_sync .literal.mcpwm_timer_start_stop .text .text.mcpwm_del_timer .text.mcpwm_new_timer .text.mcpwm_timer_destroy .text.mcpwm_timer_disable .text.mcpwm_timer_enable .text.mcpwm_timer_get_phase .text.mcpwm_timer_register_event_callbacks .text.mcpwm_timer_set_period .text.mcpwm_timer_set_phase_on_sync .text.mcpwm_timer_start_stop)
    *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_alloc_encoder_mem .literal.rmt_del_encoder .text .text.rmt_alloc_encoder_mem .text.rmt_del_encoder)
    *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_del_rx_channel .literal.rmt_ll_rx_enable_dma$part$0 .literal.rmt_new_rx_channel .literal.rmt_receive .literal.rmt_rx_demodulate_carrier .literal.rmt_rx_destroy .literal.rmt_rx_disable .literal.rmt_rx_enable .literal.rmt_rx_register_event_callbacks .text .text.rmt_del_rx_channel .text.rmt_ll_rx_enable_dma$part$0 .text.rmt_new_rx_channel .text.rmt_receive .text.rmt_rx_demodulate_carrier .text.rmt_rx_destroy .text.rmt_rx_disable .text.rmt_rx_enable .text.rmt_rx_register_event_callbacks)
    *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_del_sync_manager .literal.rmt_del_tx_channel .literal.rmt_ll_tx_enable_dma$part$0 .literal.rmt_new_sync_manager .literal.rmt_new_tx_channel .literal.rmt_sync_reset .literal.rmt_transmit .literal.rmt_tx_destroy .literal.rmt_tx_disable .literal.rmt_tx_enable .literal.rmt_tx_modulate_carrier .literal.rmt_tx_register_event_callbacks .literal.rmt_tx_switch_gpio .literal.rmt_tx_wait_all_done .text .text.rmt_del_sync_manager .text.rmt_del_tx_channel .text.rmt_ll_tx_enable_dma$part$0 .text.rmt_new_sync_manager .text.rmt_new_tx_channel .text.rmt_sync_reset .text.rmt_transmit .text.rmt_tx_destroy .text.rmt_tx_disable .text.rmt_tx_enable .text.rmt_tx_modulate_carrier .text.rmt_tx_register_event_callbacks .text.rmt_tx_switch_gpio .text.rmt_tx_wait_all_done)
    *libesp_driver_uart.a:uart_vfs.*(.literal.__esp_system_init_fn_init_vfs_uart .literal.esp_vfs_uart_get_vfs .literal.uart_access .literal.uart_close .literal.uart_end_select .literal.uart_fcntl .literal.uart_fstat .literal.uart_fsync .literal.uart_get_avail_data_len .literal.uart_get_avail_data_len_via_driver .literal.uart_open .literal.uart_read .literal.uart_read_char .literal.uart_return_char .literal.uart_rx_char .literal.uart_rx_char_via_driver .literal.uart_start_select .literal.uart_tcdrain .literal.uart_tcflush .literal.uart_tcgetattr .literal.uart_tcsetattr .literal.uart_tx_char .literal.uart_tx_char_via_driver .literal.uart_vfs_dev_port_set_rx_line_endings .literal.uart_vfs_dev_port_set_tx_line_endings .literal.uart_vfs_dev_register .literal.uart_vfs_dev_set_rx_line_endings .literal.uart_vfs_dev_set_tx_line_endings .literal.uart_vfs_dev_use_driver .literal.uart_vfs_dev_use_nonblocking .literal.uart_write .text .text.__esp_system_init_fn_init_vfs_uart .text.esp_vfs_uart_get_vfs .text.uart_access .text.uart_close .text.uart_end_select .text.uart_fcntl .text.uart_fstat .text.uart_fsync .text.uart_get_avail_data_len .text.uart_get_avail_data_len_via_driver .text.uart_open .text.uart_read .text.uart_read_char .text.uart_return_char .text.uart_rx_char .text.uart_rx_char_via_driver .text.uart_start_select .text.uart_tcdrain .text.uart_tcflush .text.uart_tcgetattr .text.uart_tcsetattr .text.uart_tx_char .text.uart_tx_char_via_driver .text.uart_vfs_dev_port_set_rx_line_endings .text.uart_vfs_dev_port_set_tx_line_endings .text.uart_vfs_dev_register .text.uart_vfs_dev_set_rx_line_endings .text.uart_vfs_dev_set_tx_line_endings .text.uart_vfs_dev_use_driver .text.uart_vfs_dev_use_nonblocking .text.uart_vfs_include_dev_init .text.uart_write)
    *libesp_driver_usb_serial_jtag.a:usb_serial_jtag_vfs.*(.literal.__esp_system_init_fn_init_vfs_usj_sec .literal.esp_vfs_usb_serial_jtag_get_vfs .literal.usb_serial_jtag_end_select .literal.usb_serial_jtag_fcntl .literal.usb_serial_jtag_fstat .literal.usb_serial_jtag_fsync .literal.usb_serial_jtag_open .literal.usb_serial_jtag_read .literal.usb_serial_jtag_read_char .literal.usb_serial_jtag_return_char$part$0 .literal.usb_serial_jtag_rx_char_no_driver .literal.usb_serial_jtag_start_select .literal.usb_serial_jtag_tcdrain .literal.usb_serial_jtag_tcflush .literal.usb_serial_jtag_tcgetattr .literal.usb_serial_jtag_tcsetattr .literal.usb_serial_jtag_tx_char_no_driver .literal.usb_serial_jtag_vfs_register .literal.usb_serial_jtag_vfs_set_rx_line_endings .literal.usb_serial_jtag_vfs_set_tx_line_endings .literal.usb_serial_jtag_vfs_use_driver .literal.usb_serial_jtag_vfs_use_nonblocking .literal.usb_serial_jtag_wait_tx_done_no_driver .literal.usb_serial_jtag_write .literal.usbjtag_rx_char_via_driver .literal.usbjtag_tx_char_via_driver .literal.usbjtag_wait_tx_done_via_driver .text .text.__esp_system_init_fn_init_vfs_usj_sec .text.esp_vfs_usb_serial_jtag_get_vfs .text.usb_serial_jtag_close .text.usb_serial_jtag_end_select .text.usb_serial_jtag_fcntl .text.usb_serial_jtag_fstat .text.usb_serial_jtag_fsync .text.usb_serial_jtag_open .text.usb_serial_jtag_read .text.usb_serial_jtag_read_char .text.usb_serial_jtag_return_char$part$0 .text.usb_serial_jtag_rx_char_no_driver .text.usb_serial_jtag_start_select .text.usb_serial_jtag_tcdrain .text.usb_serial_jtag_tcflush .text.usb_serial_jtag_tcgetattr .text.usb_serial_jtag_tcsetattr .text.usb_serial_jtag_tx_char_no_driver .text.usb_serial_jtag_vfs_include_dev_init .text.usb_serial_jtag_vfs_register .text.usb_serial_jtag_vfs_set_rx_line_endings .text.usb_serial_jtag_vfs_set_tx_line_endings .text.usb_serial_jtag_vfs_use_driver .text.usb_serial_jtag_vfs_use_nonblocking .text.usb_serial_jtag_wait_tx_done_no_driver .text.usb_serial_jtag_write .text.usbjtag_rx_char_via_driver .text.usbjtag_tx_char_via_driver .text.usbjtag_wait_tx_done_via_driver)
    *libesp_event.a:default_event_loop.*(.literal.esp_event_handler_instance_register .literal.esp_event_handler_instance_unregister .literal.esp_event_handler_register .literal.esp_event_handler_unregister .literal.esp_event_loop_create_default .literal.esp_event_loop_delete_default .literal.esp_event_post .text .text.esp_event_handler_instance_register .text.esp_event_handler_instance_unregister .text.esp_event_handler_register .text.esp_event_handler_unregister .text.esp_event_loop_create_default .text.esp_event_loop_delete_default .text.esp_event_post)
    *libesp_event.a:esp_event.*(.literal.base_node_add_handler .literal.esp_event_handler_instance_register_with .literal.esp_event_handler_instance_unregister_with .literal.esp_event_handler_register_with .literal.esp_event_handler_register_with_internal .literal.esp_event_handler_unregister_with .literal.esp_event_handler_unregister_with_internal .literal.esp_event_loop_create .literal.esp_event_loop_delete .literal.esp_event_loop_run .literal.esp_event_loop_run_task .literal.esp_event_post_to .literal.handler_instances_add .literal.handler_instances_remove .literal.handler_instances_remove_all .literal.loop_node_add_handler .literal.loop_remove_handler .text .text.base_node_add_handler .text.esp_event_dump .text.esp_event_handler_instance_register_with .text.esp_event_handler_instance_unregister_with .text.esp_event_handler_register_with .text.esp_event_handler_register_with_internal .text.esp_event_handler_unregister_with .text.esp_event_handler_unregister_with_internal .text.esp_event_loop_create .text.esp_event_loop_delete .text.esp_event_loop_run .text.esp_event_loop_run_task .text.esp_event_post_to .text.handler_instances_add .text.handler_instances_remove .text.handler_instances_remove_all .text.loop_node_add_handler .text.loop_remove_handler)
    *libesp_hw_support.a:adc_share_hw_ctrl.*(.literal.adc_calc_hw_calibration_code .literal.adc_lock_acquire .literal.adc_lock_release .literal.adc_lock_try_acquire .text .text.adc2_wifi_acquire .text.adc2_wifi_release .text.adc_calc_hw_calibration_code .text.adc_lock_acquire .text.adc_lock_release .text.adc_lock_try_acquire)
    *libesp_hw_support.a:cpu.*(.text .text.esp_cpu_clear_breakpoint .text.esp_cpu_clear_watchpoint .text.esp_cpu_set_breakpoint .text.esp_cpu_set_watchpoint)
    *libesp_hw_support.a:esp_clk.*(.literal.esp_clk_rtc_time .text .text.esp_clk_rtc_time)
    *libesp_hw_support.a:gdma.*(.literal.gdma_apply_strategy .literal.gdma_config_transfer .literal.gdma_connect .literal.gdma_del_channel .literal.gdma_del_rx_channel .literal.gdma_del_tx_channel .literal.gdma_disconnect .literal.gdma_get_alignment_constraints .literal.gdma_get_free_m2m_trig_id_mask .literal.gdma_get_group_channel_id .literal.gdma_new_ahb_channel .literal.gdma_register_rx_event_callbacks .literal.gdma_register_tx_event_callbacks .literal.gdma_release_group_handle .literal.gdma_release_pair_handle .literal.gdma_set_priority .text .text.gdma_apply_strategy .text.gdma_config_transfer .text.gdma_connect .text.gdma_del_channel .text.gdma_del_rx_channel .text.gdma_del_tx_channel .text.gdma_disconnect .text.gdma_get_alignment_constraints .text.gdma_get_free_m2m_trig_id_mask .text.gdma_get_group_channel_id .text.gdma_new_ahb_channel .text.gdma_register_rx_event_callbacks .text.gdma_register_tx_event_callbacks .text.gdma_release_group_handle .text.gdma_release_pair_handle .text.gdma_set_priority)
    *libesp_hw_support.a:periph_ctrl.*(.literal.periph_ll_get_clk_en_mask .literal.periph_ll_get_clk_en_reg .literal.periph_ll_get_rst_en_reg .literal.periph_module_disable .literal.periph_module_enable .text .text.periph_ll_get_clk_en_mask .text.periph_ll_get_clk_en_reg .text.periph_ll_get_rst_en_mask .text.periph_ll_get_rst_en_reg .text.periph_module_disable .text.periph_module_enable)
    *libesp_hw_support.a:regi2c_ctrl.*(.text)
    *libesp_hw_support.a:rtc_init.*(.literal.get_rtc_dbias_by_efuse$constprop$0 .literal.rtc_init .text .text.get_rtc_dbias_by_efuse$constprop$0 .text.rtc_init)
    *libesp_hw_support.a:rtc_sleep.*(.text)
    *libesp_hw_support.a:sar_periph_ctrl.*(.literal.s_sar_power_acquire .literal.s_sar_power_release .literal.sar_periph_ctrl_adc_continuous_power_acquire .literal.sar_periph_ctrl_adc_continuous_power_release .literal.sar_periph_ctrl_adc_oneshot_power_acquire .literal.sar_periph_ctrl_adc_oneshot_power_release .literal.sar_periph_ctrl_init .literal.sar_periph_ctrl_pwdet_power_acquire .literal.sar_periph_ctrl_pwdet_power_release .text .text.s_sar_power_acquire .text.s_sar_power_release .text.sar_periph_ctrl_adc_continuous_power_acquire .text.sar_periph_ctrl_adc_continuous_power_release .text.sar_periph_ctrl_adc_oneshot_power_acquire .text.sar_periph_ctrl_adc_oneshot_power_release .text.sar_periph_ctrl_init .text.sar_periph_ctrl_pwdet_power_acquire .text.sar_periph_ctrl_pwdet_power_release)
    *libesp_hw_support.a:sar_periph_ctrl_common.*(.literal.temp_sensor_sync_tsens_idx .text .text.temp_sensor_sync_tsens_idx)
    *libesp_hw_support.a:sleep_cpu.*(.literal.esp_sleep_cpu_pd_low_deinit .literal.esp_sleep_cpu_pd_low_init .literal.esp_sleep_cpu_retention_deinit .literal.esp_sleep_cpu_retention_init .literal.sleep_cpu_configure .text .text.esp_sleep_cpu_pd_low_deinit .text.esp_sleep_cpu_pd_low_init .text.esp_sleep_cpu_retention_deinit .text.esp_sleep_cpu_retention_init .text.sleep_cpu_configure)
    *libesp_hw_support.a:sleep_modem.*(.literal.esp_pm_register_inform_out_light_sleep_overhead_callback .literal.esp_pm_register_light_sleep_default_params_config_callback .literal.esp_pm_unregister_inform_out_light_sleep_overhead_callback .literal.esp_pm_unregister_light_sleep_default_params_config_callback .text .text.esp_pm_register_inform_out_light_sleep_overhead_callback .text.esp_pm_register_light_sleep_default_params_config_callback .text.esp_pm_unregister_inform_out_light_sleep_overhead_callback .text.esp_pm_unregister_light_sleep_default_params_config_callback .text.sleep_modem_configure)
    *libesp_hw_support.a:sleep_modes.*(.literal.esp_deep_sleep .literal.esp_deep_sleep_deregister_hook .literal.esp_deep_sleep_deregister_phy_hook .literal.esp_deep_sleep_register_hook .literal.esp_deep_sleep_register_phy_hook .literal.esp_deep_sleep_try .literal.esp_get_deep_sleep_wake_stub .literal.esp_sleep_disable_bt_wakeup .literal.esp_sleep_disable_ext1_wakeup_io .literal.esp_sleep_disable_wakeup_source .literal.esp_sleep_disable_wifi_wakeup .literal.esp_sleep_enable_adc_tsens_monitor .literal.esp_sleep_enable_bt_wakeup .literal.esp_sleep_enable_ext0_wakeup .literal.esp_sleep_enable_ext1_wakeup .literal.esp_sleep_enable_ext1_wakeup_io .literal.esp_sleep_enable_gpio_wakeup .literal.esp_sleep_enable_touchpad_wakeup .literal.esp_sleep_enable_uart_wakeup .literal.esp_sleep_enable_wifi_wakeup .literal.esp_sleep_get_ext1_wakeup_status .literal.esp_sleep_get_touchpad_wakeup_status .literal.esp_sleep_get_wakeup_cause .literal.esp_sleep_is_valid_wakeup_gpio .literal.esp_sleep_overhead_out_time_refresh .literal.esp_sleep_pd_config .literal.esp_sleep_periph_use_8m .literal.esp_sleep_sub_mode_config .literal.esp_sleep_sub_mode_dump_config .literal.esp_sleep_sub_mode_force_disable .literal.rtc_sleep_enable_ultra_low .literal.rtcio_ll_function_select$constprop$0 .literal.s_sleep_hook_deregister .literal.s_sleep_hook_register .text .text.esp_deep_sleep .text.esp_deep_sleep_deregister_hook .text.esp_deep_sleep_deregister_phy_hook .text.esp_deep_sleep_register_hook .text.esp_deep_sleep_register_phy_hook .text.esp_deep_sleep_try .text.esp_get_deep_sleep_wake_stub .text.esp_sleep_disable_bt_wakeup .text.esp_sleep_disable_ext1_wakeup_io .text.esp_sleep_disable_wakeup_source .text.esp_sleep_disable_wifi_beacon_wakeup .text.esp_sleep_disable_wifi_wakeup .text.esp_sleep_enable_adc_tsens_monitor .text.esp_sleep_enable_bt_wakeup .text.esp_sleep_enable_ext0_wakeup .text.esp_sleep_enable_ext1_wakeup .text.esp_sleep_enable_ext1_wakeup_io .text.esp_sleep_enable_gpio_wakeup .text.esp_sleep_enable_touchpad_wakeup .text.esp_sleep_enable_uart_wakeup .text.esp_sleep_enable_ulp_wakeup .text.esp_sleep_enable_wifi_beacon_wakeup .text.esp_sleep_enable_wifi_wakeup .text.esp_sleep_get_ext1_wakeup_status .text.esp_sleep_get_touchpad_wakeup_status .text.esp_sleep_get_wakeup_cause .text.esp_sleep_is_valid_wakeup_gpio .text.esp_sleep_overhead_out_time_refresh .text.esp_sleep_pd_config .text.esp_sleep_periph_use_8m .text.esp_sleep_sub_mode_config .text.esp_sleep_sub_mode_dump_config .text.esp_sleep_sub_mode_force_disable .text.rtc_sleep_enable_ultra_low .text.rtcio_ll_function_select$constprop$0 .text.s_sleep_hook_deregister .text.s_sleep_hook_register)
    *libesp_phy.a:phy_override.*(.literal.esp_phy_efuse_get_chip_ver_pkg .literal.esp_phy_efuse_get_mac .literal.phy_set_pwdet_power .literal.set_xpd_sar .text .text.esp_phy_efuse_get_chip_ver_pkg .text.esp_phy_efuse_get_mac .text.include_esp_phy_override .text.phy_set_pwdet_power .text.set_xpd_sar)
    *libesp_pm.a:pm_impl.*(.literal.esp_pm_get_configuration .literal.esp_pm_impl_get_mode .literal.esp_pm_impl_idle_hook .literal.esp_pm_impl_init .literal.esp_pm_impl_waiti .text .text.esp_pm_configure .text.esp_pm_get_configuration .text.esp_pm_impl_get_mode .text.esp_pm_impl_idle_hook .text.esp_pm_impl_init .text.esp_pm_impl_waiti)
    *libesp_system.a:esp_system_chip.*(.literal.esp_get_free_heap_size .literal.esp_get_free_internal_heap_size .literal.esp_get_idf_version .literal.esp_get_minimum_free_heap_size .text .text.esp_get_free_heap_size .text.esp_get_free_internal_heap_size .text.esp_get_idf_version .text.esp_get_minimum_free_heap_size)
    *libesp_timer.a:esp_timer_impl_common.*(.text)
    *libesp_timer.a:esp_timer_impl_systimer.*(.literal.esp_timer_impl_deinit .literal.esp_timer_impl_early_init .literal.esp_timer_impl_get_alarm_reg .literal.esp_timer_impl_init .text .text.esp_timer_impl_deinit .text.esp_timer_impl_early_init .text.esp_timer_impl_get_alarm_reg .text.esp_timer_impl_init)
    *libfreertos.a:app_startup.*(.literal .literal.* .text .text.*)
    *libfreertos.a:freertos_compatibility.*(.literal .literal.* .text .text.*)
    *libfreertos.a:idf_additions.*(.literal .literal.* .text .text.*)
    *libfreertos.a:idf_additions_event_groups.*(.literal .literal.* .text .text.*)
    *libfreertos.a:tasks.*(.literal.uxTaskGetSnapshotAll .text.uxTaskGetSnapshotAll)
    *libfreertos.a:tasks.*(.literal.xTaskGetNext .text.xTaskGetNext)
    *libhal.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_init .literal.gdma_ahb_hal_set_burst_size .text .text.gdma_ahb_hal_connect_peri .text.gdma_ahb_hal_disconnect_peri .text.gdma_ahb_hal_enable_burst .text.gdma_ahb_hal_enable_intr .text.gdma_ahb_hal_get_intr_status_reg .text.gdma_ahb_hal_init .text.gdma_ahb_hal_set_burst_size .text.gdma_ahb_hal_set_priority .text.gdma_ahb_hal_set_strategy)
    *libhal.a:gdma_hal_top.*(.text .text.gdma_hal_connect_peri .text.gdma_hal_deinit .text.gdma_hal_disconnect_peri .text.gdma_hal_enable_access_encrypt_mem .text.gdma_hal_enable_burst .text.gdma_hal_enable_intr .text.gdma_hal_get_intr_status_reg .text.gdma_hal_set_burst_size .text.gdma_hal_set_priority .text.gdma_hal_set_strategy)
    *libhal.a:gpio_hal.*(.literal.gpio_hal_intr_disable .literal.gpio_hal_intr_enable_on_core .literal.gpio_hal_iomux_in .literal.gpio_hal_iomux_out .text .text.gpio_hal_intr_disable .text.gpio_hal_intr_enable_on_core .text.gpio_hal_iomux_in .text.gpio_hal_iomux_out)
    *libhal.a:rtc_cntl_hal.*(.literal.rtc_cntl_hal_dma_link_init .text .text.rtc_cntl_hal_dma_link_init)
    *libhal.a:timer_hal.*(.literal.timer_hal_deinit .literal.timer_hal_init .text .text.timer_hal_deinit .text.timer_hal_init .text.timer_hal_set_counter_value)
    *libheap.a:multi_heap.*(.literal.multi_heap_check .literal.multi_heap_dump .literal.multi_heap_dump_tlsf .literal.multi_heap_find_containing_block_impl .literal.multi_heap_get_info_impl .literal.multi_heap_register_impl .literal.multi_heap_reset_minimum_free_bytes .literal.multi_heap_restore_minimum_free_bytes .literal.multi_heap_walk .text .text.multi_heap_check .text.multi_heap_dump .text.multi_heap_dump_tlsf .text.multi_heap_find_containing_block_impl .text.multi_heap_free_size_impl .text.multi_heap_get_info_impl .text.multi_heap_get_info_tlsf .text.multi_heap_minimum_free_size_impl .text.multi_heap_register_impl .text.multi_heap_reset_minimum_free_bytes .text.multi_heap_restore_minimum_free_bytes .text.multi_heap_walk)
    *libheap.a:tlsf.*(.literal.default_walker .literal.integrity_walker .literal.tlsf_add_pool .literal.tlsf_check .literal.tlsf_check_pool .literal.tlsf_create .literal.tlsf_create_with_pool .literal.tlsf_malloc_addr .literal.tlsf_remove_pool .literal.tlsf_walk_pool .text .text.default_walker .text.integrity_walker .text.tlsf_add_pool .text.tlsf_check .text.tlsf_check_pool .text.tlsf_create .text.tlsf_create_with_pool .text.tlsf_destroy .text.tlsf_find_containing_block .text.tlsf_fit_size .text.tlsf_malloc_addr .text.tlsf_pool_overhead .text.tlsf_remove_pool .text.tlsf_walk_pool)
    *liblog.a:log_timestamp.*(.text)
    *liblog.a:log_write.*(.literal.esp_log_set_vprintf .text .text.esp_log_set_vprintf)
    *liblog.a:tag_log_level.*(.literal.esp_log_level_get .literal.esp_log_level_set .literal.log_level_get .text .text.esp_log_level_get .text.esp_log_level_set .text.log_level_get)
    *liblwip.a:vfs_lwip.*(.literal.esp_vfs_lwip_sockets_register .literal.lwip_fcntl_r_wrapper .literal.lwip_fstat .literal.lwip_get_socket_select_semaphore .literal.lwip_ioctl_r_wrapper .literal.lwip_stop_socket_select .text .text.esp_vfs_lwip_sockets_register .text.lwip_fcntl_r_wrapper .text.lwip_fstat .text.lwip_get_socket_select_semaphore .text.lwip_ioctl_r_wrapper .text.lwip_stop_socket_select)
    *libnewlib.a:esp_time_impl.*(.literal.esp_sync_timekeeping_timers .literal.esp_time_impl_get_time .literal.esp_time_impl_get_time_since_boot .text .text.esp_sync_timekeeping_timers .text.esp_time_impl_get_time .text.esp_time_impl_get_time_since_boot)
    *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_app_disable_protect .literal.esp_flash_get_protectable_regions .literal.esp_flash_read_chip_id .literal.esp_flash_read_id .literal.esp_flash_read_unique_chip_id .literal.esp_flash_suspend_cmd_init .literal.find_region .text .text.esp_flash_app_disable_protect .text.esp_flash_get_protectable_regions .text.esp_flash_read_chip_id .text.esp_flash_read_id .text.esp_flash_read_unique_chip_id .text.esp_flash_suspend_cmd_init .text.find_region)
    *libspi_flash.a:spi_flash_os_func_app.*(.literal.esp_flash_app_enable_os_functions .literal.esp_flash_deinit_os_functions .literal.esp_flash_init_os_functions .text .text.esp_flash_app_enable_os_functions .text.esp_flash_deinit_os_functions .text.esp_flash_init_main_bus_lock .text.esp_flash_init_os_functions .text.esp_flash_set_dangerous_write_protection .text.use_bus_lock)
    *libspi_flash.a:spi_flash_os_func_noos.*(.text)
    *libvfs.a:vfs.*(.literal.call_end_selects .literal.esp_vfs_access .literal.esp_vfs_close .literal.esp_vfs_closedir .literal.esp_vfs_dump_fds .literal.esp_vfs_dump_registered_paths .literal.esp_vfs_fcntl_r .literal.esp_vfs_free_fs_ops .literal.esp_vfs_fstat .literal.esp_vfs_fsync .literal.esp_vfs_ftruncate .literal.esp_vfs_ioctl .literal.esp_vfs_link .literal.esp_vfs_lseek .literal.esp_vfs_mkdir .literal.esp_vfs_open .literal.esp_vfs_opendir .literal.esp_vfs_pread .literal.esp_vfs_pwrite .literal.esp_vfs_read .literal.esp_vfs_readdir .literal.esp_vfs_readdir_r .literal.esp_vfs_register .literal.esp_vfs_register_common .literal.esp_vfs_register_fd .literal.esp_vfs_register_fd_range .literal.esp_vfs_register_fd_with_local_fd .literal.esp_vfs_register_fs .literal.esp_vfs_register_fs_common .literal.esp_vfs_register_fs_with_id .literal.esp_vfs_register_with_id .literal.esp_vfs_rename .literal.esp_vfs_rewinddir .literal.esp_vfs_rmdir .literal.esp_vfs_seekdir .literal.esp_vfs_select .literal.esp_vfs_select_triggered .literal.esp_vfs_set_readonly_flag .literal.esp_vfs_stat .literal.esp_vfs_telldir .literal.esp_vfs_truncate .literal.esp_vfs_unlink .literal.esp_vfs_unregister .literal.esp_vfs_unregister_fd .literal.esp_vfs_unregister_with_id .literal.esp_vfs_utime .literal.esp_vfs_write .literal.get_local_fd .literal.get_vfs_for_fd .literal.get_vfs_for_index .literal.get_vfs_for_path .literal.set_global_fd_sets .literal.tcdrain .literal.tcflow .literal.tcflush .literal.tcgetattr .literal.tcgetsid .literal.tcsendbreak .literal.tcsetattr .literal.translate_path .text .text.call_end_selects .text.esp_vfs_access .text.esp_vfs_close .text.esp_vfs_closedir .text.esp_vfs_dump_fds .text.esp_vfs_dump_registered_paths .text.esp_vfs_fcntl_r .text.esp_vfs_free_fs_ops .text.esp_vfs_fstat .text.esp_vfs_fsync .text.esp_vfs_ftruncate .text.esp_vfs_ioctl .text.esp_vfs_link .text.esp_vfs_lseek .text.esp_vfs_mkdir .text.esp_vfs_open .text.esp_vfs_opendir .text.esp_vfs_pread .text.esp_vfs_pwrite .text.esp_vfs_read .text.esp_vfs_readdir .text.esp_vfs_readdir_r .text.esp_vfs_register .text.esp_vfs_register_common .text.esp_vfs_register_fd .text.esp_vfs_register_fd_range .text.esp_vfs_register_fd_with_local_fd .text.esp_vfs_register_fs .text.esp_vfs_register_fs_common .text.esp_vfs_register_fs_with_id .text.esp_vfs_register_with_id .text.esp_vfs_rename .text.esp_vfs_rewinddir .text.esp_vfs_rmdir .text.esp_vfs_safe_fd_isset .text.esp_vfs_seekdir .text.esp_vfs_select .text.esp_vfs_select_triggered .text.esp_vfs_set_readonly_flag .text.esp_vfs_stat .text.esp_vfs_telldir .text.esp_vfs_truncate .text.esp_vfs_unlink .text.esp_vfs_unregister .text.esp_vfs_unregister_fd .text.esp_vfs_unregister_with_id .text.esp_vfs_utime .text.esp_vfs_write .text.get_local_fd .text.get_vfs_for_fd .text.get_vfs_for_index .text.get_vfs_for_path .text.set_global_fd_sets .text.tcdrain .text.tcflow .text.tcflush .text.tcgetattr .text.tcgetsid .text.tcsendbreak .text.tcsetattr .text.translate_path .text.vfs_include_syscalls_impl)
    *libxtensa.a:xt_trax.*(.literal .literal.* .text .text.*)
    *libxtensa.a:xtensa_intr.*(.literal .literal.* .text .text.*)
    *(.stub)
    *(.gnu.warning)
    *(.gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
    *(.irom0.text) /* catch stray ICACHE_RODATA_ATTR */
    /**
     * CPU will try to prefetch up to 16 bytes of of instructions.
     * This means that any configuration (e.g. MMU, PMS) must allow
     * safe access to up to 16 bytes after the last real instruction, add
     * dummy bytes to ensure this
     */
    . += 16;
    _text_end = ABSOLUTE(.);
    /**
     * Mark the flash.text end.
     * This can be used for MMU driver to maintain virtual address.
     */
    _instruction_reserved_end = ABSOLUTE(.);
    _etext = .;
    /**
     * Similar to _iram_start, this symbol goes here so it is
     * resolved by addr2line in preference to the first symbol in
     * the flash.text segment.
     */
    _flash_cache_start = ABSOLUTE(0);
  } > default_code_seg
  /**
   * Dummy section represents the .flash.text section but in default_rodata_seg.
   * Thus, it must have its alignment and (at least) its size.
   */
  .flash_rodata_dummy (NOLOAD):
  {
    _flash_rodata_dummy_start = ABSOLUTE(.);
    . = ALIGN(ALIGNOF(.flash.text)) + SIZEOF(.flash.text);
    /* Add alignment of MMU page size + 0x20 bytes for the mapping header. */
    . = ALIGN(0x10000) + 0x20;
  } > default_rodata_seg
  .flash.appdesc : ALIGN(0x10)
  {
    /**
     * Mark flash.rodata start.
     * This can be used for mmu driver to maintain virtual address
     */
    _rodata_reserved_start = ABSOLUTE(.);
    _rodata_start = ABSOLUTE(.);
    /* !DO NOT PUT ANYTHING BEFORE THIS! */
    /* Should be the first.  App version info. */
    *(.rodata_desc .rodata_desc.*)
    /* Should be the second. Custom app version info. */
    *(.rodata_custom_desc .rodata_custom_desc.*)
    /**
     * Create an empty gap within this section. Thanks to this, the end of this
     * section will match .flah.rodata's begin address. Thus, both sections
     * will be merged when creating the final bin image.
     */
    . = ALIGN(ALIGNOF(.flash.rodata));
  } > default_rodata_seg
  ASSERT((ADDR(.flash.rodata) == ADDR(.flash.appdesc) + SIZEOF(.flash.appdesc)), "The gap between .flash.appdesc and .flash.rodata must not exist to produce the final bin image.")
  .flash.rodata : ALIGN(0x10)
  {
    _flash_rodata_start = ABSOLUTE(.);
    *(EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .rodata EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .rodata.* EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .sdata2 EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .sdata2.* EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .srodata EXCLUDE_FILE(*libgcov.a *libphy.a *libapp_trace.a:app_trace.* *libapp_trace.a:app_trace_util.* *libapp_trace.a:port_uart.* *libclang_rt.builtins.a:_divsf3.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:sleep_console.* *libesp_hw_support.a:systimer.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_psram.a:esp_psram_impl_octal.* *libesp_psram.a:mmu_psram_flash.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_rom.a:esp_rom_wdt.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:i2c_hal_iram.* *libhal.a:ledc_hal_iram.* *libhal.a:mmu_hal.* *libhal.a:spi_flash_encrypt_hal_iram.* *libhal.a:spi_flash_hal_gpspi.* *libhal.a:spi_flash_hal_iram.* *libhal.a:spi_hal_iram.* *libhal.a:spi_slave_hal_iram.* *libhal.a:systimer_hal.* *libhal.a:uart_hal_iram.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libnewlib.a:abort.* *libnewlib.a:assert.* *libnewlib.a:heap.* *libnewlib.a:stdatomic.* *libnewlib.a:stdatomic_s32c1i.* *libsoc.a:lldesc.* *libsoc.a:temperature_sensor_periph.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_wrap.*) .srodata.*)
    *(.rodata_wlog_error .rodata_wlog_error.*)
    *(.rodata_wlog_info .rodata_wlog_info.*)
    *(.rodata_wlog_warning .rodata_wlog_warning.*)
    *(.irom1.text) /* catch stray ICACHE_RODATA_ATTR */
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    /* C++ exception handlers table. */
    
 . = ALIGN(4); 
 __XT_EXCEPTION_TABLE_ = ABSOLUTE(.);
    *(.xt_except_table)
    *(.gcc_except_table .gcc_except_table.*)
    *(.gnu.linkonce.e.*)
    
 . = ALIGN(4); 
 __XT_EXCEPTION_DESCS_ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    
 . = ALIGN(4); 
 __eh_frame = ABSOLUTE(.);
    KEEP(*(.eh_frame))
    /**
     * As we are not linking with crtend.o, which includes the CIE terminator
     * (see __FRAME_END__ in libgcc sources), it is manually provided here.
     */
    LONG(0);
    /**
     * C++ constructor tables.
     *
     * Excluding crtbegin.o/crtend.o since IDF doesn't use the toolchain crt.
     */
    
 . = ALIGN(4); 
 __init_array_start = ABSOLUTE(.);
    KEEP (*(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors SORT(.ctors.*)))
    __init_array_end = ABSOLUTE(.);
    /* Addresses of memory regions reserved via SOC_RESERVE_MEMORY_REGION() */
    
 . = ALIGN(4); 
 soc_reserved_memory_region_start = ABSOLUTE(.);
    KEEP (*(.reserved_memory_address))
    soc_reserved_memory_region_end = ABSOLUTE(.);
    /* System init functions registered via ESP_SYSTEM_INIT_FN */
    
 . = ALIGN(4); 
 _esp_system_init_fn_array_start = ABSOLUTE(.);
    KEEP (*(SORT_BY_INIT_PRIORITY(.esp_system_init_fn.*)))
    _esp_system_init_fn_array_end = ABSOLUTE(.);
    _rodata_end = ABSOLUTE(.);
    /* Literals are also RO data. */
    _lit4_start = ABSOLUTE(.);
    *(*.lit4)
    *(.lit4.*)
    *(.gnu.linkonce.lit4.*)
    _lit4_end = ABSOLUTE(.);
    /* TLS data. */
    
 . = ALIGN(4); 
 _thread_local_start = ABSOLUTE(.);
    *(.tdata)
    *(.tdata.*)
    *(.tbss)
    *(.tbss.*)
    _thread_local_end = ABSOLUTE(.);
  } > default_rodata_seg
  _flash_rodata_align = ALIGNOF(.flash.rodata);
  /**
   * This section contains all the rodata that is not used
   * at runtime, helping to avoid an increase in binary size.
   */
  .flash.rodata_noload (NOLOAD) :
  {
    /**
     * This symbol marks the end of flash.rodata. It can be utilized by the MMU
     * driver to maintain the virtual address.
     * NOLOAD rodata may not be included in this section.
     */
    _rodata_reserved_end = ABSOLUTE(.);
    *(.rodata_wlog_debug .rodata_wlog_debug.*)
    *(.rodata_wlog_verbose .rodata_wlog_verbose.*)
  } > default_rodata_seg
  /**
   * Dummy section to skip flash rodata sections.
   * Because to `extern_ram_seg` and `drom0_0_seg` are on the same bus
   */
  .ext_ram.dummy (NOLOAD):
  {
    . = ORIGIN(extern_ram_seg);
    . = . + (_rodata_reserved_end - _flash_rodata_dummy_start);
    . = ALIGN (0x10000);
  } > extern_ram_seg
  /* Marks the end of IRAM code segment */
  .iram0.text_end (NOLOAD) :
  {
    /* Padding for possible CPU prefetch + alignment for PMS split lines */
    . += 16;
    . = ALIGN(256);
    /* iram_end_test section exists for use by memprot unit tests only */
    *(.iram_end_test)
    _iram_text_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.data :
  {
    
 . = ALIGN(4); 
 _iram_data_start = ABSOLUTE(.);
    *(.iram.data .iram.data.*)
    _coredump_iram_start = ABSOLUTE(.);
    *(.iram2.coredump .iram2.coredump.*)
    _coredump_iram_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _iram_data_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.bss (NOLOAD) :
  {
    
 . = ALIGN(4); 
 _iram_bss_start = ABSOLUTE(.);
    *(.iram.bss .iram.bss.*)
    _iram_bss_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _iram_end = ABSOLUTE(.);
  } > iram0_0_seg
  /* Marks the end of data, bss and possibly rodata  */
  .dram0.heap_start (NOLOAD) :
  {
    /* Lowest possible start address for the heap */
    
 . = ALIGN(8); 
 _heap_low_start = ABSOLUTE(.);
  } > dram0_0_seg
  /**
   * This section is not included in the binary image; it is only present in the ELF file.
   * It is used to keep certain symbols in the ELF file.
   */
  .noload 0 (INFO) :
  {
    _noload_keep_in_elf_start = ABSOLUTE(.);
    KEEP(*(.noload_keep_in_elf .noload_keep_in_elf.*))
    _noload_keep_in_elf_end = ABSOLUTE(.);
  }
  /* DWARF 1 */
  .debug 0 : { *(.debug) }
  .line 0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo 0 : { *(.debug_srcinfo) }
  .debug_sfnames 0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges 0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev 0 : { *(.debug_abbrev) }
  .debug_line 0 : { *(.debug_line) }
  .debug_frame 0 : { *(.debug_frame) }
  .debug_str 0 : { *(.debug_str) }
  .debug_loc 0 : { *(.debug_loc) }
  .debug_macinfo 0 : { *(.debug_macinfo) }
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  /* DWARF 3 */
  .debug_ranges 0 : { *(.debug_ranges) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames 0 : { *(.debug_varnames) }
  /* GNU DWARF 2 extensions */
  .debug_gnu_pubnames 0 : { *(.debug_gnu_pubnames) }
  .debug_gnu_pubtypes 0 : { *(.debug_gnu_pubtypes) }
  /* DWARF 4 */
  .debug_types 0 : { *(.debug_types) }
  /* DWARF 5 */
  .debug_addr 0 : { *(.debug_addr) }
  .debug_line_str 0 : { *(.debug_line_str) }
  .debug_loclists 0 : { *(.debug_loclists) }
  .debug_macro 0 : { *(.debug_macro) }
  .debug_names 0 : { *(.debug_names) }
  .debug_rnglists 0 : { *(.debug_rnglists) }
  .debug_str_offsets 0 : { *(.debug_str_offsets) }
  .comment 0 : { *(.comment) }
  .note.GNU-stack 0: { *(.note.GNU-stack) }
/**
 * .xt.prop and .xt.lit sections will be used by the debugger and disassembler
 * to get more information about raw data present in the code.
 * Indeed, it may be required to add some padding at some points in the code
 * in order to align a branch/jump destination on a particular bound.
 * Padding these instructions will generate null bytes that shall be
 * interpreted as data, and not code by the debugger or disassembler.
 * This section will only be present in the ELF file, not in the final binary
 * For more details, check GCC-212
 */
  .xtensa.info 0: { *(.xtensa.info) }
  .xt.prop 0 : { *(.xt.prop .xt.prop.* .gnu.linkonce.prop.*) }
  .xt.lit 0 : { *(.xt.lit .xt.lit.* .gnu.linkonce.p.*) }
  /DISCARD/ :
  {
   *(.fini)
   *(.eh_frame_hdr)
  }
}
ASSERT(((_iram_end - ORIGIN(iram0_0_seg)) <= LENGTH(iram0_0_seg)),
          "IRAM0 segment data does not fit.")
ASSERT(((_heap_low_start - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
          "DRAM segment data does not fit.")
