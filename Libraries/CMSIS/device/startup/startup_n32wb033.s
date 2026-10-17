; *********************************************************************************************************
;     Copyright (c) 2026, Nsing Technologies Inc.
;
;     All rights reserved.
;
;     This software is the exclusive property of Nsing Technologies Inc. (Hereinafter
; referred to as Nsing). This software, and the product of Nsing described herein
; (Hereinafter referred to as the Product) are owned by Nsing under the laws and treaties
; of the People's Republic of China and other applicable jurisdictions worldwide.
;
;     Nsing does not grant any license under its patents, copyrights, trademarks, or other
; intellectual property rights. Names and brands of third party may be mentioned or referred
; thereto (if any) for identification purposes only.
;
;     Nsing reserves the right to make changes, corrections, enhancements, modifications, and
; improvements to this software at any time without notice. Please contact Nsing and obtain
; the latest version of this software before placing orders.

;     Although Nsing has attempted to provide accurate and reliable information, Nsing assumes
; no responsibility for the accuracy and reliability of this software.
;
;     It is the responsibility of the user of this software to properly design, program, and test
; the functionality and safety of any application made of this information and any resulting product.
; In no event shall Nsing be liable for any direct, indirect, incidental, special,exemplary, or
; consequential damages arising in any way out of the use of this software or the Product.
;
;     Nsing Products are neither intended nor warranted for usage in systems or equipment, any
; malfunction or failure of which may cause loss of human life, bodily injury or severe property
; damage. Such applications are deemed, "Insecure Usage".
;
;     All Insecure Usage shall be made at user's risk. User shall indemnify Nsing and hold Nsing
; harmless from and against all claims, costs, damages, and other liabilities, arising from or related
; to any customer's Insecure Usage.

;     Any express or implied warranty with regard to this software or the Product, including,but not
; limited to, the warranties of merchantability, fitness for a particular purpose and non-infringement
; are disclaimed to the fullest extent permitted by law.

;     Unless otherwise explicitly permitted by Nsing, anyone may not duplicate, modify, transcribe
; or otherwise distribute this software for any purposes, in whole or in part.
;
;     Nsing products and technologies shall not be used for or incorporated into any products or systems
; whose manufacture, use, or sale is prohibited under any applicable domestic or foreign laws or regulations.
; User shall comply with any applicable export control laws and regulations promulgated and administered by
; the governments of any countries asserting jurisdiction over the parties or transactions.
; ************************************************************************************************************

; Amount of memory (in bytes) allocated for Stack
; Tailor this value to your application needs
; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00002000   ; [v4.8] 2KB stack overflows into .bss under deep paths (updata ack/proto) -> raised to 8KB

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset
                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp                   ; Top of Stack
                DCD     Reset_Handler                  ; Reset Handler
                DCD     NMI_Handler                    ; NMI Handler
                DCD     HardFault_Handler              ; Hard Fault Handler
                DCD     0                              ; Reserved (no MemManage on Cortex-M0)
                DCD     0                              ; Reserved (no BusFault on Cortex-M0)
                DCD     0                              ; Reserved (no UsageFault on Cortex-M0)
                DCD     0                              ; Reserved
                DCD     0                              ; Reserved
                DCD     0                              ; Reserved
                DCD     0                              ; Reserved
                DCD     SVC_Handler                    ; SVCall Handler
                DCD     0                              ; Reserved (no DebugMon on Cortex-M0)
                DCD     0                              ; Reserved
                DCD     PendSV_Handler                 ; PendSV Handler
                DCD     SysTick_Handler                ; SysTick Handler

                ; External Interrupts
				DCD     WWDG_IRQHandler                     ; Window WatchDog Interrupt
				DCD     BLE_SW_IRQHandler                   ; BLE SW Trigger Interrupt
				DCD     RTC_IRQHandler                      ; RTC Interrupt through EXTI Line16/17
				DCD     BLE_HSLOT_IRQHandler                ; BLE Half Slot Reference Interrupt
				DCD     0                                   ; Reserved
				DCD     RCC_IRQHandler                      ; RCC Global Interrupt
				DCD     EXTI0_1_IRQHandler                  ; EXTI Line0 ~ Line1 Interrupt
				DCD     EXTI2_3_IRQHandler                  ; EXTI Line2 ~ Line3 Interrupt
				DCD     EXTI4_15_IRQHandler                 ; EXTI Line4 ~ Line15 Interrupt
				DCD     BLE_FINETGT_IRQHandler              ; BLE Fine Time Target Interrupt
				DCD     BLE_FIFO_IRQHandler                 ; BLE FIFO Interrupt
				DCD     DMA_CH1_2_3_4_IRQHandler            ; DMA Channel1/2/3/4 Interrupt
				DCD     DMA_CH5_6_7_IRQHandler              ; DMA Channel5/6/7 Interrupt
				DCD     ATIM1_BRK_UP_TRG_COM_IRQHandler     ; ATIM1 Break, Update, Trigger and Commutation Interrupt
				DCD     ATIM1_CC_IRQHandler                 ; ATIM1 Capture Compare Interrupt
				DCD     LPTIM_IRQHandler                    ; LPTIM Global Interrupt through EXTI Line20
				DCD     GTIM1_IRQHandler                    ; GTIM1 Global Interrupt
				DCD     BLE_ERROR_CYPT_IRQHandler           ; BLE Error/Crypt Interrupt
				DCD     BLE_WAKE_IRQHandler                 ; BLE Wakeup Interrupt through EXTI Line21
				DCD     BLE_TIMESTAMP_TGT1_IRQHandler       ; BLE Timestamp Target1 Interrupt
				DCD     BTIM1_IRQHandler                    ; BTIM1 Global Interrupt
				DCD     ADC_IRQHandler                      ; ADC Global Interrupt
				DCD     SPI2_SPI3_IRQHandler                ; SPI2/SPI3 Global Interrupt
				DCD     I2C1_I2C2_IRQHandler                ; I2C1/I2C2 Global Interrupt
				DCD     BLE_TIMESTAMP_TGT2_IRQHandler       ; BLE Timestamp Target2 Interrupt
				DCD     SPI1_IRQHandler                     ; SPI1 Global Interrupt
				DCD     BLE_SLP_IRQHandler                  ; BLE Sleep Mode Interrupt
				DCD     LPUART2_IRQHandler                  ; LPUART2 Global Interrupt through EXTI Line19
				DCD     USART1_IRQHandler                   ; USART1 Global Interrupt
				DCD     LPUART1_IRQHandler                  ; LPUART1 Global Interrupt through EXTI Line18
				DCD     USART2_IRQHandler                   ; USART2 Global Interrupt
				DCD     CAN_IRQHandler                      ; CAN Global Interrupt


