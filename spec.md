# BMS 配对功能实现规格（回退后重做）

## 目标
本机作为 **central（主机）** 连接 BMS（peripheral/从机）。BMS 主动发起配对，本机 **被动应答**，采用 **Just Works（无 PIN，NoInputNoOutput）** 配对。需要同时兼容：
- 会发起配对的 BMS（发送 Security Request 或 Pairing Request）；
- 不会发起配对的 BMS（等待超时后直接进入服务发现，跳过配对）。

约束：不主动发起配对；每次重连都重新配对（不存绑定、不写 Flash）；主循环无阻塞；C 源文件保持 GB2312/ANSI 编码。

## 配对流程
1. 连接建立（LINK_UP）后，本机不立即做 MTU 交换与服务发现，而是开启一个「配对等待窗口」定时器（3s）。
2. 若 BMS 发送 **Security Request** → 底层 `GAPC_SECURITY_IND` → 本机以 `ns_sec_send_bond_start(conidx)` 启动配对。
3. 若 BMS 直接发送 **Pairing Request** → 现有 `gapc_bond_req_ind_handler` 已自动应答配对特征。
4. 配对成功 → `NS_SEC_PAIR_SUCCEED` → 上抛 `BLE_PORT_EVENT_BMS_SECURED` → 应用层立即做 MTU + 服务发现。
5. 配对失败 → `NS_SEC_PAIR_FAILED` → 上抛 `BLE_PORT_EVENT_BMS_PAIR_FAILED`，底层精确断开该 BMS 链路。
6. 「配对等待窗口」超时（说明该 BMS 不配对）→ 应用层直接做 MTU + 服务发现。

## 关键设计决策
- **配对参数（Just Works）**：`iocap = GAP_IO_CAP_NO_INPUT_NO_OUTPUT`，`auth = SEC_PARAM_BOND`（**显式去掉 MITM**，否则 NoInputNoOutput 下配对会失败）。`pin_code = 123456` 仅作兜底，Just Works 下不会被使用。
- **不存绑定**：`bond_enable = BOND_STORE_ENABLE(0)`，并设 `bond_sync_delay = 0` 以**避免触发 Flash 写绑定**（每次重连重新配对）。
- **精确断开**：`gapc_bond_ind_handler` 的配对失败原先调用 `ns_ble_disconnect()`（会误断手机链路），改为按 `src_id` 精确 `GAPC_DISCONNECT_CMD`。
- **多连接路由**：`struct sec_msg_t` 新增 `conidx` 字段，让应用层由连接索引定位到 BMS 端点，避免把手机链路的事件误当 BMS。

## 文件与改动

### 1. Middlewares\ble_library\ns_library\sec\ns_sec.h
- `struct sec_msg_t` 在 `msg_id` 后新增字段 `uint8_t conidx;`。

### 2. Middlewares\ble_library\ns_library\sec\ns_sec.c
- 9 处 `ns_sec_msg_handler` 回调点填充 `sec_msg.conidx`：
  - `ns_bond_db_init`（约 148-151 行）填 `0`；
  - 其余 8 处填 `KE_IDX_GET(src_id)`：PAIRING_RSP(534)、PINCODE_DISPLAY(612)、PINCODE_ENTER(629)、PAIR_SUCCEED(706)、PAIR_FAILED(720)、LTK_MISSING(841)、LTK_FOUND(861)、ENC_SUCCEED(881)。
- `gapc_bond_ind_handler` 的 `GAPC_PAIRING_FAILED`：把 `ns_ble_disconnect()` 替换为按 `src_id` 的 `GAPC_DISCONNECT_CMD`（reason=`CO_ERROR_AUTH_FAILURE`）。
- 新增 `gapc_security_ind_handler`（响应从机 Security Request，调用 `ns_sec_send_bond_start(KE_IDX_GET(src_id))`）。
- `app_sec_msg_handler_list` 增加 `{GAPC_SECURITY_IND, (ke_msg_func_t)gapc_security_ind_handler}`。

