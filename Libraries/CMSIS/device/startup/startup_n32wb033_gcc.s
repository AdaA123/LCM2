/**
*     Copyright (c) 2026, Nsing Technologies Inc.
*
*     All rights reserved.
*
*     This software is the exclusive property of Nsing Technologies Inc. (Hereinafter
* referred to as Nsing). This software, and the product of Nsing described herein
* (Hereinafter referred to as the Product) are owned by Nsing under the laws and treaties
* of the People's Republic of China and other applicable jurisdictions worldwide.
*
*     Nsing does not grant any license under its patents, copyrights, trademarks, or other
* intellectual property rights. Names and brands of third party may be mentioned or referred
* thereto (if any) for identification purposes only.
*
*     Nsing reserves the right to make changes, corrections, enhancements, modifications, and
* improvements to this software at any time without notice. Please contact Nsing and obtain
* the latest version of this software before placing orders.

*     Although Nsing has attempted to provide accurate and reliable information, Nsing assumes
* no responsibility for the accuracy and reliability of this software.
*
*     It is the responsibility of the user of this software to properly design, program, and test
* the functionality and safety of any application made of this information and any resulting product.
* In no event shall Nsing be liable for any direct, indirect, incidental, special,exemplary, or
* consequential damages arising in any way out of the use of this software or the Product.
*
*     Nsing Products are neither intended nor warranted for usage in systems or equipment, any
* malfunction or failure of which may cause loss of human life, bodily injury or severe property
* damage. Such applications are deemed, "Insecure Usage".
*
*     All Insecure Usage shall be made at user's risk. User shall indemnify Nsing and hold Nsing
* harmless from and against all claims, costs, damages, and other liabilities, arising from or related
* to any customer's Insecure Usage.

*     Any express or implied warranty with regard to this software or the Product, including,but not
* limited to, the warranties of merchantability, fitness for a particular purpose and non-infringement
* are disclaimed to the fullest extent permitted by law.

*     Unless otherwise explicitly permitted by Nsing, anyone may not duplicate, modify, transcribe
* or otherwise distribute this software for any purposes, in whole or in part.
*
*     Nsing products and technologies shall not be used for or incorporated into any products or systems
* whose manufacture, use, or sale is prohibited under any applicable domestic or foreign laws or regulations.
* User shall comply with any applicable export control laws and regulations promulgated and administered by
* the governments of any countries asserting jurisdiction over the parties or transactions.
**/


  .syntax unified
  .cpu cortex-m0
  .fpu softvfp
  .thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit

/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever

.size Reset_Handler, .-Reset_Handler

/**
 * This is the code that gets called when the processor receives an
 * unexpected interrupt. This simply enters an infinite loop, preserving
 * the system state for examination by a debugger.
 **/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler

/**
 * The minimal vector table for a Cortex-M0. Note that the proper constructs
 * must be placed on this to ensure that it ends up at physical address 0x00000000.
 **/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  0                              /* Reserved (no MemManage on Cortex-M0) */
  .word  0                              /* Reserved (no BusFault on Cortex-M0)  */
  .word  0                              /* Reserved (no UsageFault on Cortex-M0)*/
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  0                              /* Reserved (no DebugMon on Cortex-M0)  */
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler
  /* External Interrupts */
  .word  WWDG_IRQHandler                      /* Window WatchDog Interrupt */
  .word  BLE_SW_IRQHandler                    /* BLE SW Trigger Interrupt */
  .word  RTC_IRQHandler                       /* RTC Interrupt through EXTI Line16/17 */
  .word  BLE_HSLOT_IRQHandler                 /* BLE Half Slot Reference Interrupt */
  .word  0                                    /* Reserved */
  .word  RCC_IRQHandler                       /* RCC Global Interrupt */
  .word  EXTI0_1_IRQHandler                   /* EXTI Line0 ~ Line1 Interrupt */
  .word  EXTI2_3_IRQHandler                   /* EXTI Line2 ~ Line3 Interrupt */
  .word  EXTI4_15_IRQHandler                  /* EXTI Line4 ~ Line15 Interrupt */
  .word  BLE_FINETGT_IRQHandler               /* BLE Fine Time Target Interrupt */
  .word  BLE_FIFO_IRQHandler                  /* BLE FIFO Interrupt */
  .word  DMA_CH1_2_3_4_IRQHandler             /* DMA Channel1/2/3/4 Interrupt */
  .word  DMA_CH5_6_7_IRQHandler               /* DMA Channel5/6/7 Interrupt */
  .word  ATIM1_BRK_UP_TRG_COM_IRQHandler      /* ATIM1 Break, Update, Trigger and Commutation Interrupt */
  .word  ATIM1_CC_IRQHandler                  /* ATIM1 Capture Compare Interrupt */
  .word  LPTIM_IRQHandler                     /* LPTIM Global Interrupt through EXTI Line20 */
  .word  GTIM1_IRQHandler                     /* GTIM1 Global Interrupt */
  .word  BLE_ERROR_CYPT_IRQHandler            /* BLE Error/Crypt Interrupt */
  .word  BLE_WAKE_IRQHandler                  /* BLE Wakeup Interrupt through EXTI Line21 */
  .word  BLE_TIMESTAMP_TGT1_IRQHandler        /* BLE Timestamp Target1 Interrupt */
  .word  BTIM1_IRQHandler                     /* BTIM1 Global Interrupt */
  .word  ADC_IRQHandler                       /* ADC Global Interrupt */
  .word  SPI2_SPI3_IRQHandler                 /* SPI2/SPI3 Global Interrupt */
  .word  I2C1_I2C2_IRQHandler                 /* I2C1/I2C2 Global Interrupt */
  .word  BLE_TIMESTAMP_TGT2_IRQHandler        /* BLE Timestamp Target2 Interrupt */
  .word  SPI1_IRQHandler                      /* SPI1 Global Interrupt */
  .word  BLE_SLP_IRQHandler                   /* BLE Sleep Mode Interrupt */
  .word  LPUART2_IRQHandler                   /* LPUART2 Global Interrupt through EXTI Line19 */
  .word  USART1_IRQHandler                    /* USART1 Global Interrupt */
  .word  LPUART1_IRQHandler                   /* LPUART1 Global Interrupt through EXTI Line18 */
  .word  USART2_IRQHandler                    /* USART2 Global Interrupt */
  .word  CAN_IRQHandler                       /* CAN Global Interrupt */


