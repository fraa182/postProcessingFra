function OA = ospl(f,SPL,dBmode)

    if nargin == 2
        OA = 10*log10(sum(10.^(A_weight(f,SPL)/10)));
    else
        OA = 10*log10(sum(10.^(SPL/10)));
    end

end