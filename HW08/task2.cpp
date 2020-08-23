#include <iostream>
#include <omp.h>
#include <chrono>
#include "convolution.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
 
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   int mask_size = 3;
   int N = stoi(argv[1]);
   int thread = stoi(argv[2]);

   float *image = new(nothrow) float[N*N];
   float *output = new(nothrow) float[N*N];
   float mask[mask_size*mask_size] = {-1,0,1,2,1,-2,1,8,0};

  // Initialize image matrix with random value between 0 to 1 
  // and output matrix with 0 value. 
   for (int i = 0; i < N*N; i++)
  {   
      image[i] = (float) (rand() % 256)/256;   
      output[i] = 0;
  } 
  
   duration<double, std::milli> duration_sec;
   start = high_resolution_clock::now();

   omp_set_num_threads(thread); 
   Convolve(image,output,N,mask,mask_size);
    
   end = high_resolution_clock::now();
   duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

   delete[] image;
   // Print the required output
   cout<<output[0]<<endl;
   cout<<output[N*N-1]<<endl;
   cout <<duration_sec.count()<<endl;

   delete[] output;
   return 0;

}

