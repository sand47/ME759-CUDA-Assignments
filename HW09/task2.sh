#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2
#SBATCH -o task2-%j.out -e task2-%j.err
#SBATCH --nodes=1 --cpus-per-task=20
module load gcc/9.2.0
cd $SLURM_SUBMIT_DIR

g++ task2.cpp montecarlo.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec

for t in {1..10}
do  	  
	  ./task2 1000000 $t
done


