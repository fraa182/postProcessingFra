function varargout = extract_data(filename)
    
    data = readmatrix(filename);
    
    varargout = cell(1,nargout);
    for i = 1:nargout
        varargout{i} = data(:,i);
    end

end