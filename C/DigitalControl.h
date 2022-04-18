#ifndef HEADER_USER_DEFINED_DCMS
#define HEADER_USER_DEFINED_DCMS

		/************************************/

	#include "header.h"


		/************************************/
		/************************************/

	void IdleTime(double DeltTime, double CurrentTime);

	double MotorStop(double Time, double FINISHTIME);

	void MotorIntial(void);

	void WriteTxtFile(char Name[], int k, double N_DATA, double data1[], double data2[], double data3[]);

	double Linearization(double Vcmd);

	double PIDcontroller(double SamplingTime, double input, double Wc, double Kp, double Ki, double Kd);

	double GimbalAngleControl(double deg);

	double DOADIRDegree(double DOA, double DIR);


#endif


#pragma once

