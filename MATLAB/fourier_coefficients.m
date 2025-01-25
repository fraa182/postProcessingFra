function [f, F_fft] = fourier_coefficients(dt,F)

    % Compute sampling frequency
    fs = 1/dt;
    
    % Compute the FFT of the signal
    F_fft = fftshift(fft(F-mean(F,length(size(F))),2^nextpow2(size(F,length(size(F)))),length(size(F))))/2^nextpow2(size(F,length(size(F))));
    
    % Compute the frequency resolution
    dF = fs / 2^nextpow2(size(F,length(size(F))));

    % Compute frequency vector spanning from -fs/2 to fs/2
    f = -fs/2 : dF : fs/2 - dF;

end