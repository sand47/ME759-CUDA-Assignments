
#include <cstddef>

void Scan( const float *arr, float *op, std::size_t n)
{
 
    float scan_a = 0;
   
    for(int i = 0; i < int(n); i++){

             op[i] = scan_a;
             scan_a += arr[i];
    
    }
 
    
}
