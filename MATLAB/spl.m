function [SPL,f]=spl(t,p,RPM,bandwidth)

    sample_freq_in_Hz = 1/(t(2)-t(1));
    dt = t(2)-t(1);
    secPerRev = 60/RPM;
    framePerRev = secPerRev/dt;
    
    meanSignal = movmean(p,framePerRev);
    
    p = p - meanSignal;
    
    if nargin == 1
        [pxx,f]=pwelch(p);
    else
        [pxx,f]=pwelch(p,round(5/2*framePerRev),[],[],sample_freq_in_Hz);
    end
    
    if isempty(bandwidth)
        df = f(2)-f(1);
    else
        df = bandwidth;
    end
    
    SPL=10*log10(pxx*(df)/4e-10);

end