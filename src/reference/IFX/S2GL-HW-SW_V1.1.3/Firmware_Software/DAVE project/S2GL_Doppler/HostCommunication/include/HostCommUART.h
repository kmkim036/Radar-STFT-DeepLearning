/**
    @file: HostCommUART.h

    @brief: This file defines the driver API for UART Communication
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

#ifndef HOSTCOMMUART_H_
#define HOSTCOMMUART_H_

/* Enable C linkage if header is included in C++ files */
#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
==============================================================================
   1. INCLUDE FILES
==============================================================================
 */

#include "DAVE.h"  // Declarations from DAVE Code Generation (includes SFR declaration)
#include <stdio.h>
#include <math.h>
#include <inttypes.h>

/*
==============================================================================
   2. DEFINITIONS
==============================================================================
 */

#define COL_LENGTH       (16U) /**< Number of columns to be displayed per row
                                    in the Host terminal */

/*
==============================================================================
   3. FUNCTION PROTOTYPES
==============================================================================
 */

/**
 * \brief Transmits a complete string (IQ data samples are converted to
 *        character type (1-byte) for UART transmission).
 *
 * A string passed as an argument is actually type-casted character array of
 * the IQ raw data samples.
 * Length of the string is determined by the position of NULL character at
 * the end of string.
 *
 * \param[in] dump_buffer         A pointer to a character array.
 *
 */
void send_data(char *dump_buffer);

/**
 * \brief Receives 'N' number of samples provided as the second argument
 *        (nsample) and place them in the provided uint8_t receive_buffer pointer.
 *
 * \param[in]  nsample         Number of bytes to be received from HOST.
 * \param[out] receive_buffer  A pointer to the received buffer of type uint8_t.
 *
 */
void receive_data(uint8_t* receive_buffer, uint16_t nsample);

/**
 * \brief Clear the screen of the HOST's terminal connected via UART.
 *
 * \param[in]  None
 *
 * \return None
 */
void clear_screen();

/**
 * \brief Transmits 'N' number of IQ raw data samples (16-bit signed integer)
 *        from ADC to HOST via UART.
 *
 * \param[in] raw_adc_i  A pointer to the int16 type I ADC data array.
 * \param[in] raw_adc_q  A pointer to the int16 type Q ADC data array.
 * \param[in] nsamples   Number of 16-bit integer IQ samples to be transmitted
 *                       via UART to the HOST.
 */
void dumpRawIQ_int16 (int16_t  *raw_adc_i, int16_t  *raw_adc_q, uint16_t nsamples);

/**
 * \brief Transmits 'N' number of IQ raw data samples (16-bit unsigned integer)
 *        from ADC to HOST via UART.
 *
 * \param[in] raw_adc_i  A pointer to the int16 type I ADC data array.
 * \param[in] raw_adc_q  A pointer to the int16 type Q ADC data array.
 * \param[in] nsamples   Number of 16-bit integer IQ samples to be transmitted
 *                       via UART to the HOST.
 */
void dumpRawIQ_uint16(uint16_t *raw_adc_i, uint16_t *raw_adc_q, uint16_t nsamples);

/**
 * \brief Transmits 'N' number of IQ raw data samples (32-bit unsigned integer)
 *        from ADC to HOST via UART.
 *
 * \param[in] raw_adc_i  A pointer to the int16 type I ADC data array.
 * \param[in] raw_adc_q  A pointer to the int16 type Q ADC data array.
 * \param[in] nsamples   Number of 16-bit integer IQ samples to be transmitted
 *                       via UART to the HOST.
 */
void dumpRawIQ_uint32(uint32_t *raw_adc_i, uint32_t *raw_adc_q, uint16_t nsamples);

/**
 * \brief Transmits a single sample of type 16-bit signed integer
 *        from MCU to HOST via UART.
 *
 * \param[in] txdata  16-bit signed integer sample to be transmitted
 *                    via UART to the HOST.
 */
void dump_val_int16 (int16_t txdata);

/**
 * \brief Transmits 'N' number of data samples of type 16-bit signed integer
 *        from ADC to HOST via UART.
 *
 * \param[in] txArray   16-bit signed integer sample to be transmitted
 *                      via UART to the HOST.
 * \param[in] nsamples  Number of 16-bit signed integer data samples to be transmitted
 *                      via UART to the HOST.
 */
void dump_arr_int16 (int16_t  *txArray, uint16_t nsamples);

/**
 * \brief Transmits a single sample of type 16-bit unsigned integer
 *        from MCU to HOST via UART.
 *
 * \param[in] txdata  16-bit unsigned integer sample to be transmitted
 *                    via UART to the HOST.
 */
void dump_val_uint16(uint16_t txdata);

/**
 * \brief Transmits 'N' number of data samples of type 16-bit unsigned integer
 *        from ADC to HOST via UART.
 *
 * \param[in] txArray   16-bit unsigned integer sample to be transmitted
 *                      via UART to the HOST.
 * \param[in] nsamples  Number of 16-bit unsigned integer data samples to be transmitted
 *                      via UART to the HOST.
 */
void dump_arr_uint16(uint16_t *txArray, uint16_t nsamples);

/**
 * \brief Transmits a single sample of type 32-bit unsigned integer
 *        from MCU to HOST via UART.
 *
 * \param[in] txdata  32-bit unsigned integer sample to be transmitted
 *                    via UART to the HOST.
 */
void dump_val_uint32(uint32_t txdata);

/**
 * \brief Transmits 'N' number of data samples of type 32-bit unsigned integer
 *        from ADC to HOST via UART.
 *
 * \param[in] txArray   32-bit unsigned integer sample to be transmitted
 *                      via UART to the HOST.
 * \param[in] nsamples  Number of 32-bit unsigned integer data samples to be transmitted
 *                      via UART to the HOST.
 */
void dump_arr_uint32(uint32_t *txArray, uint16_t nsamples);

/**
 * \brief Transmits a single sample of type float from MCU to HOST via UART.
 *
 * \param[in] float_val  Floating point sample to be transmitted
 *                       via UART to the HOST.
 */
void dump_val_float(float float_val);

/* --- Close open blocks -------------------------------------------------- */

/* Disable C linkage for C++ files */
#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

#endif /* HOSTCOMMUART_H_ */

/* --- End of File -------------------------------------------------------- */