__Vectors_End

__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY

; Reset handler routine
Reset_Handler    PROC
                 EXPORT  Reset_Handler                 [WEAK]
                 IMPORT  __main
                 IMPORT  SystemInit
                 LDR     R0, =SystemInit
                 BLX     R0
                 LDR     R0, =__main
                 BX      R0
                 ENDP

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler                    [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler              [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler                    [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler                 [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler                [WEAK]
                B       .
                ENDP

Default_Handler PROC

				EXPORT  WWDG_IRQHandler                      [WEAK]
				EXPORT  BLE_SW_IRQHandler                    [WEAK]
				EXPORT  RTC_IRQHandler                       [WEAK]
				EXPORT  BLE_HSLOT_IRQHandler                 [WEAK]
				EXPORT  QSPI_FLASH_IRQHandler                [WEAK]
				EXPORT  RCC_IRQHandler                       [WEAK]
				EXPORT  EXTI0_1_IRQHandler                   [WEAK]
				EXPORT  EXTI2_3_IRQHandler                   [WEAK]
				EXPORT  EXTI4_15_IRQHandler                  [WEAK]
				EXPORT  BLE_FINETGT_IRQHandler               [WEAK]
				EXPORT  BLE_FIFO_IRQHandler                  [WEAK]
				EXPORT  DMA_CH1_2_3_4_IRQHandler             [WEAK]
				EXPORT  DMA_CH5_6_7_IRQHandler               [WEAK]
				EXPORT  ATIM1_BRK_UP_TRG_COM_IRQHandler      [WEAK]
				EXPORT  ATIM1_CC_IRQHandler                  [WEAK]
				EXPORT  LPTIM_IRQHandler                     [WEAK]
				EXPORT  GTIM1_IRQHandler                     [WEAK]
				EXPORT  BLE_ERROR_CYPT_IRQHandler            [WEAK]
				EXPORT  BLE_WAKE_IRQHandler                  [WEAK]
				EXPORT  BLE_TIMESTAMP_TGT1_IRQHandler        [WEAK]
				EXPORT  BTIM1_IRQHandler                     [WEAK]
				EXPORT  ADC_IRQHandler                       [WEAK]
				EXPORT  SPI2_SPI3_IRQHandler                 [WEAK]
				EXPORT  I2C1_I2C2_IRQHandler                 [WEAK]
				EXPORT  BLE_TIMESTAMP_TGT2_IRQHandler        [WEAK]
				EXPORT  SPI1_IRQHandler                      [WEAK]
				EXPORT  BLE_SLP_IRQHandler                   [WEAK]
				EXPORT  LPUART2_IRQHandler                   [WEAK]
				EXPORT  USART1_IRQHandler                    [WEAK]
				EXPORT  LPUART1_IRQHandler                   [WEAK]
				EXPORT  USART2_IRQHandler                    [WEAK]
				EXPORT  CAN_IRQHandler                       [WEAK]
WWDG_IRQHandler
BLE_SW_IRQHandler
RTC_IRQHandler
BLE_HSLOT_IRQHandler
QSPI_FLASH_IRQHandler
RCC_IRQHandler
EXTI0_1_IRQHandler
EXTI2_3_IRQHandler
EXTI4_15_IRQHandler
BLE_FINETGT_IRQHandler
BLE_FIFO_IRQHandler
DMA_CH1_2_3_4_IRQHandler
DMA_CH5_6_7_IRQHandler
ATIM1_BRK_UP_TRG_COM_IRQHandler
ATIM1_CC_IRQHandler
LPTIM_IRQHandler
GTIM1_IRQHandler
BLE_ERROR_CYPT_IRQHandler
BLE_WAKE_IRQHandler
BLE_TIMESTAMP_TGT1_IRQHandler
BTIM1_IRQHandler
ADC_IRQHandler
SPI2_SPI3_IRQHandler
I2C1_I2C2_IRQHandler
BLE_TIMESTAMP_TGT2_IRQHandler
SPI1_IRQHandler
BLE_SLP_IRQHandler
LPUART2_IRQHandler
USART1_IRQHandler
LPUART1_IRQHandler
USART2_IRQHandler
CAN_IRQHandler

                B       .

                ENDP

                ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
                 IF      :DEF:__MICROLIB

                 EXPORT  __initial_sp
                 EXPORT  __heap_base
                 EXPORT  __heap_limit

                 ELSE

                 IMPORT  __use_two_region_memory
                 EXPORT  __user_initial_stackheap

__user_initial_stackheap

                 LDR     R0, =  Heap_Mem
                 LDR     R1, =(Stack_Mem + Stack_Size)
                 LDR     R2, = (Heap_Mem +  Heap_Size)
                 LDR     R3, = Stack_Mem
                 BX      LR

                 ALIGN

                 ENDIF

                 END
