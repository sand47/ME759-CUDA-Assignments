#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2h
#SBATCH -o task2h-%j.out -e task2h-%j.err
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task2.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2
./task2
