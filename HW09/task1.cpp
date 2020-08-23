#include <iostream>
#include <bits/stdc++.h> 
#include <chrono>
#include <stdlib.h>
#include <algorithm>
#include "cluster.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
 
   srand (time(NULL));
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;

   int N = stoi(argv[1]);
   int thread = stoi(argv[2]);
   float totalttime =0;
   int maxDist,threadID;

   int *arr = new(nothrow) int[N];
   int *centers = new(nothrow) int[thread];
   int *dists = new(nothrow) int[thread];

  for (int i = 0; i < N; i++)
  {   
      arr[i] = rand()%N+1;
      
  }

  
  sort(arr,arr+N);

  for (int i = 0; i <thread; i++)
  {   
      centers[i] = (2*(i+1)-1)*N/(2*thread) ;
      dists[i] = 0;
    
  } 
 
  
  
   for(int i=0;i<11;i++)
  {
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();
    
    cluster(N,thread,arr,centers,dists);
    
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();

    if(i!=10)
    {
      for(int i=0;i<thread;i++)
       { 
         dists[i] =0;      
       }

     } 
  
   }

   //find maximum element index and value  
   threadID = distance(dists, max_element(dists,dists + thread));
   maxDist = dists[threadID];
    
   // Print the required output
   cout<<maxDist<<endl;
   cout<<threadID<<endl;
   cout <<totalttime/10<<endl;
  
   delete[] centers;
   delete[] arr;
   delete[] dists;
   
   return 0;

}

