#include <iostream>
#include <chrono>
#include <omp.h>
#include <random>
#include "msort.h"

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
   int ts = atoi(argv[3]); 
   srand(time(0)); 
  
   int *A = new(nothrow) int[n];
   
 
   for(int i=0;i<n;i++)
  {
    A[i] = rand() % 5000;
  }
 
  start = high_resolution_clock::now();

  omp_set_num_threads(thread); 
 
  msort(A,n,ts);
  
  end = high_resolution_clock::now();
  duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
 
  cout<<A[0]<<endl;
  cout<<A[n-1]<<endl;
  cout <<duration_sec.count()<<endl;
  
 
  delete[] A;
     
  return 0;

}



