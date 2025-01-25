function AweightedValue = A_weight(f,dBvalue)

    A = A_from_f(f);

    if any(size(dBvalue) == size(A))
        AweightedValue = dBvalue + 20*log10(A);
    else
        AweightedValue = dBvalue + 20*log10(A');
    end

end