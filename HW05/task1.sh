#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task1h
#SBATCH -o task1h-%j.out -e task1h-%j.err
#SBATCH --gres=gpu:1 -c 1
#SBATCH --mem=16G

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task1.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1


for i in {10..30}
do
    N=$((2**$i))
    ./task1 $N 512
done