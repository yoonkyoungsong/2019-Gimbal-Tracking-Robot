#ifndef SOURCE_USER_DEFINED_FUNCTION
#define SOURCE_USER_DEFINED_FUNCTION

//		

#include "Function.h"

//

double CheckwindowsTime(void)
{
	LARGE_INTEGER  liCount, liFreq;

	QueryPerformanceCounter(&liCount);
	QueryPerformanceFrequency(&liFreq);

	return((liCount.QuadPart / ((double)(liFreq.QuadPart))) * 1000.0);


};

#endif