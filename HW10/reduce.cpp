#include <iostream>
#include <omp.h>
#include <cstddef>

float reduce(const float* arr, const size_t l, const size_t r)
{
	float sumx=0;
      
	#pragma omp parallel 
	{
             #pragma omp for simd reduction(+:sumx)
		for (size_t i=l; i<r; i++)
		  sumx +=arr[i];
	       
        }
  
       return sumx;

}