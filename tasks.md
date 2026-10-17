# 任务清单

- [x] 1. `ns_sec.h`：`struct sec_msg_t` 增加 `uint8_t conidx;`。
- [x] 2. `ns_sec.c`：
  - [x] 9 处回调点填 `conidx`（1 处 0，8 处 `KE_IDX_GET(src_id)`，初始值统一改为 `{NS_SEC_NULL_MSG, 0, {0}}`）；
  - [x] `GAPC_PAIRING_FAILED` 改为按 `src_id` 精确断开（`CO_ERROR_AUTH_FAILURE`）；
  - [x] 新增 `gapc_security_ind_handler`；
  - [x] handler 表加 `GAPC_SECURITY_IND`。
- [x] 3. `ble_port.h`：事件枚举加 `BMS_SECURED` / `BMS_PAIR_FAILED`。
- [x] 4. `ble_port_rw.c`：加 include、`port_sec_init`、`port_sec_msg_handler`、`rw_stack_start` 调用。
- [x] 5. `my_ble.c`：加常量/枚举/字段/`ble_gateway_bms_service_start`、LINK_UP 开配对窗口、SECURED/PAIR_FAILED/PAIR_WAIT 处理、LINK_DOWN 清理。
- [x] 6. 自查并提醒 Keil 编译与两种 BMS 上板验证。