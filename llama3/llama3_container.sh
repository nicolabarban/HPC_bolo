#!/bin/bash34
#SBATCH --nodes=1
#SBATCH --partition=l40s               # Or any GPU-enabled partition
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=/$USER/HPC_bolo/logs/build_llama3.out
#SBATCH --error=/$USER/HPC_bolo/logs/build_llama3.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=n.barban@unibo.it

set -x  # stampa tutti i comandi nel log

echo "Job avviato su $(hostname)"
echo "Spazio libero prima della build:"
df -h /scratch.hpc/$USER

export APPTAINER_TMPDIR=/scratch.hpc/$USER/TMP
mkdir -p "$APPTAINER_TMPDIR"

apptainer pull docker://nvcr.io/nim/meta/llama-3.1-8b-instruct:1.3.3