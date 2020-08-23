#include<iostream>
#include <cuda.h>
#include "reduce.cuh"

int main(int argc, char** argv) {

	cudaEvent_t startEvent, stopEvent;
	cudaEventCreate(&startEvent);
	cudaEventCreate(&stopEvent);
	
	unsigned int n = atoi(argv[1]);
	unsigned int thread_per_block = atoi(argv[2]);
	
	int* A = new int[n];
	int sum;

	for (unsigned int i = 0; i < n; i++)
	{
		A[i] = 1;
	}

	cudaEventRecord(startEvent, 0);
	
	sum = reduce(A,n,thread_per_block);
	
	cudaEventRecord(stopEvent, 0);

	cudaEventSynchronize(stopEvent);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);

	std::printf("%d \n", sum);
	std::printf("%f \n", elapsedTime);

	// Cleanup

	delete[] A;
	cudaEventDestroy(startEvent);
	cudaEventDestroy(stopEvent);
	return 0;

}