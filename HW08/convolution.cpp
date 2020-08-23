#include <cstddef>
#include <omp.h>
void Convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m)

{
   
    size_t x,y;
    
    #pragma omp parallel 
    {

        #pragma omp for
        for(size_t i=0;i<n;i++)
        {
            for(size_t j=0;j<n;j++)
            {
                
                for(size_t k=0;k<m;k++)
                {
                    for(size_t p=0;p<m;p++)
                    {
                        x =i+k-1;
                        y =j+p-1;
                        if(x>=0 && y>=0 && x<n && y<n)
                        output[i*n+j] += mask[k*m+p]*image[x*n+y];
                    }
                    
                }
                
            }
        }
    }
  
}