import os

def sampleScalarProfile(scalarVariableName, referenceGeometry1, coordSystem1, project):

    # Acquisition of the scalar property along the sampling line
    fluidPoint1=project.new(type="FluidPoint")
    fluidPoint1.referenceGeometry=referenceGeometry1
    fluidPoint1.sampleLineActivate=True
    scalarPropertySet1=project.get(name=scalarVariableName, type="ScalarPropertySet")
    fluidPoint1.sampleLineSPS=scalarPropertySet1
    xYGraph=fluidPoint1.sampleGraph

    scalarMean = [0] * 100
    for theta in range(0,360):

        # Deleting the ".txt" files (if exist)
        if os.path.exists("scalarValues/scalar_"+str(theta)+"deg.txt"):

            os.remove("scalarValues/scalar_"+str(theta)+"deg.txt")

        # Rotating the sampling line
        referenceGeometry1.eulerAngles=( (theta, 0, 0), "deg")

        # Exporting the scalar property along the sampling line
        xYGraph.export2DAscii(filename="scalarValues/scalar_"+str(theta)+"deg.txt")

        # Importing the scalar property along the sampling line in Python
        r = []
        scalar = []
        with open("scalarValues/scalar_"+str(theta)+"deg.txt","r") as scalarFile:

            lines = scalarFile.readlines()
            for line in lines:

                columns = line.split()
                if len(columns) != 2:

                        continue

                else:

                    r.append(float(columns[0]))
                    scalar.append(float(columns[1]))

            # Adding the scalar property along the sampling line
            scalarMean = [scalarMeanValue + scalarValue for scalarMeanValue, scalarValue in zip(scalarMean, scalar)]

    # Mean
    scalarMean = [scalarMeanValue/360 for scalarMeanValue in scalarMean]

    # Deleting the ".txt" file (if exists)
    if os.path.exists(scalarVariableName+".txt"):

        os.remove(scalarVariableName+".txt")

    # Writing the final output to text file
    with open(scalarVariableName+".txt","w") as scalarMeanFile:

        for i in range(len(r)):

            scalarMeanFile.write(str(r[i]) + " " + str(scalarMean[i]) + "\n")

    return

def bladeLoadingDistribution(project, eulX=-90, eulY=-80, eulZ=90):

    # Acquisition of surface thrust 
    bladeLoading=project.newScalarPropertySet(makeCurrent=True)
    VARbladeLoading=project.get(name="Surface X-Force", type="ScalarVariable")
    bladeLoading.variable=VARbladeLoading

    # Creation of the force development on blade 9 (most loaded blade) with 25 segments aligned to the blade
    forceDevelopment=project.new(type="ForceDevelopment")
    forceDevelopment.adaptSizeToMeasurement=True
    forceDevelopment.partsAndFaces=[]
    forceDevelopment.baseFileMode="Include Selected"
    face16=project.getEntityByPath("/fan::pala9")
    forceDevelopment.partsAndFaces=[face16]
    forceDevelopment.position=( (-0.04, 0, 0.09337429999999999), "m")
    forceDevelopment.numSegmentsIntegralFiles=25
    xYGraph19=forceDevelopment.graph
    graphAxis55=xYGraph19.xAxis
    graphAxis55.unit=["Length","m"]
    graphAxis56=xYGraph19.y1Axis
    graphAxis56.unit=["Force","newton"]
    onScreenGraph5=forceDevelopment.onScreenGraph
    onScreenGraph5.yAxisRange=( (0, 0), "newton")
    onScreenGraph5.y2AxisRange=(3.402823e+38, -3.402823e+38)
    forceDevelopment.unitSet="mks"
    forceDevelopment.displayMode="Per Segment"
    forceDevelopment.orientationMode="Free"
    forceDevelopment.eulerAngles=( (eulX, eulY, eulZ), "deg")

    # Showing only the thrust
    forceDevelopment.showGreenForce=False
    forceDevelopment.showBlueForce=True
    forceDevelopment.showRedForce=False

    # Calculation of the force development
    forceDevelopment.calc(baseFileMode="Include Selected", partsAndFaces=[face16])

    # Deleting the file if exists
    if os.path.exists("bladeLoadingDistrib.txt"):
    
            os.remove("bladeLoadingDistrib.txt")

    # Saving the blade loading distribution on a ".txt" file
    xYGraph19.export2DAscii(filename="bladeLoadingDistrib.txt")

    return

