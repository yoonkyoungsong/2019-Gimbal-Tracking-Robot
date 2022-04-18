#ifndef HEADER_USER_DEFINED_HEADER
#define HEADER_USER_DEFINED_HEADER

//


#include <stdio.h>
#include <stdlib.h>

#define _USE_MATH_DEFINES
#include <math.h>

#include <windows.h>
#include <time.h>
#include <string.h>

#include "Function.h"
#include "FunctionGenerator.h"
#include "DigitalControl.h"
#include "NIDAQmx.h"


/***************DAQ**************/

#define MAX_AI_VOLTAGE  (double)( 10.0) // NI6009
#define MIN_AI_VOLTAGE  (double)(-10.0) // NI6009
#define MAX_DI_VOLTAGE  (double)( 10.0) // NI6009

#define MAX_AO_VOLTAGE  (double)(  5.0) // NI6009
#define MIN_AO_VOLTAGE  (double)(  0.0) // NI6009
#define MAX_DO_VOLTAGE  (double)(  5.0) // NI6009

#define CREATE_AI_CH(Task, Chan)  DAQmxCreateAIVoltageChan(Task, Chan, "", DAQmx_Val_Diff, MIN_AI_VOLTAGE, MAX_AI_VOLTAGE, DAQmx_Val_Volts, NULL)   // creating an analog input channel
#define CREATE_AO_CH(Task, Chan)  DAQmxCreateAOVoltageChan(Task, Chan, "", MIN_AO_VOLTAGE, MAX_AO_VOLTAGE, DAQmx_Val_Volts, NULL)                     // creating an analog output channel
#define CREATE_DO_CH(Task, Chan) DAQmxCreateDOChan(Task, Chan, "", DAQmx_Val_ChanForAllLines);

#define READ_AI(Task,read) DAQmxReadAnalogF64(Task, -1, MAX_DO_VOLTAGE, DAQmx_Val_GroupByChannel, read, sizeof(float64) * 4, NULL, NULL); 

#define WRITE_AO(Task,Write) DAQmxWriteAnalogScalarF64(Task, "", MAX_AI_VOLTAGE, Write, NULL);  // 1번의 데이터값 출력
#define WRITE_DO(Task,Write) DAQmxWriteDigitalScalarU32(Task, "", MAX_DI_VOLTAGE , Write, NULL); //********* 전역변수

/************define Parameter *****************/


#define GO (double)(3) // sinusoid 기본조건
#define STOP (double)(2)
#define MotorStandard  (double)(2.5)
#define GyroMean  (double)(1.3616)
#define ConvertW (double)(1492.53731)

#define WC  (double)(28.4664) // cut-off frequency
#define KP  (double)(5.9122)
#define KI  (double)(124.1292)  
#define KD  (double)(0.1593)

#define KP_T (double)(10)

//
#endif

#pragma once
