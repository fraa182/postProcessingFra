#!/bin/sh

#SBATCH --job-name=aziMOD
#SBATCH --partition=global
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mail-user=francesco.bellelli@polito.it
#SBATCH --mail-type=ALL

# Loading the license 
export EXACORP_LICENSE=29000@srvdimeaslic.cdsdom.polito.it;
export PATH=/home/favallone/Solvers/PowerFLOW/6-2022-R2/bin:$PATH;

EXA_QSYSTEM_DIR=slurm; export EXA_QSYSTEM_DIR
EXA_QSYSTEM_NAME=MySlurm; export EXA_QSYSTEM_NAME
EXA_PRINT_QSUB_CMD=1; export EXA_PRINT_QSUB_CMD

source /home/fbellelli/.bash_profile

odbmpirun -np 15 optydb_azi -i AziModalAnalysis.i > aziLog 2>&1