#!/bin/sh

#SBATCH --job-name=exportSimData
#SBATCH --partition=global
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16

## Prepare the environment setup ##

# Source bash_profile to load the license, define exa variables and OptydB environment
source /home/fbellelli/.bash_profile

# Define case variables
fanName=anValEven
caseName=freeBlowing

# Define custom variables
nProbes=12
B=11
NF=950
interval_Frames=5

# Create the surface pressure folder in which the uns file will be stored
mkdir loading

## Extract mean surface pressure for each blade ##
echo Mean pressure
for b in $(seq 1 $B); do
    pf2fv -A -b "$fanName"_"$caseName"_b"$b"_avgP -v p:Pa -i fan.Pala$b mean_flow.snc > logConv_avg_blade$b
done

## Compute the phase averaged surface pressure field ##
echo Phase average
odbmpirun -np 15 optydb_phaselock -i fan_surface_trans_db_maps.snc -o fan_surface_trans_db_maps -s -0.019685039

## Extract the phase averaged surface pressure field for each blade and each frame ##
echo Instantaneous pressure
for b in $(seq 1 $B); do
    pf2fv -A -b "$fanName"_"$caseName"_b"$b"_ts -v p:Pa --first 0 --last $NF --interval $interval_Frames -i fan.Pala$b fan_surface_trans_db_maps_avg.snc > logConv_blade$b
done

# Move all the uns surface pressure files in the ad-hoc folder
mv *.uns loading

## Extract the mean flow field ##
echo Velocity fields
powerviz "$(ls | grep .cdi)" mean_flow.fnc --nprocs 15 --no_display --no-splash-screen ../extractVelocity.py

## Extract the simulation data ##

# Create the folders in which the data will be stored
mkdir "FF probes"
mkdir "blades"

# Rotor thrust and torque
echo Blades loading
exaritool forces.ri "Composite_Meas_fan_torque.csnc" -out "blades/bladeForces.txt" -sec -units mks -moment

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