function rotationMatrix = my_vrrotvec2mat(rotationAxisAngle)

    % Extract the rotation axis and angle
    rotationAxis = rotationAxisAngle(1:3);
    angle = rotationAxisAngle(4);
    
    % Compute components for the rotation matrix
    ux = rotationAxis(1);
    uy = rotationAxis(2);
    uz = rotationAxis(3);
    cosA = cos(angle);
    sinA = sin(angle);
    
    % Construct the rotation matrix using the Rodrigues' rotation formula
    rotationMatrix = [
        cosA + ux^2 * (1 - cosA),      ux * uy * (1 - cosA) - uz * sinA,  ux * uz * (1 - cosA) + uy * sinA;
        uy * ux * (1 - cosA) + uz * sinA, cosA + uy^2 * (1 - cosA),      uy * uz * (1 - cosA) - ux * sinA;
        uz * ux * (1 - cosA) - uy * sinA, uz * uy * (1 - cosA) + ux * sinA, cosA + uz^2 * (1 - cosA)
    ];

end
