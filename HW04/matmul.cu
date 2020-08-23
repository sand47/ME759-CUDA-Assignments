#include<iostream>
#include <cuda.h>


__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n)
{
	
	size_t col = blockIdx.x * blockDim.x + threadIdx.x;
	size_t row =0;
	if (col < n*n) {
		
		row = col / n;
		col = col % n;
	
		for (size_t i = 0; i < n; i++) {
			C[row * n + col] += A[row * n + i] * B[i * n + col];
		}
	}

}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block)

{

	size_t blocksize = (n*n + threads_per_block - 1) / threads_per_block;
	matmul_kernel <<<blocksize, threads_per_block >>> (A, B, C, n);
	cudaDeviceSynchronize();

}



