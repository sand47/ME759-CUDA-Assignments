#include "mmul.h"
#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <iostream>

using std::cout;
using std::endl;

int main(int argc, char **argv) {
  unsigned int n = atoi(argv[1]);
  unsigned int n_tests = atoi(argv[2]);
  float *A, *B, *C;
  unsigned int size = n * n;

  cublasHandle_t handle;

  // Timing CUDA events
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // 1. Create matrices of size n*n in managed (unified) memory
  // Allocate Unified Memory -- accessible from CPU or GPU
  cudaMallocManaged(&A, size * sizeof(float));
  cudaMallocManaged(&B, size * sizeof(float));
  cudaMallocManaged(&C, size * sizeof(float));

  // 2. Initialize the matrices A, B and C
  // Boundaries for random values
  float low = -10;
  float high = 10;
  for (unsigned int i = 0; i < size; ++i) {
    // This generates a random integers in range -5 to 5
    A[i] = low + (((float)rand()) / (float)RAND_MAX) * (high - low);
    B[i] = low + (((float)rand()) / (float)RAND_MAX) * (high - low);
    C[i] = low + (((float)rand()) / (float)RAND_MAX) * (high - low);
  }

  cublasCreate(&handle);

  // 3. Set math mode
  cublasSetMathMode(handle, CUBLAS_TENSOR_OP_MATH);

  // 4. Call mmul function n_tests times
  cudaEventRecord(start);
  for (int j = 0; j < n_tests; ++j) {
    mmul(handle, A, B, C, n);
  }

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  // Calculate total time in milliseconds
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  // 5. Prints the average time taken to run the mmul in milliseconds
  cout << (milliseconds / n_tests) << endl;

  // Cleanup
  cudaFree(A);
  cudaFree(B);
  cudaFree(C);
  cublasDestroy(handle);

  return 0;
}
