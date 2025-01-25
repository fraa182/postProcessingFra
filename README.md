# postProcessingFra

This GitHub repository stores (mostly) all the scripts that I've been using for post processing during my PhD at PoliTO within the Aeroacoustics section of the Flow Control and Aeroacoustics Research group (https://flowcontrol.polito.it/wp/).
My PhD focused on Computational Aeroacoustics of low-speed axial fans in installed conditions. CFD simulations were performed with the LBM commercial code PowerFLOW®. The post processing was performed through MATLAB® scripts.

Refer here for my current publications: https://scholar.google.com/citations?user=RtV0SxMAAAAJ&hl=it

You'll find 4 different folders:
- MATLAB: Scripts I used to post process the simulation data
- POWERVIZ: Scripts I used to automatically do slices, contours, and animations on my simulations. PowerVIZ scripts are written in python.
- POWERFLOW: Scripts I used to automatically retrieve further simulation data with the command line tools of PowerFLOW (exaritool, exa_meas_copy, etc.). I mainly used them to perform the first step of post processing right after the simulation finished.
- SUBMISSION: Scripts I used to submit PowerFLOW simulations on the different HPC I've been using. They're based both on SLURM and PBS scheduling manager systems.

### NOTE
Please don't just copy-paste the scripts and use them blindfold, but make sure to adapt them to your required workflow. They should be robust but you might need to change some parameters/configurations, be aware!
