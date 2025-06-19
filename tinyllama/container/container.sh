#!/bin/sh
#SBATCH --job-name=cont
#SBATCH --mail-type=all
#SBATCH --mail-user=n.barban@unibo.it
#SBATCH --partition=amdepyc9754
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/scratch.hpc/$USER/HPC_bolo/tinyllama/container/build.log
#SBATCH --error=/scratch.hpc/$USER/HPC_bolo/tinyllama/container/build.err

mkdir -p /scratch.hpc/$USER/tinyllama/container-cache
export APPTAINER_TMPDIR=/scratch.hpc/$USER/tinyllama/container-cache
export APPTAINER_CACHEDIR=/scratch.hpc/$USER/tinyllama/container-cache
cd /scratch.hpc/$USER/
apptainer build --force --ignore-fakeroot-command tinyllama/container.sif dgit/tinyllama/container/container.def