def postProcessingRoutine(saveFlag,initFlag,slicesFlag,WallPressureFluctuationsFlag,Lambda2Flag,vr_vt_Flag,velocityProfilesFlag,pressureProfilesFlag, bladeLoadingDistributionFlag, eulX=-90, eulY=-80, eulZ=90):

    # Opening the project
    project=app.currentProject

    if initFlag:

        # Visual settings
        project.boundingBoxDisplay="Hide"
        viewerBackground3=project.get(name="ViewerBackground3", type="ViewerBackground")
        viewerBackground3.color="#ffffff"
        colorMap=project.get(name="Divergence Red-Blue", type="ColorMap")
        viewer=project.getViewer(0)
        viewer.enableOrientationCross=False

        # Acquisition of mean velocity magnitude
        velMagnMean=project.get(name="Velocity Magnitude", type="ScalarPropertySet")
        velMagnMean.colorMap=colorMap
        velMagnMean.unit="dimlessVelocity"
        velMagnMean.range=( (0, 0.4), "dimlessVelocity")

        # Acquisition of mean axial velocity
        xVelMean=project.get(name="X-Velocity", type="ScalarPropertySet")
        xVelMean.colorMap=colorMap
        xVelMean.unit="dimlessVelocity"
        xVelMean.range=( (-0.13, 0.34), "dimlessVelocity")

        # Acquisition of rms of axial velocity
        xVelRMS=project.newScalarPropertySet(makeCurrent=True)
        VARxVelRMS=project.get(name="Std Dev X-Velocity", type="ScalarVariable")
        xVelRMS.variable=VARxVelRMS
        xVelRMS.colorMap=colorMap
        xVelRMS.unit="dimlessVelocity"
        xVelRMS.range=( (0, 0.13), "dimlessVelocity")

        if WallPressureFluctuationsFlag:

            # Acquisition of rms of wall pressure
            wallPressureRMS=project.newScalarPropertySet(makeCurrent=True)
            VARwallPressureRMS=project.get(name="Std Dev Pressure", type="ScalarVariable")
            wallPressureRMS.variable=VARwallPressureRMS
            wallPressureRMS.unit="dimlessDynamicPressure"
            wallPressureRMS.range=( (0, 0.06), "dimlessDynamicPressure")
            wallPressureRMS.colorMap=colorMap

        if Lambda2Flag:

            # Acquisition of Lambda2
            Lambda2=project.newScalarPropertySet(makeCurrent=True)
            VARLambda2=project.get(name="Lambda2", type="ScalarVariable")
            Lambda2.variable=VARLambda2

        if vr_vt_Flag:

            # Calculation of radial and tangential velocity
            equation=project.newEquation()
            equation.load(filename="/home/fbellelli/vt_vr.eqn")
            equation.check(text="theta = atan2(z,y);\n\nvr = y_velocity*cos(theta) + z_velocity*sin(theta);\n\nvt = z_velocity*cos(theta) - y_velocity*sin(theta);")
            equation.variables=[]
            equation.calculateAllKeepUnits()

            # Acquisition of mean radial velocity
            vrMean=project.get(name="vr", type="ScalarPropertySet")
            vrMean.colorMap=colorMap
            vrMean.unit="dimlessVelocity"
            vrMean.range=( (-0.2, 0.2), "dimlessVelocity")

            # Acquisition of mean tangential
            vtMean=project.get(name="vt", type="ScalarPropertySet")
            vtMean.colorMap=colorMap
            vtMean.unit="dimlessVelocity"
            vtMean.range=( (-0.2, 0.2), "dimlessVelocity")
    
    if slicesFlag:

       # Creating the mean axial velocity slice (lateral)
        slice1=project.new(type="Slice")
        slice1.visibility="Hide Bounding Box"
        slice1.imageSPS=xVelMean
        slice1.orientationMode="Y-Aligned"
        slice1.position=( (-0.04, 0, 0), "m")
        slice1.sizeCustomize=True
        slice1.size=( (0.5, 0.75, 0.1), "m")
        slice1.streamlinesEnabled=True
        slice1.streamlinesNumberOfParticles=1000
        slice1.streamlinesSpacing=(0.01, "m")
        slice1.streamlinesWidth=2
        slice1.streamlinesArrowStyle="Line"
        slice1.streamlinesArrowSize=(0.005, "m")
        slice1.streamlinesArrowSpacing=(0.5968534, "m")
        slice1.streamlinesCalculate()

        if saveFlag:

            # Hiding everything but fan and shroud
            project.setUpdateEnabledAllViewers(0)
            baseAssembly1=project.baseAssembly
            modelView1=baseAssembly1.defaultModelView
            segment1=baseAssembly1.rootSegment
            modelViewObject140=modelView1.getModelViewObject(segment1)
            modelViewObject140.displayMode="Hidden"
            project.setUpdateEnabledAllViewers(1)
            project.setUpdateEnabledAllViewers(0)
            modelViewObject140.setSubtreeProperty(property="displayMode", value="KeepCurrentSetting")
            project.setUpdateEnabledAllViewers(1)
            project.setUpdateEnabledAllViewers(0)
            part5=project.getEntityByPath("/fan")
            modelViewObject145=modelView1.getModelViewObject(part5)
            modelViewObject145.displayMode="Solid"
            project.setUpdateEnabledAllViewers(1)
            part32=project.getEntityByPath("/shroud")
            modelViewObject172=modelView1.getModelViewObject(part32)
            modelViewObject172.displayMode="Solid"
            project.setUpdateEnabledAllViewers(1)

            # Creating clipping plane
            clipPlane2=project.new(type="ClipPlane")
            clipPlane2.planeShow=False
            clipPlane2.crossShow=False
            clipPlane2.orientationMode="Z-Aligned"
            clipPlane2.position=( (0, 0, 0), "m")

            # Setting the viewer
            viewer1=project.getViewer(0)
            viewer1.setOrientation("+Y")
            camera1=viewer1.camera
            coordSystem1=project.get(name="default_csys", type="CoordSystem")
            camera1.setView(position=(-0.06500005, -1.018518, -7.450581e-08), viewDirection=(6.181725e-08, 1, 5.960464e-08), upDirection=(1.4924e-07, -5.960465e-08, 1), coordinateSystem=coordSystem1, positionUnits="m", projectionType="Orthographic", orthographicFieldOfView=0.6111111, perspectiveFieldOfView=0.6)
            camera1.zoomToFit(project=project)

            # Saving the image
            camera1.saveImage(filename="slice lat.png", size=(1290, 1290))
            slice1.visibility="Hide All"

        # Creating the axial velocity rms slice (front)
        slice2=project.new(type="Slice")
        slice2.visibility="Hide Bounding Box"
        slice2.imageSPS=xVelRMS
        slice2.orientationMode="X-Aligned"
        slice2.position=( (-0.065, 0, 0), "m")
        slice2.sizeCustomize=True
        slice2.size=( (0.55, 0.55, 0.1), "m")
        slice2.contourLinesEnabled=True
        slice2.contourLinesSPS=VARxVelRMS

        if saveFlag:
    
            # Setting the viewer
            viewer1.setOrientation("+X")
            camera1.setView(position=(-1.07601, -4.452087e-08, -5.197145e-08), viewDirection=(1, 0, 4.371139e-08), upDirection=(-4.371139e-08, -4.371139e-08, 1), coordinateSystem=coordSystem1, positionUnits="m", projectionType="Orthographic", orthographicFieldOfView=0.6111111, perspectiveFieldOfView=0.6)
            camera1.zoomToFit(project=project)

            # Saving the image
            camera1.saveImage(filename="slice front.png", size=(1290, 1290))
            slice2.visibility="Hide All"

        # Creating the mean axial and radial velocity slice (lateral - zoom)
        slice3=project.new(type="Slice")
        slice3.visibility="Hide Bounding Box"
        slice3.imageSPS=xVelMean
        slice3.orientationMode="Y-Aligned"
        slice3.position=( (-0.04, 0, 0.25), "m")
        slice3.sizeCustomize=True
        slice3.size=( (0.1, 0.1, 0.1), "m")
        slice3.streamlinesEnabled=True
        slice3.streamlinesNumberOfParticles=1000
        slice3.streamlinesSpacing=(0.0025, "m")
        slice3.streamlinesWidth=2
        slice3.streamlinesArrowStyle="Line"
        slice3.streamlinesArrowSize=(0.0025, "m")
        slice3.streamlinesArrowSpacing=(0.5968534, "m")
        slice3.streamlinesCalculate()

        if saveFlag:

            # Setting the viewer
            viewer1.setOrientation("+Y")
            camera1.setView(position=(-0.04077074, -0.1913415, 0.2504658), viewDirection=(6.181725e-08, 1, 5.960464e-08), upDirection=(1.4924e-07, -5.960465e-08, 1), coordinateSystem=coordSystem1, positionUnits="m", projectionType="Orthographic", orthographicFieldOfView=0.1148049, perspectiveFieldOfView=0.6)

            # Saving the image
            camera1.saveImage(filename="zoom slice lat.png", size=(1290, 1290))
            slice3.imageSPS=vrMean
            camera1.saveImage(filename="vr zoom slice lat.png", size=(1290, 1290))

    if WallPressureFluctuationsFlag:

        # Creating the wall pressure rms image (surface)
        surfaceImage1=project.get(name="Surface Image", type="SurfaceImage")
        surfaceImage1.scalarPropertySet=wallPressureRMS
        surfaceImage1.complexity="Surfel"

    if Lambda2Flag:

        # Creating Lambda2 isosurfaces colored with velocity magnitude
        isosurface1=project.new(type="Isosurface")
        isosurface1.useWholeVolume=False
        isosurface1.visibility="Hide Bounding Box"
        isosurface1.position=( (-0.075, 0, 0), "m")
        isosurface1.size=( (0.06, 0.6, 0.6), "m")
        isosurface1.isoSPS=Lambda2
        isosurface1.isoValue=(-250000, "1/sec^2")
        isosurface1.lookFixed=False
        isosurface1.calculate()

        if saveFlag:

            # Setting the viewer
            baseAssembly1=project.baseAssembly
            modelView1=baseAssembly1.defaultModelView

            part53=project.getEntityByPath("/wall")
            modelViewObject193=modelView1.getModelViewObject(part53)
            modelViewObject193.displayMode="Hidden"

            part54=project.getEntityByPath("/radiator")
            modelViewObject194=modelView1.getModelViewObject(part54)
            modelViewObject194.displayMode="Hidden"

            part55=project.getEntityByPath("/cappaDx")
            modelViewObject195=modelView1.getModelViewObject(part55)
            modelViewObject195.displayMode="Hidden"

            part56=project.getEntityByPath("/cappaSx")
            modelViewObject196=modelView1.getModelViewObject(part56)
            modelViewObject196.displayMode="Hidden"

            part57=project.getEntityByPath("/motor")
            modelViewObject197=modelView1.getModelViewObject(part57)
            modelViewObject197.displayMode="Hidden"

            coordSystem1=project.get(name="default_csys", type="CoordSystem")
            viewer1=project.getViewer(0)
            viewer1.setOrientation("+X")
            camera1=viewer1.camera
            camera1.setView(position=(-1.744813, 2.453104e-06, -0.01510591), viewDirection=(1, 0, 4.371139e-08), upDirection=(-4.371139e-08, -4.371139e-08, 1), coordinateSystem=coordSystem1, positionUnits="m", projectionType="Orthographic", orthographicFieldOfView=0.9900381, perspectiveFieldOfView=0.6)
            camera1.zoomToFit(project=project)

            # Deleting the image if exists
            if os.path.exists("lambda 2 casing.png"):
            
                    os.remove("lambda 2 casing.png")

            # Saving the image
            camera1.saveImage(filename="lambda 2 casing.png", size=(1290, 1290))

    if velocityProfilesFlag:

        # Importing the sampling line
        referenceGeometry1=project.newReferenceGeometry(name="ReferenceGeometry1")
        coordSystem1=project.get(name="default_csys", type="CoordSystem")
        referenceGeometry1.createGeometry(args={"filename":"/home/fbellelli/downstreamVelocitySamplingLine.LIN","lengthUnit":0}, coordinateSystem=coordSystem1, definedVia="Filename", invertNormals=False, type="File")

        # Calling the routine to obtain the velocity profiles for axial, radial, and tangential velocity
        sampleScalarProfile("X-Velocity", referenceGeometry1, coordSystem1, project)

        if vr_vt_Flag:

            sampleScalarProfile("vr", referenceGeometry1, coordSystem1, project)
            sampleScalarProfile("vt", referenceGeometry1, coordSystem1, project)

    if pressureProfilesFlag:

        if not(velocityProfilesFlag):

            # Importing the sampling line
            referenceGeometry1=project.newReferenceGeometry(name="ReferenceGeometry1")
            coordSystem1=project.get(name="default_csys", type="CoordSystem")
            referenceGeometry1.createGeometry(args={"filename":"/home/fbellelli/upstreamVelocitySamplingLine.LIN","lengthUnit":0}, coordinateSystem=coordSystem1, definedVia="Filename", invertNormals=False, type="File")

        # Calling the routine to obtain the pressure profile
        sampleScalarProfile("Static Pressure", referenceGeometry1, coordSystem1, project)

    if bladeLoadingDistributionFlag:

        bladeLoadingDistribution(project, eulX, eulY, eulZ)

    return

def main():

    # Flags setting
    initFlag = 1
    slicesFlag = 1
    WallPressureFluctuationsFlag = 0
    Lambda2Flag = 0
    vr_vt_Flag = 1
    velocityProfilesFlag = 0
    pressureProfilesFlag = 0
    bladeLoadingDistributionFlag = 0
    saveFlag = 1

    # Calling post processing routine 
    postProcessingRoutine(saveFlag, initFlag, slicesFlag, WallPressureFluctuationsFlag, Lambda2Flag, vr_vt_Flag, velocityProfilesFlag, pressureProfilesFlag, bladeLoadingDistributionFlag)

    return

main()
