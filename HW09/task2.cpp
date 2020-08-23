#include <iostream>
#include <omp.h>
#include <chrono>
#include <random>
#include "montecarlo.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
 
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   int N = stoi(argv[1]);
   int thread = stoi(argv[2]);
   
   float radius = 1;
   double estimatePi;
   int circle_points;
   float totalttime =0;

   float *x = new(nothrow) float[N];
   float *y = new(nothrow) float[N];
   
   std::random_device rd;  
   std::mt19937 gen(rd()); 
   std::uniform_real_distribution<> dis(-radius, radius);

  for (int i = 0; i < N; i++)
  {   
      x[i] = dis(gen);
      y[i] = dis(gen);
  }

  omp_set_num_threads(thread);

  for(int i=0;i<11;i++)
  {

    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();
       
    circle_points = montecarlo(N,x,y,radius);
   
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }
   
   estimatePi = double(4*circle_points)/N; 

   cout<<estimatePi<<endl;
   cout <<totalttime /10<<endl;
  
   delete[] x;
   delete[] y;

   return 0;

}

