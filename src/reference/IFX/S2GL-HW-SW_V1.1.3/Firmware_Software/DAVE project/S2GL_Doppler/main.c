/**
    @file: main.c

    @brief: This file implements the top-level functionality for the motion
            detection on Sense2GoL radar board.
            UART feature is also used in this implementation to dump IQ raw
            data samples to the HOST.
            - UART Configurations:
              Full-duplex, Direct mode, 9600 baud rate, 8 data-bits,
              1 stop-bit, no parity.

            - Data format of transmission:
              Completely transmits I_adc samples of buffer length BUFF_SIZE,
              followed by Q_adc samples of same buffer length of BUFF_SIZE so
              in total 2 * BUFF_SIZE samples are transmitted.
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

#include "Dave.h"
#include "s2gl_library.h"
#include "HostCommUART.h"
#include "config.h"

/*
==============================================================================
   2. DEFINITIONS
==============================================================================
 */

#define BUFF_SIZE    (DOPPLER_FFT_SIZE)		/**< I and Q raw samples buffer size */

#define FFT_BIN_SIZE ((float)DOPPLER_SAMPLING_FREQ_HZ / DOPPLER_FFT_SIZE) /**< Size of each FFT bin. DO NOT CHANGE!!! */

/*
==============================================================================
   3. DATA
==============================================================================
 */

/************************* Micirum uC Probe variables ***********************/

uint16_t g_sampling_data_I[BUFF_SIZE] = {0};				 /**< Raw data I channel */
uint16_t g_sampling_data_Q[BUFF_SIZE] = {0};				 /**< Raw data Q channel */
uint32_t g_fft_data[DOPPLER_FFT_SIZE/2] = {0};				 /**< FFT data of I channel */
XMC_RADARSENSE2GOL_MOTION_t g_motion = XMC_NO_MOTION_DETECT; /**< Motion indicator */
float g_doppler_frequency = 0.0;							 /**< Doppler frequency */
float g_doppler_velocity = 0.0;								 /**< Doppler speed */
float g_min_velocity = MINIMUM_SPEED_KMH; 				     /**< Min velocity to detect motion */
float g_max_velocity = MAXIMUM_SPEED_KMH; 				     /**< Max velocity to detect motion */
bool g_start = true;										 /**< Control for execution of Doppler algorithm */
bool g_uart_start = UART_RAW_DATA;							 /**< Control for execution of UART feature to transmit raw I&Q from ADC */

/**
 * \brief Setup the timings related parameters
 */
XMC_RADARSENSE2GOL_TIMING_t radarsense2gol_timing =
{
		.t_sample_us = (1.0 / DOPPLER_SAMPLING_FREQ_HZ) * 1000.0 * 1000.0, /**< Sample time, units in microseconds (usec) */
		.t_cycle_ms = 300,                                                 /**< 300 msec */
		.N_exponent_samples = log2(BUFF_SIZE)
};

/**
 * \brief Setup the detection triggers related parameters
 */
XMC_RADARSENSE2GOL_ALG_t radarsense2gol_algorithm =
{
		.hold_on_cycles = 1,                           /**< Hold-on cycles to trigger detection */
		.trigger_det_level = DETECTION_THRESHOLD,      /**< Trigger detection level */
		.rootcalc_enable = XMC_RADARSENSE2GOL_DISABLED /**< Root calculation for magnitude disabled */
};

/**
 * \brief Setup the power management related parameters
 */
XMC_RADARSENSE2GOL_POWERDOWN_t radarsense2gol_powerdown =
{
		.sleep_deepsleep_enable   = XMC_RADARSENSE2GOL_ENABLED, /**< Sleep / Deep-sleep enabled */
		.mainexec_enable          = XMC_RADARSENSE2GOL_ENABLED, /**< Main execution enabled     */
		.vadc_clock_gating_enable = XMC_RADARSENSE2GOL_ENABLED  /**< VADC clock gating enabled  */
};

/*
==============================================================================
  4. LOCAL FUNCTIONS
==============================================================================
 */

/**
 * \brief max_frq_index gives the FFT bin in which the maximum magnitude of
 *        the FFT was found, each FFT bin has a size and therefore corresponds
 *        to a frequency range. The size of the FFT bin is calculated by
 *        dividing the sampling frequency by the number of FFT points.
 *        The Doppler frequency is calculated by multiplying the FFT bin size
 *        with the number of the FFT bin where the maximum was found.
 */
static float calcDopplerFrequency(const uint32_t max_frq_index)
{
	return (float)(max_frq_index * FFT_BIN_SIZE);
}

//===========================================================================

/**
 * \brief Doppler velocity is calculated based on the Doppler frequency for
 *        24GHz Doppler radar systems. A velocity of 1Km/h will correspond to
 *        a Doppler frequency of 44.4Hz
 */
static float calcDopplerSpeed(const float doppler_freq)
{
	return doppler_freq / 44.4f;
}

/*
==============================================================================
   5. USER CALLBACK FUNCTIONS
==============================================================================
 */

