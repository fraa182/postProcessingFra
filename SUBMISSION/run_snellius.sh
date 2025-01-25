#!/bin/sh

#SBATCH --job-name=Fan
#SBATCH --partition=genoa
#SBATCH --account=tdsei5714
#SBATCH --time=120:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=192
#SBATCH --mail-user=francesco.bellelli@polito.it
#SBATCH --mail-type=ALL

# CASE SETTINGS
discretize=true # true if discretization should be performed (otherwise anything else)
decompose=true # true if decomposition should be performed (otherwise anything else)
simulate=true # true if simulation should be performed (otherwise anything else), simulate cannot be combined with resume
resume=false # true if another simulation should be resumed (otherwise anything else), resume cannot be combined with simulate, checkpoint file with same filename is required
seeded=false # true if seeding from a fluid results file should be performed (otherwise anything else), only applies if simulate is set to true
seedname=seed_file_name # filename of the fnc file for seeding WITHOUT .ckpt.fnc EXTENSION

echo "== Run starting at $(date)"
echo "== Job ID: ${SLURM_JOBID}"
echo "== Node list: ${SLURM_NODELIST}"
echo "== Submit dir. : ${SLURM_SUBMIT_DIR}"

# Loading the license 
export EXACORP_LICENSE=27030@flexserv1.tudelft.nl;
export PATH=/gpfs/home4/apiccolo/6-2022R1/bin:$PATH;

EXA_QSYSTEM_DIR=slurm; export EXA_QSYSTEM_DIR
EXA_QSYSTEM_NAME=MySlurm; export EXA_QSYSTEM_NAME
EXA_PRINT_QSUB_CMD=1; export EXA_PRINT_QSUB_CMD

powerflowcpucount=$(($SLURM_JOB_NUM_NODES*$SLURM_NTASKS_PER_NODE-1))

exawatcher > logExawatcher &

# Discretize
if [ $discretize = true ]; then
  exaqsub -f --disc --slurm -nprocs ${SLURM_NTASKS_PER_NODE} --ib $(ls | grep .cdi) > logDisc 2>&1
fi

# Decompose
if [ $decompose = true ]; then
  exaqsub -f --decomp --slurm -nprocs $powerflowcpucount --ib $(ls | grep .cdi) > logDecomp 2>&1
fi

# Run
if [ $simulate = true ]; then
  if [ $seeded = true ]; then
    exaqsub -f --sim --slurm -nprocs $powerflowcpucount -ib --fluid_checkpoint_at_end --seed $seedname.ckpt.fnc $(ls | grep .cdi) > logSim 2>&1
  else
    exaqsub -f --sim --slurm -nprocs $powerflowcpucount -ib --fluid_checkpoint_at_end $(ls | grep .cdi) > logSim 2>&1
  fi
else
    exaqsub -f --resume --resume_file $(ls | grep .cdi).ckpt --slurm -nprocs $powerflowcpucount -ib --fluid_checkpoint_at_end $(ls | grep .cdi) > logSim 2>&1
fi

# Return error if both simulate and resume are true
if ([ $simulate = true ] && [ $resume = true ]); then
  echo Exiting runscript with error. Both simulate and resume are true.
  exit 1
fi
