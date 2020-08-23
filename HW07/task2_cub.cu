#include <iostream>

#define CUB_STDERR // print CUDA runtime errors to console
#include <cub/device/device_scan.cuh>
#include <cub/util_allocator.cuh>
#include <stdio.h>

using std::cout;
using std::endl;
using namespace cub;
CachingDeviceAllocator g_allocator(true); // Caching allocator for device memory

int main(int argc, char **argv) {

  unsigned int n = atoi(argv[1]);

  // Timing CUDA events
  cudaEvent_t start, stop;
  float milliseconds = 0;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Set up host arrays
  float *h_in = new float[n]();
  float *h_out = new float[n]();

  // Filling with random values between low and high
  float low = -100, high = 100;
  // Setting Random values to the host array
  for (unsigned int i = 0; i < n; ++i) {
    // This generates a random floats in range -5 to 5
    h_in[i] = (float)(low + (((float)rand()) / (float)RAND_MAX) * (high - low));
  }

  // 1. Set up device input/output array
  float *d_in = NULL, *d_out = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_in, sizeof(float) * n));
  // Copy data from the host array into device
  CubDebugExit(
      cudaMemcpy(d_in, h_in, sizeof(float) * n, cudaMemcpyHostToDevice));

  // Set up device output array
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_out, sizeof(float) * n));
  CubDebugExit(cudaMemset(d_out, 0, sizeof(float) * n));

  // Request and allocate temporary storage
  void *d_temp_storage = NULL;
  size_t temp_storage_bytes = 0;
  CubDebugExit(DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes,
                                        d_in, d_out, n));
  CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

  // Do the actual scan operation -- measure time using CUDA events
  cudaEventRecord(start);
  CubDebugExit(DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes,
                                        d_in, d_out, n));
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  // Copy data back to the host
  CubDebugExit(
      cudaMemcpy(h_out, d_out, sizeof(float) * n, cudaMemcpyDeviceToHost));

  cudaEventElapsedTime(&milliseconds, start, stop);
  // 4. Prints the last element of the output array
  cout << h_out[n - 1] << endl;

  // 5. Prints the time taken to run the scan in milliseconds
  cout << milliseconds << endl;

  return 0;
}
