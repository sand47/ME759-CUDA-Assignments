#include<iostream>
#include <cuda.h>
#include "vadd.cuh"


void random_ints(float* a, int m)
{
	int i;
	for (i = 0; i < m; ++i)
		a[i] = 1.0;
}

int main(int argc, char** argv) {

	cudaEvent_t startEvent, stopEvent;
	cudaEventCreate(&startEvent);
	cudaEventCreate(&stopEvent);

	const int n = atoi(argv[1]);

	float* a; // host copies of a 
	float* b; // host copies of b
	float* dA; // device copies of a 
	float* dB; // device copies of B

	float size = n * sizeof(float);
	int blocksize = 1;
	
	a = (float*)malloc(size); 
	random_ints(a, n);
	b = (float*)malloc(size); 
	random_ints(b, n);

	cudaMalloc((void**)& dA, size);
	cudaMalloc((void**)& dB, size);
	
	// Copy inputs to device
	
	cudaMemcpy(dA, a, size , cudaMemcpyHostToDevice);
	cudaMemcpy(dB, b, size , cudaMemcpyHostToDevice);

	blocksize = (n +1023)/ 1024;
	
	// Launch add() kernel on GPU with N blocks
	cudaEventRecord(startEvent, 0);
	
	vadd<<<blocksize,1024>>>(dA,dB,n);

	cudaDeviceSynchronize();
	cudaEventRecord(stopEvent, 0);

	cudaEventSynchronize(stopEvent);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
	
	// Copy result back to host
	cudaMemcpy(b, dB, size , cudaMemcpyDeviceToHost);
		
	// print time in seconds
		
	std::printf("%f \n",elapsedTime/1000);

	// prints the b array first and last index
	std::printf("%f \n",b[0]);
	std::printf("%f \n",b[n - 1]);
		
	// Cleanup

	cudaEventDestroy(startEvent);
	cudaEventDestroy(stopEvent);
	free(a);
	free(b);
	cudaFree(dA);
	cudaFree(dB);
	return 0;
}