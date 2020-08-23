#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task3
#SBATCH -o task3-%j.out -e task3-%j.err
#SBATCH --nodes=1 --cpus-per-task=20
cd $SLURM_SUBMIT_DIR

g++ task3.cpp msort.cpp -Wall -O3 -o task3 -fopenmp
for i in {1..10}
do  	  
	
	./task3 1000000 8 $((2**$i))
done


