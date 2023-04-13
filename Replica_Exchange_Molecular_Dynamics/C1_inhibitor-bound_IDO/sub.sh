#!/bin/bash
#SBATCH -N 5
#SBATCH --ntasks-per-node=6
#SBATCH -p gpu
#SBATCH --gres=gpu:3
#SBATCH --no-requeue
export MODULEPATH=/dat01/paraai_test/software/modulefiles:$MODULEPATH
module load amber/18-impi17
srun -n 30 pmemd.cuda.MPI -ng 30 -groupfile remd1.groupfile
