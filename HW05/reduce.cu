#include<iostream>
#include <cuda.h>


__global__ void reduce_kernel(const int* g_idata, int* g_odata, unsigned int n)

{
    extern __shared__ int sdata[];

    unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
   if(i<n)
     {

    sdata[threadIdx.x] = g_idata[i];
     }
    __syncthreads();
    
   for (unsigned int s=blockDim.x/2; s>0; s>>=1) {
    if (threadIdx.x< s) {
	if(i+s<n)
	{
        sdata[threadIdx.x] += sdata[threadIdx.x+ s];
	}
    }
    __syncthreads();
   }

    
   
    if(threadIdx.x==0)
     {
	g_odata[blockIdx.x] = sdata[0];	
     }
	 	 
}


__host__ int reduce(const int* arr, unsigned int N, unsigned int threads_per_block)
{
	
	int gdim = (N +threads_per_block-1)/ (threads_per_block);
	
	int* dev_i;
	int* dev_o;
	
	int op =0;
		
	cudaMallocManaged(&dev_i,N * sizeof(int));
	cudaMallocManaged(&dev_o,gdim * sizeof(int));
	
	cudaMemcpy(dev_i, arr, N * sizeof(int), cudaMemcpyHostToDevice);
	
	int size = N;
	int g = gdim;
	
	for(int i=0;i<g;i++)
	{
	reduce_kernel<<<gdim,threads_per_block,threads_per_block*sizeof(int)>>>(dev_i,dev_o,size);
	
        cudaDeviceSynchronize();
	size = gdim;
	
	int *temp = dev_o;
	dev_o = dev_i;
	dev_i = temp;	
	
	gdim = (size +threads_per_block-1)/ (threads_per_block);
    	
 		
	}
	
	op = dev_i[0];	
	
	cudaFree(dev_i);
        cudaFree(dev_o);
	
	return op;
}