/**
 * \brief Callback executed after new data is available from algorithm.
 *
 * \param[in]  *fft_magnitude_array  Array pointer to the FFT spectrum
 * \param[in]  size_of_array_mag     Length of array for the FFT spectrum
 * \param[in]  *adc_aqc_array_I      Array pointer for the raw ADC I data samples
 * \param[in]  *adc_aqc_array_Q      Array pointer for the raw ADC Q data samples
 * \param[in]  size_of_array_acq     Length of array for the raw ADC I&Q data samples
 * \param[out] motion                Approaching, departing or no motion information
 * \param[out] max_frq_mag           Maximum Doppler frequency computed
 * \param[out] max_frq_index         Maximum frequency bin index above threshold
 *
 */
void radarsense2gol_result(uint32_t *fft_magnitude_array,
		                   uint16_t size_of_array_mag,
		                   int16_t *adc_aqc_array_I,
		                   int16_t *adc_aqc_array_Q,
		                   uint16_t size_of_array_acq,
		                   XMC_RADARSENSE2GOL_MOTION_t motion,
		                   uint32_t max_frq_mag,
		                   uint32_t max_frq_index)
{
	/* Copy raw data and FFT data and motion indicator to global variables used in Micrium GUI */
	memcpy(g_sampling_data_I, adc_aqc_array_I, size_of_array_acq * sizeof(uint16_t));
	memcpy(g_sampling_data_Q, adc_aqc_array_Q, size_of_array_acq * sizeof(uint16_t));
	memcpy(g_fft_data, &fft_magnitude_array[1], (size_of_array_mag - 1) * sizeof(uint32_t));

	/* To remove the spike from last bins in FFT spectrum, force last two bins to 0 */
	g_fft_data[size_of_array_mag-1] = 0;
	g_fft_data[size_of_array_mag-2] = 0;

	fft_magnitude_array[size_of_array_mag-1] = 0;
	fft_magnitude_array[size_of_array_mag-2] = 0;

	/* Calculate Doppler frequency and velocity */
	float doppler_frequency = calcDopplerFrequency(max_frq_index);
	float doppler_velocity  = calcDopplerSpeed(doppler_frequency);

	if (g_uart_start)
		dumpRawIQ_uint16(g_sampling_data_I, g_sampling_data_Q, (uint16_t)BUFF_SIZE);

	/* Check results */
	if (motion != XMC_NO_MOTION_DETECT &&		// Motion detected
	    doppler_velocity > g_min_velocity &&	// Doppler velocity is greater than min velocity
		doppler_velocity < g_max_velocity)	    // Doppler velocity is less than max velocity
	{
		if (motion == XMC_MOTION_DETECT_APPROACHING) // target is approaching radar sensor
		{
			/* Turn on red LED, turn off orange and blue LEDs */
			DIGITAL_IO_SetOutputLow(&LED_RED);
			DIGITAL_IO_SetOutputHigh(&LED_ORANGE);
			DIGITAL_IO_SetOutputHigh(&LED_BLUE);
		}
		else // motion == XMC_MOTION_DETECT_DEPARTING => target is moving away from radar sensor
		{
			/* Turn on orange LED, turn off red and blue LEDs */
			DIGITAL_IO_SetOutputLow(&LED_ORANGE);
			DIGITAL_IO_SetOutputHigh(&LED_RED);
			DIGITAL_IO_SetOutputHigh(&LED_BLUE);
		}
		g_motion = motion;
		g_doppler_frequency = doppler_frequency;
		g_doppler_velocity = doppler_velocity;

	}
	else // No motion detected
	{
		/* Turn on blue LED, turn off orange and red LEDs */
		DIGITAL_IO_SetOutputLow(&LED_BLUE);
		DIGITAL_IO_SetOutputHigh(&LED_ORANGE);
		DIGITAL_IO_SetOutputHigh(&LED_RED);

		/* Set velocity and frequency to 0 in case of no motion */
		g_doppler_frequency = 0.0;
		g_doppler_velocity = 0.0;
		g_motion = XMC_NO_MOTION_DETECT;
	}
}

/*
==============================================================================
   6. MAIN METHOD
==============================================================================
 */

int main(void)
{
	bool running = false;

	/* Initialize DAVE APPs */
	DAVE_Init();

	/* Turn off all LEDs */
	DIGITAL_IO_SetOutputHigh(&LED_ORANGE);
	DIGITAL_IO_SetOutputHigh(&LED_RED);
	DIGITAL_IO_SetOutputHigh(&LED_BLUE);

	/* Turn on BGT */
	DIGITAL_IO_SetOutputLow(&BGT24);

	radarsense2gol_init(radarsense2gol_timing,
			            radarsense2gol_algorithm,
			            radarsense2gol_powerdown,
			            &TIMER_0);

	/* Register callback */
	radarsense2gol_regcb_result(radarsense2gol_result);

	/* Infinite loop */
	while(1U)
	{
		if (running == false)
		{
			if (g_start == true)
			{
				running = true;
				radarsense2gol_start();
			}
		}
		else
		{
			if (g_start == false)
			{
				running = false;
				radarsense2gol_stop();
			}

			radarsense2gol_set_detection_threshold(radarsense2gol_algorithm.trigger_det_level);

			/* Only need to be called if mainexec_enable is enabled during initialization */
			radarsense2gol_exitmain();
		}
	}
}

/* --- End of File -------------------------------------------------------- */
