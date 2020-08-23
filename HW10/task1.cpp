#include <iostream>
#include <chrono>
#include <random>
#include "optimize.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char* argv[]) {
 
  
   high_resolution_clock::time_point start;
   high_resolution_clock::time_point end;
   duration<double, std::milli> duration_sec;
   
   int N = stoi(argv[1]);
   
   vec *v = new vec(N); 
   v->data= new(nothrow) data_t[N];
   
   float totalttime =0;

   data_t dest=0;
   
  for (int i = 0; i < N; i++)
  {   
      v->data[i]= 1;//rand()%10;
      
  }
  
   for(int i=0;i<11;i++)
  {
    start = high_resolution_clock::now();
    optimize1(v,&dest);
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }

   cout<<dest<<endl;
   cout <<totalttime /10<<endl;
   totalttime = 0;

   for(int i=0;i<11;i++)
  {

    start = high_resolution_clock::now();
    optimize2(v,&dest);
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }

   cout<<dest<<endl;
   cout <<totalttime /10<<endl;
   totalttime = 0;

   for(int i=0;i<11;i++)
  {

    start = high_resolution_clock::now();
    optimize3(v,&dest);
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }

   cout<<dest<<endl;
   cout <<totalttime /10<<endl;
   totalttime = 0;

   for(int i=0;i<11;i++)
  {
    start = high_resolution_clock::now();
    optimize4(v,&dest);
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }

   cout<<dest<<endl;
   cout <<totalttime /10<<endl;
   totalttime = 0;

   for(int i=0;i<11;i++)
  {
    start = high_resolution_clock::now();
    optimize5(v,&dest);
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    totalttime += duration_sec.count();
   }

   cout<<dest<<endl;
   cout <<totalttime /10<<endl;
   
   delete v;
   return 0;

}

