function [] = pfSliceToVtk(foldername,fileName)

    % Data extraction
    [x,y,z,u] = extract_signal([foldername,'/',fileName,'.txt'],16);
    r = mean(sqrt(y.^2+z.^2));
    yy = 2*pi*r*(0:length(x))/length(x);
    
    % File name
    vtkFileName = [foldername,'/',fileName,'.vtk'];
    
    % Open file for writing
    fid = fopen(vtkFileName, 'w');
    
    % Write header
    fprintf(fid, '# vtk DataFile Version 3.0\nAxial Velocity TS\nASCII\n');
    
    % Write points
    fprintf(fid, 'DATASET UNSTRUCTURED_GRID\nPOINTS %d float\n', numel(x));
    for i = 1:numel(x)
        fprintf(fid, '%f %f 0.0\n', x(i), yy(i));
    end
    
    % Write point data
    fprintf(fid, 'POINT_DATA %d\nSCALARS AxialVelocity float\nLOOKUP_TABLE default\n', numel(u));
    
    for i = 1:numel(u)
        fprintf(fid, '%f\n', u(i));
    end
    
    % Close the file
    fclose(fid);

end
