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

    MODULE  ?cstartup

        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)

        SECTION .intvec:CODE:NOROOT(2)

        EXTERN  __iar_program_start
        EXTERN  SystemInit
        PUBLIC  __vector_table

        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     Reset_Handler             ; Reset Handler
        DCD     NMI_Handler               ; NMI Handler
        DCD     HardFault_Handler         ; Hard Fault Handler
        DCD     0                         ; Reserved (no MemManage on Cortex-M0)
        DCD     0                         ; Reserved (no BusFault on Cortex-M0)
        DCD     0                         ; Reserved (no UsageFault on Cortex-M0)
        DCD     0                         ; Reserved
        DCD     0                         ; Reserved
        DCD     0                         ; Reserved
        DCD     0                         ; Reserved
        DCD     SVC_Handler               ; SVCall Handler
        DCD     0                         ; Reserved (no DebugMon on Cortex-M0)
        DCD     0                         ; Reserved
        DCD     PendSV_Handler            ; PendSV Handler
        DCD     SysTick_Handler           ; SysTick Handler

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;
        THUMB

        PUBWEAK Reset_Handler
        SECTION .text:CODE:REORDER:NOROOT(2)
Reset_Handler
        LDR     R0, =SystemInit
        BLX     R0
        LDR     R0, =__iar_program_start
        BX      R0

        PUBWEAK NMI_Handler
        SECTION .text:CODE:REORDER:NOROOT(1)
NMI_Handler
        B NMI_Handler

        PUBWEAK HardFault_Handler
        SECTION .text:CODE:REORDER:NOROOT(1)
HardFault_Handler
        B HardFault_Handler

        PUBWEAK SVC_Handler
        SECTION .text:CODE:REORDER:NOROOT(1)
SVC_Handler
        B SVC_Handler

        PUBWEAK PendSV_Handler
        SECTION .text:CODE:REORDER:NOROOT(1)
PendSV_Handler
        B PendSV_Handler

        PUBWEAK SysTick_Handler
        SECTION .text:CODE:REORDER:NOROOT(1)
SysTick_Handler
        B SysTick_Handler


        PUBWEAK WWDG_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
WWDG_IRQHandler
        B WWDG_IRQHandler

        PUBWEAK BLE_SW_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_SW_IRQHandler
        B BLE_SW_IRQHandler

        PUBWEAK RTC_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
RTC_IRQHandler
        B RTC_IRQHandler

        PUBWEAK BLE_HSLOT_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_HSLOT_IRQHandler
        B BLE_HSLOT_IRQHandler

        PUBWEAK QSPI_FLASH_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
QSPI_FLASH_IRQHandler
        B QSPI_FLASH_IRQHandler

        PUBWEAK RCC_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
RCC_IRQHandler
        B RCC_IRQHandler

        PUBWEAK EXTI0_1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
EXTI0_1_IRQHandler
        B EXTI0_1_IRQHandler

        PUBWEAK EXTI2_3_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
EXTI2_3_IRQHandler
        B EXTI2_3_IRQHandler

        PUBWEAK EXTI4_15_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
EXTI4_15_IRQHandler
        B EXTI4_15_IRQHandler

        PUBWEAK BLE_FINETGT_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_FINETGT_IRQHandler
        B BLE_FINETGT_IRQHandler

        PUBWEAK BLE_FIFO_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_FIFO_IRQHandler
        B BLE_FIFO_IRQHandler

        PUBWEAK DMA_CH1_2_3_4_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
DMA_CH1_2_3_4_IRQHandler
        B DMA_CH1_2_3_4_IRQHandler

        PUBWEAK DMA_CH5_6_7_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
DMA_CH5_6_7_IRQHandler
        B DMA_CH5_6_7_IRQHandler

        PUBWEAK ATIM1_BRK_UP_TRG_COM_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
ATIM1_BRK_UP_TRG_COM_IRQHandler
        B ATIM1_BRK_UP_TRG_COM_IRQHandler

        PUBWEAK ATIM1_CC_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
ATIM1_CC_IRQHandler
        B ATIM1_CC_IRQHandler

        PUBWEAK LPTIM_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
LPTIM_IRQHandler
        B LPTIM_IRQHandler

        PUBWEAK GTIM1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
GTIM1_IRQHandler
        B GTIM1_IRQHandler

        PUBWEAK BLE_ERROR_CYPT_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_ERROR_CYPT_IRQHandler
        B BLE_ERROR_CYPT_IRQHandler

        PUBWEAK BLE_WAKE_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_WAKE_IRQHandler
        B BLE_WAKE_IRQHandler

        PUBWEAK BLE_TIMESTAMP_TGT1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_TIMESTAMP_TGT1_IRQHandler
        B BLE_TIMESTAMP_TGT1_IRQHandler

        PUBWEAK BTIM1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BTIM1_IRQHandler
        B BTIM1_IRQHandler

        PUBWEAK ADC_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
ADC_IRQHandler
        B ADC_IRQHandler

        PUBWEAK SPI2_SPI3_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
SPI2_SPI3_IRQHandler
        B SPI2_SPI3_IRQHandler

        PUBWEAK I2C1_I2C2_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
I2C1_I2C2_IRQHandler
        B I2C1_I2C2_IRQHandler

        PUBWEAK BLE_TIMESTAMP_TGT2_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_TIMESTAMP_TGT2_IRQHandler
        B BLE_TIMESTAMP_TGT2_IRQHandler

        PUBWEAK SPI1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
SPI1_IRQHandler
        B SPI1_IRQHandler

        PUBWEAK BLE_SLP_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
BLE_SLP_IRQHandler
        B BLE_SLP_IRQHandler

        PUBWEAK LPUART2_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
LPUART2_IRQHandler
        B LPUART2_IRQHandler

        PUBWEAK USART1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
USART1_IRQHandler
        B USART1_IRQHandler

        PUBWEAK LPUART1_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
LPUART1_IRQHandler
        B LPUART1_IRQHandler

        PUBWEAK USART2_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
USART2_IRQHandler
        B USART2_IRQHandler

        PUBWEAK CAN_IRQHandler
        SECTION .text:CODE:REORDER:NOROOT(1)
CAN_IRQHandler
        B CAN_IRQHandler


        END
