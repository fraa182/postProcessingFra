function d = computeSignedDistance(x,y,x1,y1,x2,y2)

    d = ((x2 - x1) .* (y - y1) - (y2 - y1) .* (x - x1)) ./ sqrt((x2 - x1).^2 + (y2 - y1).^2);

end