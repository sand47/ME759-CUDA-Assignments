#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J task2ha
#SBATCH -o task2ha-%j.out -e task2ha-%j.err
#SBATCH --gres=gpu:1 -c 1
#SBATCH --mem=16G

cd $SLURM_SUBMIT_DIR
module load cuda

nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task2

for i in {10..31}
do
    N=$((2**$i))
    ./task2 $N 128 512
done



