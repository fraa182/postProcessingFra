function [xc,yc,zc] = centroid(~,y,z)

    [yb, zb] = calculateBoundary(y,z);
    [yb2, zb2] = resampleBoundary(yb, zb, 100);
    [centroidY, centroidZ] = calculateCentroid(yb2, zb2);

    xc = 0;
    yc = centroidY;
    zc = centroidZ;

end

function [yb, zb] = calculateBoundary(y,z)

    borderIdx = boundary(y,z,1);

    yb = y(borderIdx);
    zb = z(borderIdx);

end

function [yb2, zb2] = resampleBoundary(yb, zb, numPoints)

    % Compute the cumulative distance along the boundary
    distances = [0; cumsum(sqrt(diff(yb).^2 + diff(zb).^2))];

    % Create a vector of equally spaced distances
    equalDistances = linspace(0, distances(end), numPoints);

    % Interpolate to find the resampled points
    yb2 = interp1(distances, yb, equalDistances, 'linear');
    zb2 = interp1(distances, zb, equalDistances, 'linear');

    % Remove the last point to avoid duplication if the loop was closed
    yb2 = yb2(1:end-1);
    zb2 = zb2(1:end-1);

end

function [centroidY, centroidZ] = calculateCentroid(yb2, zb2)

    % Close the polygon loop by appending the first point at the end
    yb2 = [yb2 yb2(1)];
    zb2 = [zb2 zb2(1)];

    % Compute the signed area of the polygon
    A = 0.5 * sum(yb2(1:end-1) .* zb2(2:end) - yb2(2:end) .* zb2(1:end-1));

    % Compute the centroid coordinates
    centroidY = sum((yb2(1:end-1) + yb2(2:end)) .* (yb2(1:end-1) .* zb2(2:end) - yb2(2:end) .* zb2(1:end-1))) / (6 * A);
    centroidZ = sum((zb2(1:end-1) + zb2(2:end)) .* (yb2(1:end-1) .* zb2(2:end) - yb2(2:end) .* zb2(1:end-1))) / (6 * A);

end