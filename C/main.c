#include "header.h"

/************* DAQ ****************/

extern TaskHandle TaskAO;
extern TaskHandle TaskAI;
extern TaskHandle TaskDO;

/*-----------------------------------------------
		           Parameters
-------------------------------------------------*/

/************** Time *******************/
#define SAMPLINGTIME (double)(0.005) 
#define FINISHTIME   (double)(5) 
#define N_DATA          (int)( 200*FINISHTIME)
static double bufTime[N_DATA] = { 0 };

/*****************Idl*******************/
int count = 0;

double IntialTime = 0.0;
double DeltTime = 0.010;
double CurrentTime = 0.0;

/************* 모터 동작 *******************/
extern double Action = GO;

/*************array initial****************/
extern double buff[2] = { 0.0 };
double read[4] = { 0 };

double Time[N_DATA] = { 0 };
double Vcmd[N_DATA] = { 0 };
double Wcmd[N_DATA] = { 0 };
double Vss[N_DATA] = { 0 };

double GyrooutV[N_DATA] = { 0 };
double GyrooutW[N_DATA] = { 0 };
double DOA[N_DATA] = { 0 };
double DIR[N_DATA] = { 0.0 };
double Vpot[N_DATA] = { 0.0 };

double Input[N_DATA] = { 0.0 };

/********controller parameter**********/
static double errorW[N_DATA] = { 0.0 };
static double errorDeg[N_DATA] = { 0.0 };

static double Scmd[N_DATA] = { 0.0 };
static double Tcmd[N_DATA] = { 0.0 };

extern double PastInput = 0;
extern double PastKI = 0;
extern double PastKD = 0;
extern double PID = 0;

double cmd;
int key; 


	/*----------------------------------------------
					     	Main
	------------------------------------------------*/

void main()
{
	
		DAQmxCreateTask("", &TaskAO);
		DAQmxCreateTask("", &TaskAI);
		DAQmxCreateTask("", &TaskDO);

		CREATE_AI_CH(TaskAI, "Dev4/ai0");
		CREATE_AI_CH(TaskAI, "Dev4/ai1");
		CREATE_AI_CH(TaskAI, "Dev4/ai2");
		CREATE_AI_CH(TaskAI, "Dev4/ai3");
		CREATE_AO_CH(TaskAO, "Dev4/ao0");
		CREATE_DO_CH(TaskDO, "Dev4/port6");

		DAQmxStartTask(TaskAO);
		DAQmxStartTask(TaskAI);
		DAQmxStartTask(TaskDO);
		
		//MotorIntial();

		key = getch();

		if (key == 13) {

			Action = GO;
			WRITE_DO(TaskDO, Action);

			IntialTime = CheckwindowsTime() * 0.001;

			do
			{

				bufTime[count] = CheckwindowsTime() * 0.001;
				CurrentTime = CheckwindowsTime() * 0.001;
				Time[count] = CurrentTime - IntialTime;

				/*----------------------------------------------
								 Import_Data
				------------------------------------------------*/

				READ_AI(TaskAI, read)

				GyrooutV[count] = read[0];
				DOA[count] = read[1];
				DIR[count] = read[2];
				Vpot[count] = read[3];

				GyrooutW[count] = (GyrooutV[count] - GyroMean) * ConvertW;

				/*----------------------------------------------
									Process
				-----------------------------------------------*/


				/* Calculate error */
				errorDeg[count] = DOADIRDegree(DOA[count], DIR[count]);
				errorW[count] = -GyrooutW[count];

				/* Tracking Loop Commend */
				Tcmd[count] = Input[count] - errorDeg[count];

				/* Stabilization Commend (including KP Controller) */
				Scmd[count] = (Tcmd[count] * KP_T) + errorW[count];

				/* PID Controller +  단위변환 */
				Wcmd[count] = PIDcontroller(SAMPLINGTIME, Scmd[count], WC, KP, KI, KD);
				Vcmd[count] = Wcmd[count] / ConvertW;

				/* Linearization */
				Vss[count] = Linearization(Vcmd[count]);

				/* 모터 동작 정지 */
				if (Time[count] > FINISHTIME) {
					Vss[count] = MotorStop(Time[count], FINISHTIME);
				}

				/*----------------------------------------------
								 Export_Data
				------------------------------------------------*/

				WRITE_AO(TaskAO, Vss[count]);
				WRITE_DO(TaskDO, Action);

				/*----------------------------------------------
									 Idl Time
				------------------------------------------------*/

				buff[0] = CheckwindowsTime() * 0.001;
				DeltTime = CheckwindowsTime() * 0.001;
				IdleTime(DeltTime, CurrentTime);
	
				count++;

			} while (CurrentTime - IntialTime <= FINISHTIME);

			

			DAQmxStopTask(TaskAO);
			DAQmxStopTask(TaskAI);
			DAQmxStopTask(TaskDO);

			DAQmxClearTask(TaskAO);
			DAQmxClearTask(TaskAI);
			DAQmxClearTask(TaskDO);

			/*---------------------------------------------------
						solving the data(in PC)
			-----------------------------------------------------*/

			char Name[50] = "data";
			WriteTxtFile(Name, 0, N_DATA, Time, Vcmd, GyrooutW);
			
		}

			return 0;
		

}
#pragma once