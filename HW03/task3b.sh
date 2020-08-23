#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task3add
#SBATCH -o task3add-%j.out -e task3add-%j.err
#SBATCH --gres=gpu:1
#SBATCH --mem=16G

cd $SLURM_SUBMIT_DIR

module load cuda
nvcc task3.cu vadd.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task3

for i in {10..29}
do
    N=$((2**$i))
    ./task3 $N
done