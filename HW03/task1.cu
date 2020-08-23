#include<iostream>
#include <cuda.h>

__global__ void hello_world() {
	std::printf("Hello World! I am thread %d.\n", threadIdx.x);
}

int main() {
	
	hello_world<<<1,4>>>();
	cudaDeviceSynchronize();
	return 0;
}