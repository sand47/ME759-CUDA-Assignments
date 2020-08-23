#include<iostream>
#include <cuda.h>



__global__ void matmul_kernel(const float* A, const float* B, float* C, unsigned int n)
{
    
    extern __shared__ float sm[];

    float *sA = &sm[0];
    float *sB = &sA[blockDim.x*blockDim.x];
   
    int r = blockIdx.y*blockDim.x+ threadIdx.y;
    int c = blockIdx.x*blockDim.x + threadIdx.x;

    float opval = 0.0;
    
    int tx = threadIdx.x; int ty = threadIdx.y; 
    int bx = blockIdx.x; int by = blockIdx.y;

    for (int q = 0; q < (blockDim.x + n - 1)/blockDim.x; q++)
 {
        	
	if (q*blockDim.x + threadIdx.x < n && r < n)
	 sA[blockDim.x*ty+ tx] = A[r*n + q*blockDim.x + threadIdx.x];
       else
	 sA[blockDim.x*ty+ tx] = 0.0;
	
	if (q*blockDim.x+ threadIdx.y < n && c< n)  
	 sB[blockDim.x*ty+ tx] = B[(q*blockDim.x + threadIdx.y)*n + c];
        else 
	 sB[blockDim.x*ty+ tx] = 0.0;

        __syncthreads();

        for (int j = 0; j < blockDim.x; ++j)//Multiplying Elements present in tile
        {
            opval += sA[blockDim.x*ty+ j] * sB[blockDim.x*j+ tx];
        }

        __syncthreads();
    }
    
    
    int cindex = (by * blockDim.x + threadIdx.y)*n+(bx*blockDim.x)+threadIdx.x;
    if (r < n && c < n)
	C[cindex]=opval;
    

}

__host__ void matmul(const float* A, const float* B, float* C, unsigned int n, unsigned int block_dim)

{
    dim3 dimBlock(block_dim,block_dim);
    int gridsize= (n + block_dim -1)/ block_dim;
    dim3 dimGrid(gridsize,gridsize);
   
    matmul_kernel<<<dimGrid,dimBlock, 2*block_dim*block_dim* sizeof(float)>>>(A, B, C, n);
    cudaDeviceSynchronize();

}



