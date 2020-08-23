#include <iostream>
#include "mpi.h"

using namespace std;


int main(int argc, char ** argv) {

   int N = stoi(argv[1]);
  
   float *x = new(nothrow) float[N];
   float *y = new(nothrow) float[N];
   
  
   for (int i = 0; i < N; i++)
   {   
      x[i] = 10/(1+i);
      y[i] = 10/(2+i);
   }

    int rank;
    double start0, end0,start1,end1;
    double  t0=0,t1=0,time;
    
    int source =0,dest=1,tag=1;
    MPI_Status status;
         
    MPI_Init(&argc, &argv);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);
   
  
  if(rank==0)
  {
    start0 = MPI_Wtime();
    
    MPI_Send(x, N, MPI_FLOAT, dest, tag, MPI_COMM_WORLD);
    MPI_Recv(y, N, MPI_FLOAT, dest, tag, MPI_COMM_WORLD,&status);
   
    end0 = MPI_Wtime();
    t0 = end0-start0;
    
    MPI_Send(&t0,1, MPI_DOUBLE, dest, tag, MPI_COMM_WORLD);

  }
  else if (rank==1)
  {
    start1 = MPI_Wtime();
    
    MPI_Recv(x,N, MPI_FLOAT, source, tag, MPI_COMM_WORLD,&status);
    MPI_Send(y,N, MPI_FLOAT, source, tag, MPI_COMM_WORLD);
    
    end1 = MPI_Wtime();
    t1 = end1-start1;
    
    MPI_Recv(&t0,1, MPI_DOUBLE, source, tag, MPI_COMM_WORLD,&status);
 
    time = t0+t1;
    cout<<time*1000<<endl;
  
  }

   MPI_Finalize();
  
   delete[] x;
   delete[] y;

   return 0;

}

