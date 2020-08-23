#include "scan.cuh"
#include <iostream>

using std::cout;
using std::endl;
using std::printf;

/*
1. The main hillis_steele algorithm that will work on each block independenty
*/
__global__ void hillis_steele(const float *Din, float *Dout, unsigned int n,
                              float *blockSums, unsigned int total_size) {

  extern __shared__ float temp[];
  unsigned int thid = threadIdx.x;
  unsigned int pout = 0, pin = 1;

  unsigned int arrIdx = threadIdx.x + (blockIdx.x * blockDim.x);

  if (arrIdx <= total_size) {

    // Load data from device to shared memory
    temp[thid] = (arrIdx == 0) ? 0 : Din[arrIdx - 1];
    __syncthreads();

    for (int offset = 1; offset < n; offset *= 2) {

      pout = 1 - pout;
      pin = 1 - pout;

      if (thid >= offset) {
        temp[pout * n + thid] =
            temp[pin * n + thid] + temp[pin * n + thid - offset];
      } else {
        temp[pout * n + thid] = temp[pin * n + thid];
      }

      __syncthreads();
    }

    // If this is the last thread in it's block, write it's output
    // (thid == n) has to be checked for when total elements < threads_per_block
    if ((thid == (blockDim.x - 1)) || (thid == total_size - 1))
      blockSums[blockIdx.x] = temp[pout * n + thid];

    // Copy data back to device memory
    Dout[arrIdx] = temp[pout * n + thid];
  }
}

/*
2. Defining an auxilliary kernel ot accumulate block sums
This may be incorporated in the main hillis_steele kernel
*/
__global__ void block_hillis_steele(const float *Din, float *Dout,
                                    unsigned int n) {

  extern __shared__ float temp[];
  unsigned int thid = threadIdx.x;
  unsigned int pout = 0, pin = 1;

  if (thid <= n) {
    temp[thid] = (thid == 0) ? 0 : Din[thid - 1];

    __syncthreads();

    for (int offset = 1; offset < n; offset *= 2) {

      pout = 1 - pout;
      pin = 1 - pout;

      if (thid >= offset) {
        temp[pout * n + thid] =
            temp[pin * n + thid] + temp[pin * n + thid - offset];
      } else {
        temp[pout * n + thid] = temp[pin * n + thid];
      }

      __syncthreads();
    }

    // Copy data back to device memory
    Dout[thid] = temp[pout * n + thid];
  }
}

/*
3 Adds the previous block sum to every element of output
*/
__global__ void block_adder_kernel(float *Dout, const float *blockSums,
                                   unsigned int total_size) {
  unsigned int arrIdx = threadIdx.x + (blockIdx.x * blockDim.x);

  if (arrIdx <= total_size)
    Dout[arrIdx] += blockSums[blockIdx.x];

  __syncthreads();
}

__host__ void scan(const float *in, float *out, unsigned int n,
                   unsigned int threads_per_block) {

  float *Din, *Dout, *blockSums, *blockSums_out;
  unsigned int shMemSize = (2 * threads_per_block) * sizeof(float);
  cudaError_t err = cudaSuccess;
  unsigned int n_blocks;

  // Allocate space for device: Din
  err = cudaMalloc((void **)&Din, n * sizeof(float));
  if (err != cudaSuccess)
    cout << "cudaMalloc Failed for Input Array! Error: " << err << endl;

  err = cudaMalloc((void **)&Dout, n * sizeof(float));
  if (err != cudaSuccess)
    cout << "cudaMalloc Failed for Output Array! Error: " << err << endl;

  // We need a separate array to store block sums
  n_blocks = (n + (threads_per_block - 1)) / threads_per_block;
  err = cudaMalloc((void **)&blockSums, n_blocks * sizeof(float));
  if (err != cudaSuccess)
    cout << "cudaMalloc Failed for BlockSums Array! Error: " << err << endl;

  cudaMemset(blockSums, 0, n_blocks); // Initializing cudaMemset

  // Copying the data to device
  cudaMemcpy(Din, in, n * sizeof(float), cudaMemcpyHostToDevice);

  // Implementation that supports n upto 1024
  hillis_steele<<<n_blocks, threads_per_block, shMemSize>>>(
      Din, Dout, threads_per_block, blockSums, n);

  err = cudaMalloc((void **)&blockSums_out, n_blocks * sizeof(float));
  if (err != cudaSuccess)
    cout << "cudaMalloc Failed for BlockSums_Out Array! Error: " << err << endl;

  // Running hillis steele algo again, this time on block_sums
  // If we keep the batch_size = 1024, we cannot possibly have n_blocks > 1024
  // because Assumption: n <= threads_per_block * threads_per_block
  block_hillis_steele<<<1, threads_per_block, shMemSize>>>(
      blockSums, blockSums_out, n_blocks);

  block_adder_kernel<<<n_blocks, threads_per_block>>>(Dout, blockSums_out, n);

  // Copy results back to the host
  cudaMemcpy(out, Dout, n * sizeof(float), cudaMemcpyDeviceToHost);

  // Wait for GPU to finish
  cudaDeviceSynchronize();

  // Cleanup
  cudaFree(Din);
  cudaFree(Dout);
  cudaFree(blockSums);
  cudaFree(blockSums_out);
}
