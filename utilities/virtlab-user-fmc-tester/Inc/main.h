/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32l4xx_hal.h"

#include "stm32l4xx_ll_system.h"
#include "stm32l4xx_ll_gpio.h"
#include "stm32l4xx_ll_exti.h"
#include "stm32l4xx_ll_bus.h"
#include "stm32l4xx_ll_cortex.h"
#include "stm32l4xx_ll_rcc.h"
#include "stm32l4xx_ll_utils.h"
#include "stm32l4xx_ll_pwr.h"
#include "stm32l4xx_ll_dma.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define LED3_Pin LL_GPIO_PIN_13
#define LED3_GPIO_Port GPIOC
#define OSC32_IN_Pin LL_GPIO_PIN_14
#define OSC32_IN_GPIO_Port GPIOC
#define OSC_IN_Pin LL_GPIO_PIN_0
#define OSC_IN_GPIO_Port GPIOH
#define AIN1_Pin LL_GPIO_PIN_0
#define AIN1_GPIO_Port GPIOC
#define AIN2_Pin LL_GPIO_PIN_1
#define AIN2_GPIO_Port GPIOC
#define AIN3_Pin LL_GPIO_PIN_2
#define AIN3_GPIO_Port GPIOC
#define AIN4_Pin LL_GPIO_PIN_3
#define AIN4_GPIO_Port GPIOC
#define OA1_INP_Pin LL_GPIO_PIN_0
#define OA1_INP_GPIO_Port GPIOA
#define OA1_INM_Pin LL_GPIO_PIN_1
#define OA1_INM_GPIO_Port GPIOA
#define AIN5_Pin LL_GPIO_PIN_2
#define AIN5_GPIO_Port GPIOA
#define OA1_OUT_Pin LL_GPIO_PIN_3
#define OA1_OUT_GPIO_Port GPIOA
#define DAC_OUT1_Pin LL_GPIO_PIN_4
#define DAC_OUT1_GPIO_Port GPIOA
#define DAC_OUT2_Pin LL_GPIO_PIN_5
#define DAC_OUT2_GPIO_Port GPIOA
#define OA1_INPA6_Pin LL_GPIO_PIN_6
#define OA1_INPA6_GPIO_Port GPIOA
#define OA2_INM_Pin LL_GPIO_PIN_7
#define OA2_INM_GPIO_Port GPIOA
#define COMP_INM_Pin LL_GPIO_PIN_4
#define COMP_INM_GPIO_Port GPIOC
#define COMP_INP_Pin LL_GPIO_PIN_5
#define COMP_INP_GPIO_Port GPIOC
#define OA2_COMP_OUT_Pin LL_GPIO_PIN_0
#define OA2_COMP_OUT_GPIO_Port GPIOB
#define VLCD_Pin LL_GPIO_PIN_2
#define VLCD_GPIO_Port GPIOB
#define SW6_Pin LL_GPIO_PIN_10
#define SW6_GPIO_Port GPIOB
#define SW7_Pin LL_GPIO_PIN_11
#define SW7_GPIO_Port GPIOB
#define USB_DN_Pin LL_GPIO_PIN_11
#define USB_DN_GPIO_Port GPIOA
#define USB_DP_Pin LL_GPIO_PIN_12
#define USB_DP_GPIO_Port GPIOA
#define SWDIO_Pin LL_GPIO_PIN_13
#define SWDIO_GPIO_Port GPIOA
#define SWCLK_Pin LL_GPIO_PIN_14
#define SWCLK_GPIO_Port GPIOA
#define LED0_Pin LL_GPIO_PIN_10
#define LED0_GPIO_Port GPIOC
#define LED1_Pin LL_GPIO_PIN_11
#define LED1_GPIO_Port GPIOC
#define LED2_Pin LL_GPIO_PIN_12
#define LED2_GPIO_Port GPIOC
#define SW0_Pin LL_GPIO_PIN_3
#define SW0_GPIO_Port GPIOB
#define SW1_Pin LL_GPIO_PIN_4
#define SW1_GPIO_Port GPIOB
#define SW2_Pin LL_GPIO_PIN_5
#define SW2_GPIO_Port GPIOB
#define SW3_Pin LL_GPIO_PIN_6
#define SW3_GPIO_Port GPIOB
#define SW5_Pin LL_GPIO_PIN_8
#define SW5_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
