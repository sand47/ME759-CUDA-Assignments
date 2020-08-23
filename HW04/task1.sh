#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task1ha
#SBATCH -o task1ha-%j.out -e task1ha-%j.err
#SBATCH --gres=gpu:1
#SBATCH --mem=16G

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1

for i in {5..15}
do
    N=$((2**$i))
    ./task1 $N 512
done