#include <iostream>

// Thrust headers
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

using std::cout;
using std::endl;

int main(int argc, char **argv) {
  // ./task1 n
  unsigned int n = atoi(argv[1]);

  // Timing CUDA events
  cudaEvent_t start, stop;
  float milliseconds = 0;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // 1. Allocating a host vector of size n
  thrust::host_vector<int> H(n);

  // Filling with random values between low and high
  int low = -100, high = 100;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < n; ++i) {
    // This generates a random integers in range -100 to 100
    H[i] = (int)(low + (((float)rand()) / (float)RAND_MAX) * (high - low));
  }

  // 2. Copy from host to device
  thrust::device_vector<int> D = H;

  // 3. Call thrust::reduce function to do reduction
  cudaEventRecord(start);
  int sum = thrust::reduce(D.begin(), D.end(), (int)0, thrust::plus<int>());
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  cudaEventElapsedTime(&milliseconds, start, stop);

  // 4. Prints the resulting sum
  cout << sum << endl;

  // 5. Prints the time taken to run the reduction in milliseconds
  cout << milliseconds << endl;

  return 0;
}
