#include<iostream>
#include <cuda.h>
#include <random>
#include "stencil.cuh"


int main(int argc, char** argv) {

	cudaEvent_t startEvent, stopEvent;
	cudaEventCreate(&startEvent);
	cudaEventCreate(&stopEvent);

	srand( (unsigned)time( NULL ) );

	unsigned int n = atoi(argv[1]);
	unsigned int R = atoi(argv[2]); 
	unsigned int thread = atoi(argv[3]);

	float* image;
	float* mask;
	float* output;

	cudaMallocManaged(& image, n * sizeof(float));
	cudaMallocManaged(& mask, (2*R+1) * sizeof(float));
	cudaMallocManaged(& output, n * sizeof(float));

	
	for (unsigned int i = 0; i <n; i++)
	{
		image[i] =(float) rand()/RAND_MAX;		
	}
	
	for(unsigned int j = 0;j <(2*R+1);j++)
	{
		mask[j] = (float) rand()/RAND_MAX;
	}

	
	cudaEventRecord(startEvent, 0);
	
	stencil(image, mask, output, n, R,thread);
	
	cudaEventRecord(stopEvent, 0);

	cudaEventSynchronize(stopEvent);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
	
	// print results 
	
	std::printf("%f \n", output[n -1]);
	std::printf("%f \n", elapsedTime);
	
	// Cleanup

	cudaFree(image);
	cudaFree(mask);
	cudaFree(output);
	cudaEventDestroy(startEvent);
	cudaEventDestroy(stopEvent);
	return 0;
}