function varargout = splToTonesAndOverall(SPL,f,BPF)

    varargout = cell(1,nargout); df = 0.02*BPF;
    for n = 1:nargout - 1
        varargout{n} = ospl(f(f >= n*BPF-df & f <= n*BPF+df),SPL(f >= n*BPF-df & f <= n*BPF+df),'dB');
        %varargout{n} = pchip(f,SPL,n*BPF);
    end
    varargout{nargout} = ospl(f,SPL,'dB');

end