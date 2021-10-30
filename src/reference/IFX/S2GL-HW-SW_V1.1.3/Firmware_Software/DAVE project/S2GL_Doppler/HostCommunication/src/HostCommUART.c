/**
    @file: HostCommUART.c

    @brief: This file implements the driver API for UART Communication
            for Sense2GoL radar board.

*/

/* ===========================================================================
** Copyright (C) 2017-2019 Infineon Technologies AG
** All rights reserved.
** ===========================================================================
**
** ===========================================================================
** This document contains proprietary information of Infineon Technologies AG.
** Passing on and copying of this document, and communication of its contents
** is not permitted without Infineon's prior written authorization.
** ===========================================================================
*/

/*
==============================================================================
   1. INCLUDE FILES
==============================================================================
 */

#include "HostCommUART.h"

/*
==============================================================================
   2. EXPORTED FUNCTIONS
==============================================================================
 */

void send_data(char *tx_buffer)
{
	uint32_t index = 0;

	while (tx_buffer[index] != 0)
	{
		UART_TransmitWord(&UART_0, tx_buffer[index]);
		index++;

		/* Wait for dump buffer interrupt to fill it again with remaining data */
		while ((UART_GetTXFIFOStatus(&UART_0) & XMC_USIC_CH_TXFIFO_EVENT_STANDARD) == 0);

		UART_ClearTXFIFOStatus(&UART_0, XMC_USIC_CH_TXFIFO_EVENT_STANDARD);
	}
}

//===========================================================================

void receive_data(uint8_t* receive_buffer, uint16_t nsample)
{
	uint8_t count = 0;

	/* Configure receive FIFO trigger limit to 1 */
	UART_SetRXFIFOTriggerLimit(&UART_0, nsample - 1);

	while (!(UART_GetRXFIFOStatus(&UART_0) & (XMC_USIC_CH_RXFIFO_EVENT_STANDARD | XMC_USIC_CH_RXFIFO_EVENT_ALTERNATE)))
	{
		receive_buffer[count] = UART_GetReceivedWord(&UART_0);
		count++;

		if (count == nsample)
			break;
	}
}

//===========================================================================

void dumpRawIQ_uint16(uint16_t *raw_adc_i, uint16_t *raw_adc_q, uint16_t nsamples)
{
	send_data("\n  ------------- I raw samples ------------- \n\r");
	dump_arr_uint16(raw_adc_i, nsamples);
	send_data("\n  ------------- Q raw samples ------------- \n\r");
	dump_arr_uint16(raw_adc_q, nsamples);
}

//===========================================================================

void dumpRawIQ_uint32(uint32_t *raw_adc_i, uint32_t *raw_adc_q, uint16_t nsamples)
{
	send_data("\n  ------------- I raw samples ------------- \n\r");
	dump_arr_uint32(raw_adc_i, nsamples);
	send_data("\n  ------------- Q raw samples ------------- \n\r");
	dump_arr_uint32(raw_adc_q, nsamples);
}

//===========================================================================

void dumpRawIQ_int16(int16_t *raw_adc_i, int16_t *raw_adc_q, uint16_t nsamples)
{
	send_data("\n  ------------- I raw samples ------------- \n\r");
	dump_arr_int16(raw_adc_i, nsamples);
	send_data("\n  ------------- Q raw samples ------------- \n\r");
	dump_arr_int16(raw_adc_q, nsamples);
}

//===========================================================================

void clear_screen()
{
	send_data("\033c");
}

//===========================================================================

void dump_val_uint16(uint16_t txdata)
{
	char char_value[5];

	send_data("\n\r");

	sprintf(char_value, "%" PRIu16 " ", txdata);

	send_data(char_value);
}

//===========================================================================

void dump_arr_uint16(uint16_t *txArray, uint16_t nsamples)
{
	uint16_t display_rows = ((nsamples - 1) / COL_LENGTH) + 1;

	char line_buffer[200];

	uint16_t i = 0, j = 0;

	for (i = 0; i < display_rows; i++)
	{
		for (j = 0; j < COL_LENGTH; j++)
		{
			sprintf(line_buffer, "%" PRIu16 " ", txArray[i * COL_LENGTH + j]);

			send_data(line_buffer);
		}
		send_data("\n\r");
	}
}

//===========================================================================

void dump_val_uint32(uint32_t txdata)
{
	char char_value[5];

	send_data("\n\r");

	sprintf(char_value, "%" PRIu32 " ", txdata);

	send_data(char_value);
}

//===========================================================================

void dump_arr_uint32(uint32_t *txArray, uint16_t nsamples)
{
	uint16_t display_rows = ((nsamples - 1) / COL_LENGTH) + 1;

	char line_buffer[200];

	uint16_t i = 0, j = 0;

	for (i = 0; i < display_rows; i++)
	{
		for (j = 0; j < COL_LENGTH; j++)
		{
			sprintf(line_buffer, "%" PRIu32 " ", txArray[i * COL_LENGTH + j]);

			send_data(line_buffer);
		}
		send_data("\n\r");
	}
}

//===========================================================================

void dump_val_int16(int16_t txdata)
{
	char char_value[5];

	send_data("\n\r");

	sprintf(char_value, "%" PRIi16 " ", txdata);

	send_data(char_value);
}

//===========================================================================

void dump_arr_int16(int16_t *txArray, uint16_t nsamples)
{
	uint16_t display_rows = ((nsamples - 1) / COL_LENGTH) + 1;

	char line_buffer[200];

	uint16_t i = 0, j = 0;

	for (i = 0; i < display_rows; i++)
	{
		for (j = 0; (j < COL_LENGTH) && (nsamples > 0); j++)
		{
			sprintf(line_buffer, "%" PRIi16 " ", txArray[i * COL_LENGTH + j]);
			nsamples--;

			send_data(line_buffer);
		}
		send_data("\n\r");
	}
}

//===========================================================================

void dump_val_float(float float_val)
{
	char char_value[20];

	sprintf(char_value, "%f ", float_val);

	send_data(char_value);
}

/* --- End of File -------------------------------------------------------- */