/**
 * Provide weak aliases for each Exception handler to the Default_Handler.
 * As they are weak aliases, any function with the same name will override
 * this definition.
 **/

  .weak      NMI_Handler
  .thumb_set NMI_Handler,Default_Handler

  .weak      HardFault_Handler
  .thumb_set HardFault_Handler,Default_Handler

  .weak      SVC_Handler
  .thumb_set SVC_Handler,Default_Handler

  .weak      PendSV_Handler
  .thumb_set PendSV_Handler,Default_Handler

  .weak      SysTick_Handler
  .thumb_set SysTick_Handler,Default_Handler


  .weak      WWDG_IRQHandler
  .thumb_set WWDG_IRQHandler,Default_Handler

  .weak      BLE_SW_IRQHandler
  .thumb_set BLE_SW_IRQHandler,Default_Handler

  .weak      RTC_IRQHandler
  .thumb_set RTC_IRQHandler,Default_Handler

  .weak      BLE_HSLOT_IRQHandler
  .thumb_set BLE_HSLOT_IRQHandler,Default_Handler

  .weak      QSPI_FLASH_IRQHandler
  .thumb_set QSPI_FLASH_IRQHandler,Default_Handler

  .weak      RCC_IRQHandler
  .thumb_set RCC_IRQHandler,Default_Handler

  .weak      EXTI0_1_IRQHandler
  .thumb_set EXTI0_1_IRQHandler,Default_Handler

  .weak      EXTI2_3_IRQHandler
  .thumb_set EXTI2_3_IRQHandler,Default_Handler

  .weak      EXTI4_15_IRQHandler
  .thumb_set EXTI4_15_IRQHandler,Default_Handler

  .weak      BLE_FINETGT_IRQHandler
  .thumb_set BLE_FINETGT_IRQHandler,Default_Handler

  .weak      BLE_FIFO_IRQHandler
  .thumb_set BLE_FIFO_IRQHandler,Default_Handler

  .weak      DMA_CH1_2_3_4_IRQHandler
  .thumb_set DMA_CH1_2_3_4_IRQHandler,Default_Handler

  .weak      DMA_CH5_6_7_IRQHandler
  .thumb_set DMA_CH5_6_7_IRQHandler,Default_Handler

  .weak      ATIM1_BRK_UP_TRG_COM_IRQHandler
  .thumb_set ATIM1_BRK_UP_TRG_COM_IRQHandler,Default_Handler

  .weak      ATIM1_CC_IRQHandler
  .thumb_set ATIM1_CC_IRQHandler,Default_Handler

  .weak      LPTIM_IRQHandler
  .thumb_set LPTIM_IRQHandler,Default_Handler

  .weak      GTIM1_IRQHandler
  .thumb_set GTIM1_IRQHandler,Default_Handler

  .weak      BLE_ERROR_CYPT_IRQHandler
  .thumb_set BLE_ERROR_CYPT_IRQHandler,Default_Handler

  .weak      BLE_WAKE_IRQHandler
  .thumb_set BLE_WAKE_IRQHandler,Default_Handler

  .weak      BLE_TIMESTAMP_TGT1_IRQHandler
  .thumb_set BLE_TIMESTAMP_TGT1_IRQHandler,Default_Handler

  .weak      BTIM1_IRQHandler
  .thumb_set BTIM1_IRQHandler,Default_Handler

  .weak      ADC_IRQHandler
  .thumb_set ADC_IRQHandler,Default_Handler

  .weak      SPI2_SPI3_IRQHandler
  .thumb_set SPI2_SPI3_IRQHandler,Default_Handler

  .weak      I2C1_I2C2_IRQHandler
  .thumb_set I2C1_I2C2_IRQHandler,Default_Handler

  .weak      BLE_TIMESTAMP_TGT2_IRQHandler
  .thumb_set BLE_TIMESTAMP_TGT2_IRQHandler,Default_Handler

  .weak      SPI1_IRQHandler
  .thumb_set SPI1_IRQHandler,Default_Handler

  .weak      BLE_SLP_IRQHandler
  .thumb_set BLE_SLP_IRQHandler,Default_Handler

  .weak      LPUART2_IRQHandler
  .thumb_set LPUART2_IRQHandler,Default_Handler

  .weak      USART1_IRQHandler
  .thumb_set USART1_IRQHandler,Default_Handler

  .weak      LPUART1_IRQHandler
  .thumb_set LPUART1_IRQHandler,Default_Handler

  .weak      USART2_IRQHandler
  .thumb_set USART2_IRQHandler,Default_Handler

  .weak      CAN_IRQHandler
  .thumb_set CAN_IRQHandler,Default_Handler

