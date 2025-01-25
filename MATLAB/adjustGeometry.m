function [xAllNew,yAllNew,zAllNew] = adjustGeometry(xAll,yAll,zAll)
    
    % Define target axis pointing along negative x-axis
    targetAxis = [-1, 0, 0];  % Negative x-direction
    
    % Calculate current axis
    coeff = pca([xAll yAll zAll]);
    currentAxis = coeff(:,3);
    
    % Calculate rotation vector and angle
    rotationAxisAngle = my_vrrotvec(currentAxis, targetAxis);
    
    % Create a rotation matrix
    rotationMatrix = my_vrrotvec2mat(rotationAxisAngle);
    
    % Rotate vertices
    rotatedVertices = (rotationMatrix * [xAll yAll zAll]')';
    
    xAllNew = rotatedVertices(:,1); yAllNew = rotatedVertices(:,2); zAllNew = rotatedVertices(:,3);

end