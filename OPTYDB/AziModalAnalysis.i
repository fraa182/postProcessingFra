ModalUp ....... Case name
# FLUID/FLOW SECTION ==============
100925.0 .......................... Ambient pressure (Pa)
1.179 ............................. Ambient density (kg/m^3)
1.4 ............................... Gas specific heats ratio
287.05449774724229 ................ Gas constant (J/kg/K)
# SIGNAL SECTION ==================
modalPlane.snc ..................... snc file
0 ................................. Number of PIDs used for the azimuthal analysis (0: all PIDs used; <N>: the following list of <N> PIDs names is used)
# SPECTRAL ANALYSIS SECTION =======
10 .......................... Bandwidth (Hz)
250 .......................... Minimum frequency (Hz)
2105 .......................... Maximum frequency (Hz)
1000 .............................. Band type [1000: Constant; 2000: 1/3rd-Octave; 3000: 1/12th-Octave]
0.5 .............................. Window overlap coefficient (negative value for optimal refinement)
1.0 ............................... Tukey window coefficient (0: rectangular, 1: Hanning)
1 ................................. First frame used for the FFT analysis
-15 ............................... Minimum azimuthal mode order
 15 ............................... Maximum azimuthal mode order
# CYLINDRICAL MESH SECTION ========
azimuthal_modes_planeUp ....... Azimuthal modes visualization file
4000 .............................. Azimuthal modes visualization file format [1000: Fieldview; 2000: Tecplot; 4000: VTK; 7000: CGNS; 15000 P-F-exp]
-0.075 ............................... x-coordinate of the origin of the x-axis of the cylindrical reference system
0.0 ............................... y-coordinate of the origin of the x-axis of the cylindrical reference system
0.0 ............................... z-coordinate of the origin of the x-axis of the cylindrical reference system
-1.0 ............................... x-component of the unit normal vector (m)
0.0 ............................... y-component of the unit normal vector (m)
0.0 ............................... z-component of the unit normal vector (m)
0.0 ............................... x-component of the unit tangential vector
-1.0 ............................... y-component of the unit tangential vector
0.0 ............................... z-component of the unit tangential vector
1 ................................. Number of projection points in the axial direction
10 ................................ Number of projection points in the radial direction
36 ............................... Number of projection points in the azimuthal direction
# DUCT MODAL ANALYSIS =============
T ................................. Perform duct modal analysis
-1.0 .............................. Duct minimum radius (< 0: extracted from imported section)
-1.0 .............................. Duct maximum radius (< 0: extracted from imported section)
0.0 0.0 ........................... Non-dimensional wall admittance at minimum radius
0.0 0.0 ........................... Non-dimensional wall admittance at maximum radius
5 ................................. Maximum radial mode order
-1.0 .............................. Sign of axial mode propagation with respect to the flow direction
0.001 .............................. Mimimum relative radius for acoustic duct modes computation
0.999 .............................. Maximum relative radius for acoustic duct modes computation
T ................................. Cut-on modes only
2 ................................. Number of frequencies
525.8
1051.6