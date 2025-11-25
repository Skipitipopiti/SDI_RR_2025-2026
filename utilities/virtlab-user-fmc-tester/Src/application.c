/*
 * application.c
 *
 *  Created on: Oct 20, 2020
 *      Author: max
 */

#include "main.h"
#include "cmsis_os2.h"
#include "io.h"
#include "usbserial.h"

extern ADC_HandleTypeDef hadc1;
extern ADC_HandleTypeDef hadc3;

extern COMP_HandleTypeDef hcomp1;

extern DAC_HandleTypeDef hdac1;

extern LCD_HandleTypeDef hlcd;

extern OPAMP_HandleTypeDef hopamp1;
extern OPAMP_HandleTypeDef hopamp2;

void usage() {
	usbserialPrintf( "\r\nUsage:\r\n" );
	usbserialPrintf( "    Wrrrrdddd    Write 16 bit data 'dddd' into register 'rrrr'\r\n" );
	usbserialPrintf( "    Rrrrr        Read 16 bit data from register 'rrrr'\r\n" );
	usbserialPrintf( "    Register number (rrrr) is 16 bit, in hexadecimal format\r\n" );
	usbserialPrintf( "    Data (dddd) is 16 bit, in hexadecimal format\r\n" );
}

#define FMC_BASE_ADDR	( ( void * )0x60000000 )

void StartDefaultTask( void *argument ) {
	// Delay needed to allow for USB initialization
	led3( ON );
	osDelay( 100 );
	led3( OFF );
	usbserialPrintf( "\r\n" );
	usbserialPrintf( "*******************************\r\n" );
	usbserialPrintf( "*   VirtLAB FMC tester v1.0   *\r\n" );
	usbserialPrintf( "*******************************\r\n" );
	usbserialPrintf( "\r\n" );
	usbserialEchoOn();
	while( 1 ) {
		uint16_t regAddr;
		uint16_t regData;
		volatile uint16_t *fmcPtr = FMC_BASE_ADDR;
		// Read command from USB serial
		usbserialPrint( ">" );
		uint8_t ch = usbserialReadChar();
		switch( ch ) {
		case 'r':
		case 'R':
			regAddr = usbserialReadHexWord16();
			usbserialPrintf( "\r\nReading from register %04x: ", regAddr );
			regData = fmcPtr[regAddr];
			usbserialPrintf( "%04x\r\n", regData );
			break;
		case 'w':
		case 'W':
			regAddr = usbserialReadHexWord16();
			regData = usbserialReadHexWord16();
			usbserialPrintf( "\r\nWriting %04x to register %04x\r\n", regData, regAddr );
			fmcPtr[regAddr] = regData;
			break;
		case 'h':
		case 'H':
		case '?':
			usage();
			break;
		default:
			usbserialPrint( "\r\nSyntax error\r\n" );
			usage();
			break;
		}
	}
}

