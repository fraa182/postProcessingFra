#!/bin/bash

#PBS -j oe
#PBS -N Fan
#PBS -l nodes=5:ppn=96,walltime=72:00:00
#PBS -q fpt-large
#PBS -M francesco.bellelli@polito.it
#PBS -m abe

# CASE SETTINGS
discretize=true # true if discretization should be performed (otherwise anything else)
decompose=true # true if decomposition should be performed (otherwise anything else)
simulate=true # true if simulation should be performed (otherwise anything else), simulate cannot be combined with resume
resume=false # true if another simulation should be resumed (otherwise anything else), resume cannot be combined with simulate, checkpoint file with same filename is required
numbered_full_checkpoint=false # true if a full_ckptexit should be performed at a certain timestep, numbered_full_checkpoint cannot be combined with numbered_fluid_checkpoint
numbered_fluid_checkpoint=false # true if a fluid_ckptexit should be performed at a certain timestep, numbered_fluid_checkpoint cannot be combined with numbered_full_checkpoint
checkpoint_number=0 # timestep at which *_ckptexit should be performed
seeded=true # true if seeding from a fluid results file should be performed (otherwise anything else), only applies if simulate is set to true
seedname=seed_file_name # filename of the fnc file for seeding WITHOUT EXTENSION

export EXACORP_LICENSE=27030@flexserv1.tudelft.nl
export PATH=/home/everybody/PowerFLOW/6-2022-R3/bin:$PATH

set -e
echo Job started on `uname -n` at `date`
ulimit -a
cd $PBS_O_WORKDIR

source stopAction 3600 &

nprocsmaster=96 # number of cores reserved for the master process

nodes=($(cat $PBS_NODEFILE | sort -u -V))
nnodes=${#nodes[@]}
lasthost=${nodes[nnodes-1]}
lasthostcount=$(grep $lasthost $PBS_NODEFILE | wc -l)
if (( lasthostcount < nprocsmaster ))
then
    nprocsmaster=$lasthostcount
fi
(
    for ((i=0; i<nnodes; i++))
    do
        host="${nodes[i]}"
        count=$(grep $host $PBS_NODEFILE | wc -l)
        if (( i == nnodes-1 ))
        then
            if (( count == nprocsmaster ))
            then
                echo cp $host
            else
                echo $((count-nprocsmaster)) $host
                echo cp $host
            fi
        else
            echo $count $host
        fi
    done
) > $PBS_JOBID.mpifile
totalcpucount=$(cat $PBS_NODEFILE | wc -l)
powerflowcpucount=$((totalcpucount-nprocsmaster))

exawatcher > log_exawatcher &

# Discretize
if [ $discretize = true ]; then
  exaqsub -f --disc -nprocs $powerflowcpucount -mpirsh rsh -mpifile $PBS_JOBID.mpifile $(ls | grep .cdi) > log_disc 2>&1
fi

# Decompose
if [ $decompose = true ]; then
  exaqsub -f --decomp -nprocs $powerflowcpucount -mpirsh rsh -mpifile $PBS_JOBID.mpifile $(ls | grep .cdi) > log_decomp 2>&1
fi

# Simulate if either simulate or resume is true
if ([ $simulate = true ] || [ $resume = true ]) && ! ([ $simulate = true ] && [ $resume = true ]); then
  # Set numbered checkpoint (sleep 120 seconds for simulation to start before issuing)
  if ([ $numbered_full_checkpoint = true ] || [ $numbered_fluid_checkpoint = true ]) && ! ([ $numbered_full_checkpoint = true ] && [ $numbered_fluid_checkpoint = true ]); then
    if [ $numbered_full_checkpoint = true ]; then
      (sleep 120 && exasignal --full_ckptexit $checkpoint_number) &
    elif [ $numbered_fluid_checkpoint = true ]; then
      (sleep 120 && exasignal --fluid_ckptexit $checkpoint_number) &
    fi
  elif ([ $numbered_full_checkpoint = true ] && [ $numbered_fluid_checkpoint = true ]); then
    echo Exiting runscript with error. Both numbered_full_checkpoint and numbered_fluid_checkpoint are true.
    exit 1
  fi

  # Run
  if [ $simulate = true ]; then
    if [ $seeded = true ]; then
      exaqsub -f --sim -nprocs $powerflowcpucount -mpirsh rsh -mpifile $PBS_JOBID.mpifile -ib --fluid_checkpoint_at_end --seed $seedname.ckpt.fnc $(ls | grep .cdi) > log_sim 2>&1
    else
      exaqsub -f --sim -nprocs $powerflowcpucount -mpirsh rsh -mpifile $PBS_JOBID.mpifile -ib --fluid_checkpoint_at_end $(ls | grep .cdi) > log_sim 2>&1
    fi
  else
      exaqsub -f --resume --resume_file $(ls | grep .cdi).ckpt -nprocs $powerflowcpucount -mpirsh rsh -mpifile $PBS_JOBID.mpifile -ib --fluid_checkpoint_at_end $(ls | grep .cdi) > log_sim 2>&1
  fi

# Return error if both simulate and resume are true
elif ([ $simulate = true ] && [ $resume = true ]); then
  echo Exiting runscript with error. Both simulate and resume are true.
  exit 1
fi
