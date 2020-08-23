#include <iostream>

// Thrust headers
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "count.cuh"

using std::cout;
using std::endl;

int main(int argc, char **argv) {
  unsigned int n = atoi(argv[1]);

  // Timing CUDA events
  cudaEvent_t start, stop;
  float milliseconds = 0;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Allocating a host vector of size n
  thrust::host_vector<int> h_in((size_t)n);

  // Filling with random values between low and high
  int low = 0, high = 1000;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < n; ++i) {
    // This generates a random floats in range low to high
    h_in[i] = (int)(low + (((float)rand()) / (float)RAND_MAX) * (high - low));
  }

  // Copy from host to device
  thrust::device_vector<int> d_in = h_in;
  thrust::device_vector<int> values(n);
  thrust::device_vector<int> counts(n);

  cudaEventRecord(start);
  count(d_in, values, counts);
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  // Print the last element of the values array
  cout << *(values.end() - 1) << endl;

  // Print the last element of the counts array
  cout << *(counts.end() - 1) << endl;

  // Prints the time taken to run the scan in milliseconds
  cudaEventElapsedTime(&milliseconds, start, stop);
  cout << milliseconds << endl;

  return 0;
}
