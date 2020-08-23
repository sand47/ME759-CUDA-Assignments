#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task1
#SBATCH -o task1-%j.out -e task1-%j.err
#SBATCH --nodes=1 --cpus-per-task=1

cd $SLURM_SUBMIT_DIR

g++ task1.cpp optimize.cpp -Wall -O3 -o task1 -ffast-math -march=native -fopt-info-vec 

./task1 1000000


