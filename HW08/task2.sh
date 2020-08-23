#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2
#SBATCH -o task2-%j.out -e task2-%j.err
#SBATCH --nodes=1 --cpus-per-task=20
cd $SLURM_SUBMIT_DIR

g++ task2.cpp convolution.cpp -Wall -O3 -o task2 -fopenmp
for Var in {1..20}
do  	  
	  ./task2 1024 $Var
done


