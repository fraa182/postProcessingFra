#!/bin/sh

#SBATCH --job-name=LBM_PostProcessing
#SBATCH --partition=global
#SBATCH --time=05:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

echo "== Run starting at $(date)"
echo "== Job ID: ${SLURM_JOBID}"
echo "== Node list: ${SLURM_NODELIST}"
echo "== Submit dir. : ${SLURM_SUBMIT_DIR}"

# Loading the license 
export EXACORP_LICENSE=29000@srvdimeaslic.cdsdom.polito.it;
export PATH=/home/favallone/Solvers/PowerFLOW/6-2022-R2/bin:$PATH;

EXA_QSYSTEM_DIR=slurm; export EXA_QSYSTEM_DIR
EXA_QSYSTEM_NAME=MySlurm; export EXA_QSYSTEM_NAME
EXA_PRINT_QSUB_CMD=1; export EXA_PRINT_QSUB_CMD

# Define custom variables
nProbes=12
B=11

# Create the folders in which the data will be stored
mkdir 'FF probes'
mkdir 'blades'

# Rotor thrust and torque
echo "Blades loading"
exaritool forces.ri Composite_Meas_fan_torque.csnc -out blades/bladeForces.txt -sec -units mks -moment

# All far field direct probes
echo Probes
for i in $(seq 1 $nProbes); do
    echo Probe $i
    if [ $i -lt 10 ]; then
        file_name="probe_00${i}.pfnc"
    else
        file_name="probe_0${i}.pfnc"
    fi
    exaritool point-props.ri "$file_name" -avg -sec -units mks -out "FF probes/probe${i}.txt"
done

# Single blades thrust
echo Blade force
for i in $(seq 1 $B); do
    echo Blade $i
    exaritool forces.ri "Composite_Meas_fan_torque.csnc" -out "blades/blade$i.txt" -sec -units mks -name fan.Pala$i
done
