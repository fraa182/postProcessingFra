function numHeaders = countHeaderLines(filename)

    data = readmatrix(filename,'Delimiter',' ');

    numHeaders = find(all(isnan(data),2),1,'last');

end
