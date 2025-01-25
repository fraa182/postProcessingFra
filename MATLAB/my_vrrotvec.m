function rotationAxisAngle = my_vrrotvec(currentAxis, targetAxis)

    % Normalize the input vectors
    currentAxis = currentAxis / norm(currentAxis);
    targetAxis = targetAxis / norm(targetAxis);
    
    % Compute the rotation axis using the cross product
    rotationAxis = cross(currentAxis, targetAxis);
    if norm(rotationAxis) ~= 0
        rotationAxis = rotationAxis / norm(rotationAxis);  % Normalize the rotation axis
    end
    % Compute the rotation angle using the dot product
    cosTheta = dot(currentAxis, targetAxis);
    rotationAngle = acos(cosTheta);  % Angle in radians
    
    % Output format compatible with vrrotvec (axis-angle format)
    rotationAxisAngle = [rotationAxis, rotationAngle];

end
