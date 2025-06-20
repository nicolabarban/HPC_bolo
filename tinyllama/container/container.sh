#!/bin/sh
#SBATCH --job-name=cont
#SBATCH --mail-type=all
#SBATCH --mail-user=n.barban@unibo.it
#SBATCH --partition=sbuild
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=/scratch.hpc/$USER/HPC_bolo/tinyllama/container/build.log
#SBATCH --error=/scratch.hpc/$USER/HPC_bolo/tinyllama/container/build.err

export APPTAINER_TMPDIR=/scratch.hpc/$USER/HPC_bolo/tinyllama/container-cache
export APPTAINER_CACHEDIR=/scratch.hpc/$USER/HPC_bolo/tinyllama/container-cache
export TMPDIR=/scratch.hpc/$USER/HPC_bolo/tinyllama/container-cache
mkdir -p "$TMPDIR"

cd /scratch.hpc/$USER/HPC_bolo/tinyllama/container/
apptainer build --force --ignore-fakeroot-command container.sif container.def
