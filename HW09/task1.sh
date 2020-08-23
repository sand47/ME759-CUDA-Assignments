#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task1
#SBATCH -o task1-%j.out -e task1-%j.err
#SBATCH --nodes=1 --cpus-per-task=20
cd $SLURM_SUBMIT_DIR

g++ task1.cpp cluster.cpp -Wall -O3 -o task1 -fopenmp

for t in {1..10}
do  	  
	  ./task1 50400 $t
done


