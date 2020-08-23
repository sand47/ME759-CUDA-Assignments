
#include <cstddef>

void mmul1(const double* A, const double* B, double* C, const std::size_t n)
{
    int N = int(n);

    for(int i=0;i<N;i++)
     {
         for(int j=0;j<N;j++)
         {
             for(int a=0;a<N;a++)
             {
                 C[i*N+j] += A[i*N+a]*B[a*N+j];
                 
             }
             
         }
     }
    
}


void mmul2(const double* A, const double* B, double* C, const std::size_t n){
    
    int N = int(n);

    for(int j=0;j<N;j++)
     {
         for(int i=0;i<N;i++)
         {
             for(int a=0;a<N;a++)
             {
                 C[i*N+j] += A[i*N+a]*B[a*N+j];
                 
             }
            
         }
     }
    
}


void mmul3(const double* A, const double* B, double* C, const std::size_t n){
    
    int N = int(n);
    for(int i=0;i<N ;i++)
     {
         for(int j=0;j<N;j++)
         {
             for(int a=0;a<N;a++)
             {
                 C[i*N+j] += A[i*N+a]*B[a+j*N];
                 
             }
             
         }
     }
    
    
}


void mmul4(const double* A, const double* B, double* C, const std::size_t n){
    
    int N = int(n);

    for(int i=0;i<N;i++)
     {
         for(int j=0;j<N;j++)
         {
             for(int a=0;a<N;a++)
             {
                 C[i*N+j] += A[i+a*N]*B[a*N+j];
                 
             }
             
         }
     }
    
    
}