#!/bin/sh
#SBATCH --job-name=job
#SBATCH --mail-type=all
#SBATCH --mail-user=$USER@unibo.it
#SBATCH --nodes=1
#SBATCH --partition=a100
#SBATCH --cpus-per-task=64
#SBATCH --gpus=1
#SBATCH --mem=256G
#SBATCH --output=/scratch.hpc/YOUR.NAME/dgit/tinyllama/logs/job.log
#SBATCH --error=/scratch.hpc/YOUR.NAME/dgit/tinyllama/logs/job.err

mkdir -p /scratch.hpc/$USER/tinyllama/cache
export APPTAINER_TMPDIR=/scratch.hpc/$USER/tinyllama/cache
export APPTAINER_CACHEDIR=/scratch.hpc/$USER/tinyllama/cache
export OMP_NUM_THREADS=64
cd /scratch.hpc/$USER/

apptainer exec --nv tinyllama/container.sif python dgit/tinyllama/example.py

# otherwise: partition=h100sxm5
# otherwise: partition=h100pcie
# otherwise: partition=a100



