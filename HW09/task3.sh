#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task3
#SBATCH -o task3-%j.out -e task3-%j.err
#SBATCH --ntasks-per-node=2
module load mpi/openmpi
cd $SLURM_SUBMIT_DIR

mpicxx task3.cpp -Wall -O3 -o task3

for i in {1..25}
do  	  
	  mpirun -np 2 task3 $((2**$i))
done