### 3. Project\inc\ble_port.h
- 事件枚举新增（在 `BLE_PORT_EVENT_BMS_READY` 之后）：
  - `BLE_PORT_EVENT_BMS_SECURED`（配对/加密完成）
  - `BLE_PORT_EVENT_BMS_PAIR_FAILED`（配对失败）

### 4. Project\src\ble_port_rw.c
- 头文件新增 `#include "ns_sec.h"`、`#include "app_user_config.h"`。
- 新增 `port_sec_init(void)`：构造 `struct ns_sec_init_t` 并调用 `ns_sec_init`（参数见「配对参数」决策）。
- 新增 `port_sec_msg_handler(struct sec_msg_t const*)`：`NS_SEC_PAIR_SUCCEED` → `BLE_PORT_EVENT_BMS_SECURED`；`NS_SEC_PAIR_FAILED` → `BLE_PORT_EVENT_BMS_PAIR_FAILED`（经 `endpoint_id_from_conn_index(conidx)` 判定为 BMS 端点后才上抛）。
- `rw_stack_start()` 在 `SysPlatform_Initialize()` 成功后调用 `port_sec_init()`。
- 检查现有 `app_ble_sec_init` 并非本端口路径（app_ble.c 未编译），本端口需自行初始化。

### 5. Project\src\my_ble.c
- 常量新增 `#define BLE_GATEWAY_PAIR_WAIT_MS 3000u`。
- 消息枚举新增 `BLE_GATEWAY_MSG_PAIR_WAIT = 14`。
- `gateway_app_t` 新增字段 `Byte bms_secured;`（标识本连接是否已完成配对/加密，观察用）。
- 新增函数 `ble_gateway_bms_service_start(gateway_app_t*)`：执行 MTU 交换(517) + `BLE_DEV_IOC_BMS_DATA_ENABLE` + 启动 `BMS_HEALTH` 定时器（从当前 LINK_UP 内联代码抽取）。
- `BLE_PORT_EVENT_LINK_UP` 的 BMS 分支：不再立即做 MTU/服务发现，改为清 `bms_secured=0`、清旧 `PAIR_WAIT` 定时器、设置 `BLE_GATEWAY_MSG_PAIR_WAIT`（`BLE_GATEWAY_PAIR_WAIT_MS`）。
- `ble_gateway_port_event` 新增：
  - `BLE_PORT_EVENT_BMS_SECURED`：置 `bms_secured=1`、清 `PAIR_WAIT` 定时器、调 `ble_gateway_bms_service_start`。
  - `BLE_PORT_EVENT_BMS_PAIR_FAILED`：记录日志并触发 `ble_gateway_session_retry`（底层已精确断开）。
- `ble_gateway_message_process` 新增：
  - `BLE_GATEWAY_MSG_PAIR_WAIT`：调 `ble_gateway_bms_service_start`（超时 = 该 BMS 不配对）。
- `BLE_PORT_EVENT_LINK_DOWN` 的 BMS 分支：清 `PAIR_WAIT` 定时器、`bms_secured=0`（在现有重置逻辑中补充）。

## 验证步骤
1. Keil 重新编译（文件需为 GB2312/ANSI 编码，若写入工具生成为 UTF-8 需用户另存为 GB2312）。
2. 开启日志宏（`app_user_config.h` 中 `NS_LOG_INFO_ENABLE` 等）观察配对链路。
3. 上板各测两类 BMS：
   - 配对型 BMS：LINK_UP 后 3s 内出现配对成功（BMS_SECURED），随后 MTU/服务发现、BMS_READY；
   - 非配对型 BMS：LINK_UP 后约 3s 超时（PAIR_WAIT），直接 MTU/服务发现、BMS_READY。
4. 回归：手机连接（peripheral 角色）不应受配对改动影响，蓝牙不断连。

## 待确认/风险
- `auth` 采用 `SEC_PARAM_BOND`（去掉 MITM），是否与目标 BMS 固件的配对参数完全匹配，需上板实测确认。
- 配对型 BMS 若实际走 `GAPC_SECURITY_IND` 而非直接 Pairing Request，靠新增 `gapc_security_ind_handler` 兜住；两者都已覆盖。