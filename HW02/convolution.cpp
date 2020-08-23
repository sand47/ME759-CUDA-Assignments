
#include <cstddef>

void Convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m)

{
    unsigned int N = int(n);
    unsigned int a = int(m);
    unsigned int x,y;
    
    for(unsigned int i=0;i<N;i++)
    {
        for(unsigned int j=0;j<N;j++)
        {
            
            for(unsigned int k=0;k<a;k++)
            {
                for(unsigned int p=0;p<a;p++)
                {
                    x =i+k-1;
                    y =j+p-1;
                    if(x>=0 && y>=0 && x<N && y<N)
                    output[i*N+j] += mask[k*m+p]*image[x*N+y];
                }
                
            }
            
        }
    }
  
}