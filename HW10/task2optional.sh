#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2op
#SBATCH -o task2op-%j.out -e task2op-%j.err
#SBATCH --nodes=1 --cpus-per-task=20  
cd $SLURM_SUBMIT_DIR

g++ task2_op.cpp reduce.cpp -Wall -O3 -o task2op -fopenmp  


for t in {1..25}
do  	  
	  ./task2op $((2**$t) 5
done


