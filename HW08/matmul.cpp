#include <iostream>
#include <omp.h>


void mmul(const float* A, const float* B, float* C, const std::size_t n)
{
    
    size_t i,j,a;
    #pragma omp parallel private(i,j,a) shared(A,B,C) 
    {
     
		#pragma omp for  
		for(i=0;i<n;i++)
		     {
		         for(j=0;j<n;j++)
		         {
                             
		             for(a=0;a<n;a++)
		             {
		                  C[i*n+j] += A[i*n+a]*B[a*n+j];
		                 
		             }
			   
		             
		         }
		     }
	         
    }
}