function A = A_from_f(f)

    % A-weighting filter coefficients
    c1 = 12194.217^2;
    c2 = 20.598997^2;
    c3 = 107.65265^2;
    c4 = 737.86223^2;

    % evaluate the A-weighting filter in the frequency domain
    fA = f.^2;
    num = c1*(fA.^2);
    den = (fA+c2) .* sqrt((fA+c3).*(fA+c4)) .* (fA+c1);
    
    A = 1.2589*num./den;

end