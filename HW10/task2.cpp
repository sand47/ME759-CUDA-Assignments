#include <iostream>
#include <omp.h>
#include <mpi.h>
#include <random>
#include "reduce.h"

using namespace std;


int main(int argc, char **argv) {

   int N = stoi(argv[1]);
   int thread = stoi(argv[2]);
      
   float *arr = new(nothrow) float[N];
     
   for (int i = 0; i < N; i++)
   {   
      arr[i] = (rand()%256)/100;
   }

    omp_set_num_threads(thread); 
   
    int rank;
    double start,end;
    double t=0,res;
    
    double global_res;
       
    MPI_Init(&argc, &argv);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);
    
    MPI_Barrier(MPI_COMM_WORLD); 

    start = MPI_Wtime(); 
      
  if(rank==0)
  {
   res = reduce(arr,0,N);
  }
  else if (rank==1)
  {
   res= reduce(arr,0,N);
  }

  MPI_Reduce(&res, &global_res, 1, MPI_DOUBLE, MPI_SUM, 0,
           MPI_COMM_WORLD);
  end = MPI_Wtime();
  
  if(rank==0)
  {
   t = end- start;
   cout<<global_res<<endl;
   cout<<t*1000<<endl;
  }

   MPI_Finalize();
  

   delete[] arr;
   
   return 0;

}

