#include<iostream>
#include <cuda.h>
#include "matmul.cuh"

int main(int argc, char** argv) {

	cudaEvent_t startEvent, stopEvent;
	cudaEventCreate(&startEvent);
	cudaEventCreate(&stopEvent);

	unsigned int n = atoi(argv[1]);
	unsigned int block_dim = atoi(argv[2]);

	float* A;
	float* B;
	float* C;

	cudaMallocManaged(& A, n * n * sizeof(float));
	cudaMallocManaged(& B, n * n * sizeof(float));
	cudaMallocManaged(& C, n * n * sizeof(float));


	for (unsigned int i = 0; i < n * n; i++)
	{
		A[i] = 1.0;
		B[i] = 1.0;
	}

	cudaEventRecord(startEvent, 0);
	
	matmul(A, B, C, n, block_dim);
	
	
	cudaEventRecord(stopEvent, 0);

	cudaEventSynchronize(stopEvent);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);

	std::printf("%f \n", C[0]);
	std::printf("%f \n", C[n * n - 1]);
	std::printf("%f \n", elapsedTime);
	
	
	// Cleanup

	cudaFree(A);
	cudaFree(B);
	cudaFree(C);
	cudaEventDestroy(startEvent);
	cudaEventDestroy(stopEvent);
	return 0;
}