surfaceNoiseMap ...................... Case name
# FLUID/FLOW SECTION ==================
101325.0 .............................. Ambient pressure (Pa)
1.184 ................................. Ambient density (kg/m^3)
1.4 ................................... Gas specific heats ratio
287.055 ............................... Gas constant (J/kg/K)
0.0 .................................. Relative humidity (%)
0.0 ................................... Surface velocity along x (m/s) [Typically -U_free-stream]
0.0 ................................... Surface velocity along y (m/s)
0.0 ................................... Surface velocity along z (m/s)
# SOURCE SECTION ======================
fan_surface_trans_db_maps.snc .... snc file name
0 ................................... Number of PIDs used for the FW-H integration [0: all PIDs used; <N>: the following list of <N> PID weight, name and group is used]
F ..................................... Separate thickness/loading noise contributions
F ..................................... Reflection
F ..................................... Reflection plane definition from external file
dummy.txt ............................. Reflection plane file
 0.10000E+01 .......................... Reflection coefficient
 0.00000E+00 .......................... Coordinate of one point on the reflection plane along x (m)
 0.00000E+00 .......................... Coordinate of one point on the reflection plane along y (m)
-1.00000E+00 .......................... Coordinate of one point on the reflection plane along z (m)
 0.00000E+00 .......................... Normal to the reflection plane along x
 0.00000E+00 .......................... Normal to the reflection plane along y
 1.00000E+00 .......................... Normal to the reflection plane along z
# MICROPHONE SECTION ==================
mics.txt .............................. FW-H microphones file
6000 .................................. FW-H Microphones file format [2000: Tecplot; 5000: UCD; 6000: Polyline; -1000: Computed polar arc; -3000: Computed hemi-sphere]
0.0 ................................... Microphone velocity along x (m/s) [Typically -U_free-stream]
0.0 ................................... Microphone velocity along y (m/s)
0.0 ................................... Microphone velocity along z (m/s)
# SPECTRAL ANALYSIS SECTION ===========
130.0 ................................. Bandwidth (Hz)
430.0 ................................. Minimum frequency (Hz)
2500.0 ............................... Maximum frequency (Hz)
1000 .................................. Band type [1000: Constant; 2000: 1/3rd-Octave; 3000: 1/12th-Octave]
-0.5 .................................. Window overlap coefficient [negative value for optimal refinement]
430.0 ................................ Minimum frequency for source map generation (Hz)
2500.0 ............................... Maximum frequency for source map generation (Hz)
1000 .................................. Band type for source map generation [1000: Constant; 2000: 1/3rd-Octave; 3000: 1/12th-Octave]
1.0 ................................... Tukey window coefficient [0: rectangular, 1: Hanning]
1 ..................................... First frame used for the FW-H computation (starting from 1)
# GRAPHIC VISUALIZATION SECTION =======
dummy ................................. SPL visualization file
4000 .................................. SPL visualization file format [1000: Fieldview; 2000: Tecplot; 4000: VTK; 7000: CGNS; 15000 P-F-exp]
# SYSTEM SECTION ======================
50.0 ................................. Available RAM per node (GBytes)
























































