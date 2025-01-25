#!/bin/bash

# The present script aims to automatically submit multiple jobs in a serial manner on a PBS-based cluster.
# Run the script as follows:
#     source complete_sim_run.sh jobID_init scriptName1 scriptName2 ... scriptNameN > complete_sim_run.log 2>&1 & disown
# Where:
# 1) jobID_init is the job ID of a previous running job that needs to finish before running the first job
# 2) scriptName1 ... scriptNameN are the names of the script to be executed after the previous running job (they must be correctly sorted)
# NOTE: If there's no previous running job then simply put 0 to skip the initial check
# NOTE: A file ".log" will store both the stdout and stderr in order to monitor the prosecution of the script after terminal detach

# We store the job ID of the currently running job
jobID_init=$1
shift

# We store all remaining arguments (script names) in an array
scripts=($@)

# We wait until the previous running job is finished. While job exists, we wait a minute before checking again
echo "Waiting until previous running job has finished ..."
while [ `qstat $jobID_init | wc -l` -gt 2 ]
do
    sleep 1m
done
echo "Previous running job finished at `date` with jobID $jobID_init"

# We loop through all script names
for scriptName in "${scripts[@]}"
do
    echo "Running job $scriptName ..."
    jobID=$(qsub $scriptName.sh)
    # We wait until the job is finished. While job exists, we wait a minute before checking again
    echo "Waiting until the job $scriptName is finished ..."
    while [ `qstat $jobID | wc -l` -gt 2 ]
    do
        sleep 1m
    done
    echo "$scriptName job finished at `date` with jobID $jobID"
done