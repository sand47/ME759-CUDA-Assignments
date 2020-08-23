#include <cstdlib>
#include <omp.h>


int montecarlo(const size_t n, const float *x, const float *y, const float radius)
{

   float origin_dist =0;
   int square_point=0;
   int points;
   #pragma omp parallel private(points) shared(square_point)
   {
        points =0;
        
       // uncomment the below line for without simd case and comment simd line
        //# pragma omp for 
        # pragma omp for simd
	for(size_t i=0;i<n;i++)
	{

		origin_dist = x[i]*x[i] + y[i]*y[i];
              
                points = (origin_dist < radius) ? points + 1: points; 
		
	}

      #pragma omp critical 
        square_point += points;
    }
  

    return square_point;


}

