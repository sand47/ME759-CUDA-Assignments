#include<iostream>
#include <cuda.h>

__global__ void vadd(const float* a, float* b, unsigned int n) {
	
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < n) {
		b[i] = a[i] + b[i];
	}
}
