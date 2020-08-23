#include<iostream>
#include <chrono>
#include "scan.h"

using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;


int main(int argc, char* argv[]){

    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    start = high_resolution_clock::now();
      
    unsigned int n = stoi(argv[1]); 
    float *ip = new(nothrow) float[n];
    float *op = new(nothrow) float[n];
    float flag = -1.0;
   
  
    // ip array values are filled between -1 to 1
    // op array is initialize with 0
    for(unsigned int i=0;i<n;i++)
    {
        flag = flag + 0.1;
        ip[i] = flag;
        op[i] = 0;
              
        if ((flag >1.0) || (flag < -1.0))
        {
            flag = -1.0;
        }
    }
   
    Scan(ip,op,n);
    delete[] ip;
   
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    
    // Print the required output 
    cout << duration_sec.count()<<endl;
    cout<<op[0]<<endl;   
    cout<<op[n- 1]<<endl;
   
   return 0;
}