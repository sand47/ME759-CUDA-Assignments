#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2h
#SBATCH -o task2h-%j.out -e task2h-%j.err
#SBATCH --gres=gpu:1 -c 1
#SBATCH --mem=16G

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task2.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2

for i in {5..15}
do
    N=$((2**$i))
    ./task2 $N 32
done