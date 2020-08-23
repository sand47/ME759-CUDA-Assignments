#include<iostream>
#include <cuda.h>

#define N 16

__global__ void sumThredBlk(int* dA) {
	int index = threadIdx.x + blockIdx.x * blockDim.x;
	dA[index] = threadIdx.x + blockIdx.x;
}

int main(void) {

	int* hA;  // host copies of a 
	int* dA; // device copies of a 
	int size = N * sizeof(int);

	// Alloc space for device copies for dA
	cudaMalloc((void**)& dA, size);

	// Alloc space for host copies of a
	hA = (int*)malloc(size); 

	// Copy inputs to device
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);

	// Launch sumThredBlk() kernel on GPU with 2 blocks and 8 threads
	sumThredBlk<<<2,8>>>(dA);
	cudaDeviceSynchronize();

	// Copy result back to host
	cudaMemcpy(hA, dA, size, cudaMemcpyDeviceToHost);

	// prints the dA array
	
	for (int i = 0; i < N; i++)
	{
		std::printf("%d ", hA[i]);

	}
	
	// Cleanup
	free(hA);
	cudaFree(dA);
	return 0;
}