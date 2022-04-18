#ifndef HEADER_USER_DEFINED_DCMS
#define HEADER_USER_DEFINED_DCMS

	/***************** 헤더파일 불러오기 *******************/

	#include "header.h"

	/********************idle time 함수***********************/
	
	/* Parameter */
	double buff[2];
	#define SAMPLINGTIME (double)(0.005) 

	/* Fumction */
	void IdleTime(double DeltTime, double CurrentTime) {

		double S = 0;

		if (DeltTime - CurrentTime < SAMPLINGTIME)
		{
			while (1)
			{
				buff[1] = CheckwindowsTime() * 0.001;

				S += buff[1] - buff[0];
				double  sub = (DeltTime - CurrentTime) + S;

				if (sub >= SAMPLINGTIME)
				{
					break;
				}

				buff[0] = buff[1];

			}
		}
	}


	/***************모터 동작 정지*******************/
	
	/* Parameter */
	double Action;
	double Vss;

	/* Fumction */
	double MotorStop(double Time, double FINISHTIME) {

			Vss = 2.5;
			Action = STOP;
		
			return Vss;
	}

	/************ 모터 초기 위치 설정 함수 ****************/

	/* Parameter */

	double read[4];
	double cmd;
	TaskHandle TaskAO;
	TaskHandle TaskAI;
	TaskHandle TaskDO;

	/* Fumction */
	void MotorIntial(void) {
		//Gimbal 가운데 맞춤
		do {
			
			READ_AI(TaskAI, read)
				if (read[3] < 2.5) {
					cmd = 3;
					WRITE_AO(TaskAO, cmd);
					Sleep(10);
				}
				else if (read[3] > 2.5) {
					cmd = 2;
					WRITE_AO(TaskAO, cmd);
					Sleep(10);
				}
		} while (read[3] > 2.51 || read[3] < 2.49);

		printf("Initial Voltage = %f \n\n", read[3]);


		Action = STOP;
		WRITE_AO(TaskAO, 2.5);
		WRITE_DO(TaskDO, Action);
		printf("Ready to Start \n");
		printf("If you wnat to start, press the enterkey \n");
	
	}


	/**************** 선형화 함수  ********************/

	/* Parameter */
	#define CWVdead  (double)(2.785)
	#define CWVmax  (double)(3.385)
	#define CCWVdead  (double)(2.295)
	#define CCWVmax  (double)(1.785)

	#define CWA  (double)(0.2064)
	#define CWB  (double)(2.7727-0.245)
	#define CCWA  (double)( 0.2064)
	#define CCWB  (double)(2.2503+0.261)

	/* Fumction */
	double Linearization(double Vcmd) {

		double Vss = 0;

		if (Vcmd < -2.5) {
			Vss = CCWVmax;
		}
		else if (Vcmd < -0.05) {
			Vss = CCWA * Vcmd + CCWB;
		}
		else if (Vcmd >= -0.05 && Vcmd < 0.05) {
			Vss = 2.5;
		}
		else if (Vcmd >= 0.05 ) {
			Vss = CWA * Vcmd+ CWB;
		}
		else if ( Vcmd >= 2.5) {
			Vss = CWVmax;
		}

		return Vss;
	}


	/**************** PID Controllor ********************/

	/* Parameter */
	double PastKI;
	double PastKD;
	double PID;
	double PastInput;

	/* Fumction */
	double PIDcontroller(double SamplingTime, double input, double Wc, double Kp, double Ki, double Kd)
	{
		double P = 0;
		double I = 0;
		double D = 0;

		double PresentInput = input;

		P = Kp * PresentInput;
		I = PastKI  + Ki * SamplingTime / 2 * PresentInput + Ki*SamplingTime / 2 * PastInput ;
		D = ((5 * SamplingTime * Wc + 1)* PastKD+10*Kd*Wc* PresentInput- 10 * Kd * Wc* PastInput) / (5 * SamplingTime * Wc + 1);

		PastKI = I;
		PastKD = D;
		PastInput = PresentInput;

		PID = P + I + D;

		return PID;
	}

	/************** Motor Keybord Interection ****************/

	/* Parameter */
	int key;
	double out;

	/* Fumction */
	double GimbalAngleControl(double deg) {

		out = 0;

		key = getch();

		if (key == 224) {

			key = getch();
			Action = GO;

			if (key == 75) {
				out = -1;
			}
			else if (key == 77) {
				out = 1;
			}
		}
		key = 0;

		return out;
	}

	/*********** DOA Linerization **************/

	/* Fumction */
	double DOADIRDegree(double DOA, double DIR) {

		double degree = 0;
		double direction = 0;

		if (DIR < 2.5) {
			direction = -1;
		}
		else if(DIR >= 2.5) {
			direction = 1;
		}
		
		DOA = DOA * direction;

		if (DOA < -1.7707) {
			degree =-9.2208;
		}
		else if (DOA >= -1.7707 && DOA < -0.23964) {
			degree = 7.5952 * DOA - 1.3273;
		}
		else if (DOA >= -0.23964 && DOA < 0.17475) {
			degree = 0;
		}
		else if (DOA >= 0.17475 && DOA < 1.5869) {
			degree = 7.3543 * DOA + 1.7425;
		}
		else if (DOA >= 1.5869) {
			degree = 10.8164;
		}

		return degree;
		}


	/************* 텍스트파일 저장하기 ***************/

	/* Fumction */
	void WriteTxtFile(char Name[], int k,  double N_DATA, double data1[]  , double data2[], double data3[]) {
		
		FILE* pF1;  //task 시작 시간 data  // header 파일 만들기 

		char s1[20];
		sprintf(s1, "%d", k);
		char s2[20] = ".txt";
		//char way[1000] = "C:\\Users\\xde12\\OneDrive\\바탕 화면\\";

		strcat(Name, s1);
		strcat(Name, s2);


		pF1 = fopen(Name, "w");

		for (int count = 0; count < N_DATA; count++)
		{
			fprintf(pF1, "%f %f %f \n",data1[count], data2[count], data3[count]);
		}

		fclose(pF1);

		printf("Storage data file");
	}



#endif