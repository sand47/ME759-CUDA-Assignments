#include <iostream>
#include <omp.h>
#include <chrono>
#include <random>
#include "reduce.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;


int main(int argc, char **argv) {

   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   int N = stoi(argv[1]);
   int thread = stoi(argv[2]);
      
   float *arr = new(nothrow) float[N];
  
    for (int i = 0; i < N; i++)
  {   
      arr[i] = rand()%256;
     
  }

    omp_set_num_threads(thread); 
   
    float res1,tt=0;
    
    
   for(int i=0;i<11;i++)
 {
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();
 
    
    res1 = reduce(arr,0,N);
      
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    tt += duration_sec.count();
 }
    cout<<res1<<endl;
    cout<<tt/10<<endl;
    cout<<endl;


   delete[] arr;
   
   return 0;

}

