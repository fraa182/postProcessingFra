function AI = computeAI(p,t)

    [SPL,f] = spl(t,p);

    [fc,AI_lower,AI_upper,weightingFactor] = extract_signal('tableAI.xlsx',1);
    fmin = fc/sqrt(2^(1/3));
    fmax  = fc*sqrt(2^(1/3));
    
    AI = zeros(length(fc),1);
    for i = 1:length(fc)
    
        SPL_third_octave = ospl(f(f >= fmin(i) & f <= fmax(i)),SPL(f >= fmin(i) & f <= fmax(i)));
    
        if SPL_third_octave >= AI_upper(i)
    
            AI(i) = 0;
    
        elseif SPL_third_octave <= AI_lower(i)
    
            AI(i) = 1;
    
        else
    
            AI(i) = (AI_upper(i)-SPL_third_octave)/(AI_upper(i)-AI_lower(i));
    
        end
    
        AI(i) = AI(i)*weightingFactor(i);
    
    end
    
    AI = sum(AI)/length(AI)*100;

end
