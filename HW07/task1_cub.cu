#include <iostream>

#define CUB_STDERR // print CUDA runtime errors to console
#include <cub/device/device_reduce.cuh>
#include <cub/util_allocator.cuh>
#include <stdio.h>
// #include "test/test_util.h"
using namespace cub;
CachingDeviceAllocator g_allocator(true); // Caching allocator for device memory

using std::cout;
using std::endl;
using namespace cub;

int main(int argc, char **argv) {

  unsigned int num_items = atoi(argv[1]);
  bool check_sum = false;

  // Set up host arrays
  int *h_in = new int[num_items]();

  // Timing CUDA events
  cudaEvent_t start, stop;
  float milliseconds = 0;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Filling with random values between low and high
  int low = -100, high = 100;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < num_items; ++i) {
    // This generates a random integers in range low to high
    h_in[i] = (int)(low + (((float)rand()) / (float)RAND_MAX) * (high - low));
  }

  int sum = 0;
  // Sum as calculated on the CPU
  if (check_sum) {
    for (unsigned int i = 0; i < num_items; i++)
      sum += h_in[i];
    cout << "cpu_sum is: " << sum << endl;
  }

  // Set up device arrays
  int *d_in = NULL;
  CubDebugExit(
      g_allocator.DeviceAllocate((void **)&d_in, sizeof(int) * num_items));

  // Initialize device input
  CubDebugExit(
      cudaMemcpy(d_in, h_in, sizeof(int) * num_items, cudaMemcpyHostToDevice));

  // Setup device output array
  int *d_sum = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_sum, sizeof(int) * 1));

  // Request and allocate temporary storage
  void *d_temp_storage = NULL;
  size_t temp_storage_bytes = 0;
  CubDebugExit(DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in,
                                 d_sum, num_items));
  CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

  // Do the actual reduce operation -- measure time using CUDA events
  cudaEventRecord(start);
  CubDebugExit(DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in,
                                 d_sum, num_items));
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  int gpu_sum;
  CubDebugExit(
      cudaMemcpy(&gpu_sum, d_sum, sizeof(int) * 1, cudaMemcpyDeviceToHost));
  // Check for correctness
  if (check_sum) {
    printf("%s\n", (gpu_sum == sum ? "Test passed." : "Test failed."));
  }

  cudaEventElapsedTime(&milliseconds, start, stop);
  // 4. Prints the resulting sum
  cout << gpu_sum << endl;

  // 5. Prints the time taken to run the reduction in milliseconds
  cout << milliseconds << endl;

  // Cleanup
  if (d_in)
    CubDebugExit(g_allocator.DeviceFree(d_in));
  if (d_sum)
    CubDebugExit(g_allocator.DeviceFree(d_sum));
  if (d_temp_storage)
    CubDebugExit(g_allocator.DeviceFree(d_temp_storage));

  return 0;
}
