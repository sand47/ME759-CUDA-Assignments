#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2
#SBATCH -o task2-%j.out -e task2-%j.err
#SBATCH --nodes=2 --cpus-per-task=20 --ntasks-per-node=1 
module load mpi/openmpi
export OMP_DISPLAY_AFFINITY=true
module load gcc/9.2.0

cd $SLURM_SUBMIT_DIR

mpicxx task2.cpp reduce.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec 


for t in {1..20}
do  	  
	  mpirun -np 2 --bind-to none ./task2 1000000 $t
done


