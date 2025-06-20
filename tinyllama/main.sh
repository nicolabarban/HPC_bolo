#!/bin/sh
#SBATCH --job-name=job
#SBATCH --mail-type=all
#SBATCH --mail-user=n.barban@unibo.it
#SBATCH --nodes=1
#SBATCH --partition=l40s
#SBATCH --cpus-per-task=64
#SBATCH --gpus=1
#SBATCH --mem=256G
#SBATCH --output=/scratch.hpc/nicola.barban2/HPC_bolo/tinyllama/logs/job.log
#SBATCH --error=/scratch.hpc/nicola.barban2/HPC_bolo/tinyllama/logs/job.err

mkdir -p /scratch.hpc/$USER/HPC_bolo/tinyllama/cache
export APPTAINER_TMPDIR=/scratch.hpc/$USER/HPC_bolo/tinyllama/cache
export APPTAINER_CACHEDIR=/scratch.hpc/$USER/HPC_bolo/tinyllama/cache
export OMP_NUM_THREADS=64
cd /scratch.hpc/nicola.barban2/HPC_bolo/tinyllama

apptainer exec --nv container/container.sif python test_tasks.py

# otherwise: partition=h100sxm5
# otherwise: partition=h100pcie
# otherwise: partition=a100



