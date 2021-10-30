/**
    @file: s2gl_library.h

    @brief: Header file for Sense2GoL Library.
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

#ifndef S2GL_LIBRARY_H_
#define S2GL_LIBRARY_H_

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

/*
==============================================================================
   2. TYPES
==============================================================================
 */

typedef enum {
	XMC_RADARSENSE2GOL_DISABLED = 0,
	XMC_RADARSENSE2GOL_ENABLED = 1
} XMC_RADARSENSE2GOL_ENABLE_t;

typedef enum {
	XMC_RADARSENSE2GOL_OK = 0,
	XMC_RADARSENSE2GOL_NOT_INITIALIZED = 1
} XMC_RADARSENSE2GOL_ERROR_t;

typedef enum {
	XMC_MOTION_DETECT_APPROACHING = 0,
	XMC_MOTION_DETECT_DEPARTING = 1,
	XMC_NO_MOTION_DETECT = 2
} XMC_RADARSENSE2GOL_MOTION_t;

typedef struct {
	uint32_t t_sample_us;
	uint32_t t_cycle_ms;
	uint8_t N_exponent_samples;
} XMC_RADARSENSE2GOL_TIMING_t;

typedef struct {
	uint8_t  hold_on_cycles;
	uint32_t trigger_det_level;
	XMC_RADARSENSE2GOL_ENABLE_t rootcalc_enable;
} XMC_RADARSENSE2GOL_ALG_t;

typedef struct {
	XMC_RADARSENSE2GOL_ENABLE_t sleep_deepsleep_enable;
	XMC_RADARSENSE2GOL_ENABLE_t mainexec_enable;
	XMC_RADARSENSE2GOL_ENABLE_t vadc_clock_gating_enable;
} XMC_RADARSENSE2GOL_POWERDOWN_t;

typedef void (*radarsense2gol_result_cb_t)(uint32_t *fft_magnitude_array,
                                          uint16_t size_of_array_mag,
										  int16_t *adc_array_I,
										  int16_t *adc_array_Q,
										  uint16_t size_of_array_adc,
										  XMC_RADARSENSE2GOL_MOTION_t motion_detected,
										  uint32_t max_frq_mag,
										  uint32_t max_frq_index);
typedef void (*radarsense2gol_startacq_cb_t)(void);
typedef void (*radarsense2gol_endacq_cb_t)(void);
typedef void (*radarsense2gol_trigger_cb_t)(XMC_RADARSENSE2GOL_MOTION_t detection_state);

/*
==============================================================================
   3. FUNCTION PROTOTYPES
==============================================================================
 */

void radarsense2gol_init(XMC_RADARSENSE2GOL_TIMING_t    init_timing,
						 XMC_RADARSENSE2GOL_ALG_t       init_algorithm,
						 XMC_RADARSENSE2GOL_POWERDOWN_t init_powerdown,
						 TIMER_t *timer);

XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_start(void);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_stop(void);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_set_detection_threshold(uint32_t threshold);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_exitmain(void);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_regcb_result(radarsense2gol_result_cb_t fctptr);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_regcb_startacq(radarsense2gol_startacq_cb_t fctptr);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_regcb_endacq(radarsense2gol_endacq_cb_t fctptr);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_regcb_trigger(radarsense2gol_trigger_cb_t fctptr);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_set50HzFilter(bool filter);
XMC_RADARSENSE2GOL_ERROR_t radarsense2gol_set100HzFilter(bool filter);

/* --- Close open blocks -------------------------------------------------- */

/* Disable C linkage for C++ files */
#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

#endif /* S2GL_LIBRARY_H_ */

/* --- End of File -------------------------------------------------------- */
