#!/bin/sh
#SBATCH --job-name=cont
#SBATCH --mail-type=all
#SBATCH --mail-user=joseph.enguehard@unibo.it
#SBATCH --partition=amdepyc9754
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/scratch.hpc/joseph.enguehard/dgit/tinyllama/container/build.log
#SBATCH --error=/scratch.hpc/joseph.enguehard/dgit/tinyllama/container/build.err

mkdir -p /scratch.hpc/joseph.enguehard/tinyllama/container-cache
export APPTAINER_TMPDIR=/scratch.hpc/joseph.enguehard/tinyllama/container-cache
export APPTAINER_CACHEDIR=/scratch.hpc/joseph.enguehard/tinyllama/container-cache
cd /scratch.hpc/joseph.enguehard/
apptainer build --force --ignore-fakeroot-command tinyllama/container.sif dgit/tinyllama/container/container.def
