#include <iostream>

// Thrust headers
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

using std::cout;
using std::endl;

int main(int argc, char **argv) {
  unsigned int n = atoi(argv[1]);

  // Timing CUDA events
  cudaEvent_t start, stop;
  float milliseconds = 0;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // 1. Allocating a host vector of size n
  thrust::host_vector<float> H(n);

  // Filling with random values between low and high
  float low = -100, high = 100;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < n; ++i) {
    // This generates a random floats in range low to high
    H[i] = (float)(low + (((float)rand()) / (float)RAND_MAX) * (high - low));
  }

  // 2. Copy from host to device
  thrust::device_vector<float> D = H;

  // Allocating an output device vector of size n
  thrust::device_vector<float> Dout(n);

  // 3. Call the thrust:exclusive_scan function
  cudaEventRecord(start);
  thrust::exclusive_scan(D.begin(), D.end(), Dout.begin());
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  // 4. Prints the last element
  cout << Dout[n - 1] << endl;

  // 5. Prints the time taken to run the scan in milliseconds
  cudaEventElapsedTime(&milliseconds, start, stop);
  cout << milliseconds << endl;

  return 0;
}
