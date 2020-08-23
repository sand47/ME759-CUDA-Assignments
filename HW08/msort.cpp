#include <cstddef>
#include <omp.h>
#include <algorithm>


void sort_serial(int arr[],  int n) {

    int i, flag, j;  
    for (i = 1; i < n; i++) 
    {  
        flag = arr[i];  
        j = i - 1;  
  
       
        while (j >= 0 && arr[j] > flag) 
        {  
            arr[j + 1] = arr[j];  
            j = j - 1;  
        }  
        arr[j + 1] = flag;  
    }  
  
  
}

void msort(int* arr, const std::size_t n, const std::size_t threshold)
{
   
   
   if (n<threshold)
   {
     sort_serial(arr, n);
      
   }
   else
   {
     #pragma omp parallel sections
        {
            #pragma omp section
            msort(arr, n/2, threshold);
            #pragma omp section
            msort(arr + n/2, n-n/2,threshold);
        }
        std::inplace_merge(arr, arr+n/2,arr+n );
       
   } 

     
}