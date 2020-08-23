#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J scannum
#SBATCH -o scannum-%j.out -e scannum-%j.err

cd $SLURM_SUBMIT_DIR

g++ scan.cpp task1.cpp -Wall -O3 -o task1

for Var in {10..30}
do  	  
	  ./task1 $((2**$Var))
done


