#include "stm32f7xx_hal.h"

#include <stdint.h>
#include "stm32f7xx_hal.h"

#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static const uint32_t cie1931[101] =
{
	  0,   0,   1,   1,  1,    1,   2,   2,   2,   3,
	  3,   3,   4,   4,  4,    5,   5,   6,   6,   7,
	  8,   8,   9,  10,  10,  11,  12,  13,  14,  15,
	 16,  17,  18,  19,  20,  22,  23,  24,  26,  27,
	 29,  30,  32,  34,  35,  37,  39,  41,  43,  45,
	 47,  49,  51,  54,  56,  58,  61,  64,  66,  69,
	 72,  75,  78,  81,  84,  87,  90,  93,  97, 100,
	104, 108, 111, 115, 119, 123, 127, 131, 136, 140,
	145, 149, 154, 159, 163, 168, 173, 179, 184, 189,
	195, 200, 206, 212, 217, 223, 230, 236, 242, 248,
	255,
};

static const uint8_t phase1[20] = 
	{167,203,231,249,255,249,231,203,167,128,89,53,25,7,1,7,25,53,89,128};
		
static const uint8_t phase2[20] = 
	{213,180,141,102,65,34,12,2,4,18,43,76,115,154,192,222,244,254,252,238};
		
static const uint8_t phase3[20] = 
	{4,2,12,34,65,102,141,180,213,238,252,254,244,222,192,154,115,76,43,18};

void ledInit();
void ledRGB(int r, int g, int b, int lum);
void nopDelay(int delay);
void LedsRGB(int nbParam, ...);

HAL_StatusTypeDef HAL_InitTick (uint32_t toto) {
	return HAL_OK;
}

int main(void)
{
	 
	
	GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOB_CLK_ENABLE();
	
	/* Configure GPIO pin: B8, B9 (GPIO_DEBUG) */
  GPIO_InitStruct.Pin  = GPIO_PIN_9 | GPIO_PIN_8;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL; 
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
	
	
	
	for(;;)
	{
		static int j = 0;
		
		ledInit();
		//LedsRGB(6,0xFF220000,0xFF002200,0xFF000022,0xFF222222,0xFF002200,0xFF220022);
		
		int value1;
		int value2;
		int value3;
		
		for(int i = 0; i<20; i++){
			value1 = phase1[(i+j)%20];
			value2 = phase2[(i+j)%20];
			value3 = phase3[(i+j)%20];
			
			ledRGB(value1,value2,value3, 0x05);
		}
		
		nopDelay(1000000);
		j++;
			
		//ledRGB(255, 255, 0, 1);
	}
}
