
#include "stm32f7xx_hal.h"
#include "ext_26pin.h"

SPI_HandleTypeDef hspi2;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
int32_t Ext_Debug_Init (void) {
  GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOF_CLK_ENABLE();

  /* Configure GPIO pin: PF9 (GPIO_DEBUG) */
  GPIO_InitStruct.Pin  = GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOF, &GPIO_InitStruct);

  return 0;
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
int32_t Ext_FreqGen_Init (void)
{
  GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOF_CLK_ENABLE();	
  __HAL_RCC_GPIOI_CLK_ENABLE();	
  __HAL_RCC_GPIOB_CLK_ENABLE();	
	
  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_SET);
	
  /*Configure GPIO pin : nCS_FREQ_GEN_Pin */
  GPIO_InitStruct.Pin = nCS_FREQ_GEN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(nCS_FREQ_GEN_GPIO_Port, &GPIO_InitStruct);

	
  __HAL_RCC_SPI2_CLK_ENABLE();
  
   /**SPI2 GPIO Configuration    
   PI1     ------> SPI2_SCK
   PB15     ------> SPI2_MOSI 
    */
    GPIO_InitStruct.Pin = GPIO_PIN_1;
    GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
    GPIO_InitStruct.Alternate = GPIO_AF5_SPI2;
    HAL_GPIO_Init(GPIOI, &GPIO_InitStruct);

    GPIO_InitStruct.Pin = GPIO_PIN_15;
    GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
    GPIO_InitStruct.Alternate = GPIO_AF5_SPI2;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

	
  /* SPI2 parameter configuration*/
  hspi2.Instance = SPI2;
  hspi2.Init.Mode = SPI_MODE_MASTER;
  hspi2.Init.Direction = SPI_DIRECTION_2LINES;
  hspi2.Init.DataSize = SPI_DATASIZE_8BIT;
  hspi2.Init.CLKPolarity = SPI_POLARITY_HIGH;
  hspi2.Init.CLKPhase = SPI_PHASE_1EDGE;
  hspi2.Init.NSS = SPI_NSS_SOFT;
  hspi2.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_64;
  hspi2.Init.FirstBit = SPI_FIRSTBIT_MSB;
  hspi2.Init.TIMode = SPI_TIMODE_DISABLE;
  hspi2.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
  hspi2.Init.CRCPolynomial = 7;
  hspi2.Init.CRCLength = SPI_CRC_LENGTH_DATASIZE;
  hspi2.Init.NSSPMode = SPI_NSS_PULSE_DISABLE;
  if (HAL_SPI_Init(&hspi2) != HAL_OK)	
		return -1;
  Ext_FreqGen_Set(20,SQUARE);
  Ext_FreqGen_Set(20,SQUARE);
	return 0;
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
void Ext_FreqGen_Set(uint32_t frequency,f_mode mode)
{
	uint8_t data[2];
	float calcDivisor;
	uint32_t divisorInt;
	calcDivisor = ((float)frequency * 268435456L) / 16000000L;
	divisorInt = (uint32_t)calcDivisor + 1;
	//----------------------------------------------------------------------------
	// reset generator
	data[0] = 0x21;
	data[1] = 0x00;
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_RESET);
	HAL_SPI_Transmit(&hspi2,data,2,10);
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_SET);
	//----------------------------------------------------------------------------
	// set frequency LSB (14 bits)
	data[0] = ((divisorInt & 0x3FFF) | 0x4000) >> 8;
	data[1] = ((divisorInt & 0x3FFF) | 0x4000) >> 0;
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_RESET);
	HAL_SPI_Transmit(&hspi2,data,2,10);
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_SET);
	//----------------------------------------------------------------------------
	// set frequency MSB (14 bits)
	data[0] = (((divisorInt>>14) & 0x3FFF) | 0x4000) >> 8;
	data[1] = (((divisorInt>>14) & 0x3FFF) | 0x4000) >> 0;
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_RESET);
	HAL_SPI_Transmit(&hspi2,data,2,10);
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_SET);
	//----------------------------------------------------------------------------
	// set output signal
	data[0] = 0x20;		// unreset
	switch(mode)
	{
		case SINUS:
			data[1] = 0x00;
			break;		
		case TRIANGLE:
			data[1] = 0x02;
			break;		
		case SQUARE:
			data[1] = 0x28;
			break;
	}
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_RESET);
	HAL_SPI_Transmit(&hspi2,data,2,10);
	HAL_GPIO_WritePin(nCS_FREQ_GEN_GPIO_Port, nCS_FREQ_GEN_Pin, GPIO_PIN_SET);
}
