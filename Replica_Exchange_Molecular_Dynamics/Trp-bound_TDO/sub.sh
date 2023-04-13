#!/bin/bash
#SBATCH -N 5
#SBATCH --ntasks-per-node=6
#SBATCH -p gpu
#SBATCH --gres=gpu:3
#SBATCH --no-requeue
#SBATCH --exclude g0081
export MODULEPATH=/dat01/paraai_test/software/modulefiles:$MODULEPATH
module   load   amber/18-impi17
#srun pmemd.cuda -O -i wat_md.in -o wat_md2.log -c wat_md1.rst -p 5dn9-C23S-NADH_solv.prmtop -r wat_md2.rst -ref wat_md1.rst 
srun -n 30 pmemd.cuda.MPI -ng 30 -groupfile remd2.groupfile
