#include <iostream>
#include <chrono>
#include <omp.h>
#include "matmul.h"
using namespace std;

using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   duration<double, std::milli> duration_sec;
   
   int n = atoi(argv[1]); 
   int thread = atoi(argv[2]); 
  
   float *A = new(nothrow) float[n*n];
   float *B = new(nothrow) float[n*n];
   float *C = new(nothrow) float[n*n];

  
   for(int i=0;i<n*n;i++)
  {
    A[i] = (float) (rand() % 256)/256;
    B[i] = (float) (rand() % 256)/256;	
  }
 
  start = high_resolution_clock::now();

  omp_set_num_threads(thread); 
  mmul(A,B,C,n);
 
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
  cout<<C[0]<<endl;
  cout<<C[n*n-1]<<endl;
  cout <<duration_sec.count()<<endl;
  
 
  delete[] A;
  delete[] B;
  delete[] C;
    
  return 0;

}

