function decimalSeparator = detectDecimalSeparator(inputFile)

    % Step 1: Read a few lines to detect the decimal separator
    fid = fopen(inputFile, 'r');
    numLinesToCheck = 100; % Number of lines to read
    lines = cell(numLinesToCheck, 1);
    for i = 1:numLinesToCheck
        lines{i} = fgetl(fid);
        if ~ischar(lines{i}), break; end % Stop if EOF is reached
    end
    fclose(fid);
    
    % Step 2: Detect the decimal separator
    sampleText = strjoin(lines, ' ');
    if contains(sampleText, ',') && ~contains(sampleText, '.') % Only commas
        decimalSeparator = ','; % Likely a decimal separator
    else % If there are both dots and commas therefore the comma is the delimiter and the dot is the decimal separator        
        decimalSeparator = '.';
    end

end