#include<iostream>
#include <cuda.h>


__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R)

{	
       
   extern __shared__ float shared[];

   float opsum=0;
   int flag=(int)R;
   float* mk = &shared[0];
   float* ip = &mk[2*R+1];
   float* op = &ip[blockDim.x+2*R + 1];

   int id =  blockIdx.x * blockDim.x + threadIdx.x;

    if (id <n)
   {
     ip[threadIdx.x+R] = image[id];
   }
   else
   {
     ip[threadIdx.x + R]= 0;
   }
    
   if (threadIdx.x < 2*R+1)
   {
     mk[threadIdx.x] = mask[threadIdx.x];
   }

    if (threadIdx.x < R)
    {
      
      if (id -flag>0)
      {
 	ip[threadIdx.x] = image[id -flag];

      }
      else
      {
    	ip[threadIdx.x]=0;
      }
    

     if ( id + blockDim.x < n)
      {
      	ip[blockDim.x+ threadIdx.x+R] = image[blockDim.x+ id ];
      }
      else
      {
     	 ip[blockDim.x+ threadIdx.x + R] = 0;
      }

    	
    }
    
    __syncthreads();

    for (int k = 0; k < (2*R+1); k++)
    {
        opsum += ip[threadIdx.x+k] * mk[k];
    }
    
    op[threadIdx.x] = opsum;

    if (id<n)
       output[id] = op[threadIdx.x];
   
}

__host__ void stencil(const float* image,const float* mask,float* output,unsigned int n,unsigned int R,unsigned int threads_per_block)
{
   
	int blocksize = (n + threads_per_block - 1) / threads_per_block;
	int size = 2*threads_per_block*sizeof(float)+2*R*sizeof(float) + (2*R+1)*sizeof(float);
	stencil_kernel <<<blocksize, threads_per_block,size>>>(image, mask, output, n, R);
	cudaDeviceSynchronize();

}



