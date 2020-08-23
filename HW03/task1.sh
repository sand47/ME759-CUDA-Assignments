#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task1h
#SBATCH -o task1h-%j.out -e task1h-%j.err
#SBATCH --gres=gpu:1

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
./task1