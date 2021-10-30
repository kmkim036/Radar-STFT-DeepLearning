/**
    @file: config.h

    @brief: Configuration file for Sense2GoL project.
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

#ifndef CONFIG_H_
#define CONFIG_H_

/* Enable C linkage if header is included in C++ files */
#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
==============================================================================
   1. DEFINITIONS
==============================================================================
*/

#define DOPPLER_SAMPLING_FREQ_HZ    (3000) 	/**< Sampling frequency in Hz.
									             PLEASE CHANGE ACCORDING TO
									             YOUR REQUIREMENTS!!! */

#define DETECTION_THRESHOLD         (20000000) 	/**< Threshold of FFT magnitude.
 	 	 	 	 	 	 	 	 	             All magnitudes below this
 	 	 	 	 	 	 	 	 	             value will be ignored.
 	 	 	 	 	 	 	 	 	             PLEASE CHANGE ACCORDING TO
 	 	 	 	 	 	 	 	 	             YOUR REQUIREMENTS!!! */

#define DOPPLER_FFT_SIZE            (128)   /**< FFT length for Doppler mode */

#define UART_RAW_DATA               (1) 	/**< Control for execution of UART
                                                 feature to transmit raw IQ
									             from ADC. BE CAREFUL: WHEN
									             SENDING RAW DATA VIA UART
									             INTERFACE GUI WILL BE VERY
									             SLOW AND NOT USABLE.
									             TURN OFF WHEN USING GUI */

#define MINIMUM_SPEED_KMH           (0.5) 	/**< Minimum velocity to detect
                                                 motion (units in km/h) */

#define MAXIMUM_SPEED_KMH           (20) 	/**< Minimum velocity to detect
                                                 motion (units in km/h) */

/* --- Close open blocks -------------------------------------------------- */

/* Disable C linkage for C++ files */
#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

#endif /* CONFIG_H_ */

/* --- End of File -------------------------------------------------------- */

