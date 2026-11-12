/************************************************************************//**
 * \file		ext_keyboard.h
 * \brief		Function to use the extension keyboard
 * \author	pascal (dot) sartoretti (at) hevs (dot) ch
 ***************************************************************************/


#ifndef __EXT_26PIN_H
#define __EXT_26PIN_H

#include <stdint.h>
#include "stm32f7xx_hal.h"

#define nCS_FREQ_GEN_Pin GPIO_PIN_6
#define nCS_FREQ_GEN_GPIO_Port GPIOF
typedef enum
{
	SINUS,
	TRIANGLE,
	SQUARE
}f_mode;
/************************************************************************//**
 * \brief 		Inits the Sparkfun frequency generator connected to SPI
*            port on the 26 pin connector pins below:
*            SCK   = pin 3
*            MOSI  = pin 2
*            nCS   = pin 4
 ***************************************************************************/ 
int32_t Ext_FreqGen_Init (void);
/************************************************************************//**
 * \brief 		Sets a frequency on Sparfun generator output
*  \param     frequency The frequency in hertz (below 20 Hz signal is bad)
*  \param     mode The signal mode (SINUS,TRIANGLE,SQUARE)
*
* The signal is centered at about 1.61 volt +/- 0.53 volts
 ***************************************************************************/
void Ext_FreqGen_Set(uint32_t frequency,f_mode mode);

/************************************************************************//**
 * \brief 		Inits the debug pin PF9
 ***************************************************************************/
 int32_t Ext_Debug_Init(void);



#endif /* __BOARD_LED_H */

