#include <iostream>
#include<cstdlib>
#include <chrono>
#include "convolution.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
 
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   duration<double, std::milli> duration_sec;
   start = high_resolution_clock::now();
    
   int N = stoi(argv[1]);
   float *image = new(nothrow) float[N*N];
   float *output = new(nothrow) float[N*N];
   float mask[9] = {-1,0,1,2,1,-2,1,8,0};

  // Initialize image matrix with random value between 0 to 1 
  // and output matrix with 0 value. 
   for (int i = 0; i < N*N; i++)
  {   
      image[i] = (float) (rand() % 256)/256;   
      output[i] = 0;
  } 
  
   // since mask is 3x3 we pass 3 as size of the mask
   Convolve(image,output,N,mask,3);
   delete[] image;
  
   end = high_resolution_clock::now();
   duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

   // Print the required output
   cout <<duration_sec.count()<<endl;
   cout<<output[0]<<endl;
   cout<<output[N*N-1]<<endl;
 
   return 0;

}

