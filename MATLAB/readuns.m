function [x,y,z,p] = readuns(filename)

    fid = fopen(filename,'r');
    HeaderLines = 1;
    line = fgetl(fid);
    while ~strcmp(line,'Nodes')
        line = fgetl(fid);
        HeaderLines = HeaderLines + 1;
    end
    fclose(fid);

    data = readmatrix(filename,'FileType','text','NumHeaderLines',HeaderLines);
    
    numNodes = data(1,1);
    numBoundaryFaces = data(numNodes+3,1);
    
    nodes = data(2:numNodes+1,1:3);
    p = data(numNodes+2*numBoundaryFaces+6:end,1); p = p(1:numNodes);
    
    nodes = nodes(1:end/2,:); p = p(1:end/2);
    
    x = nodes(:,1);
    y = nodes(:,2);
    z = nodes(:,3);

end