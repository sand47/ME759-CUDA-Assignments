#include <iostream>
#include <chrono>
#include "matmul.h"
using namespace std;

using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

void clearC(double *C,int N)
{
    
    for(int i=0;i<N*N;i++)
    {
        C[i]=0;
    }
}


int main() {
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   duration<double, std::milli> duration_sec;
   
   int N = 1020; 
  
   double *A = new(nothrow) double[N*N];
   double *B = new(nothrow) double[N*N];
   double *AcolMajor = new(nothrow) double[N*N];
   double *BcolMajor =new(nothrow) double[N*N];
   double *C = new(nothrow) double[N*N];

   // row-major initialize
   for(int i=0;i<N*N;i++)
  {
    A[i] = (float) (rand() % 256)/256;
    B[i] = (float) (rand() % 256)/256;	
  }
 
  // column major initialization from the row-major
  for(int i=0;i<N;i++)
  {
      for(int j=0;j<N;j++)
      {
          AcolMajor[i*N+j] = A[i+j*N];
          BcolMajor[i*N+j] = B[i+j*N];
      }
  }
  
  cout<<N<<endl;
  
  // calling mmul1

  clearC(C,N);
  start = high_resolution_clock::now();

  mmul1(A,B,C,N);
 
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

  cout <<duration_sec.count()<<endl;
  cout<<C[N*N-1]<<endl;
 

  // calling mmul2

  start = high_resolution_clock::now();
  clearC(C,N);
  
  mmul2(A,B,C,N);
  
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

  cout <<duration_sec.count()<<endl;
  cout<<C[N*N-1]<<endl;
  
  // calling mmul3

  start = high_resolution_clock::now();
  clearC(C,N);
  
  mmul3(A,BcolMajor,C,N);
 
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

  cout <<duration_sec.count()<<endl;
  cout<<C[N*N-1]<<endl;
  
  //calling mmul4
  start = high_resolution_clock::now();
  clearC(C,N);
  
  mmul4(AcolMajor,B,C,N);
 
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

  cout <<duration_sec.count()<<endl;
  cout<<C[N*N-1]<<endl;

  delete[] A;
  delete[] B;
  delete[] C;
  delete[] AcolMajor;
  delete[] BcolMajor;

  
  return 0;

}

