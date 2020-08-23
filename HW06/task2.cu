#include "scan.cuh"
#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <iostream>

using std::cout;
using std::endl;

int main(int argc, char **argv) {
  unsigned int n = atoi(argv[1]);
  unsigned int threads_per_block = 1024; // should be a multiple of warp size
  float *Hin, *Hout;

  // Timing CUDA events
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Allocating space for arrays on host, Initialized to zero
  Hin = new float[n]();
  Hout = new float[n]();

  float a = -5;
  float b = 5;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < n; ++i) {
    // This generates a random floats in range a to b
    Hin[i] = (float)(a + (((float)rand()) / (float)RAND_MAX) * (b - a));

    // Set a known value, alternatively
    // Hin[i] = (float)(i+1);
  }

  // Calling the reduce operation
  cudaEventRecord(start);
  scan(Hin, Hout, n, threads_per_block); // Output is expected to be in Hout
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  // Calculate time in milliseconds
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  // Prints the last element of the output array
  cout << Hout[n - 1] << endl;

  // Time taken by the full scan method in milliseconds
  cout << milliseconds << endl;

  // Cleanup
  cudaFree(Hin);
  cudaFree(Hout);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  return 0;
}
