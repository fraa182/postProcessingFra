function [f, SPL] = folderToSPL(foldername,RPM,nTrans,FWHflag,nProbe,df)

    if nargin < 4
        FWHflag = 0;
        nProbe = 7;
    elseif nargin < 5
        nProbe = 7;
    end

    if FWHflag
        [t,p] = extract_signal([foldername,'/FWH solid/fwh_solid.mic',num2str(nProbe),'.txt'],4);
    else
        if nTrans > 0
            [t,p] = extract_signal([foldername,'/FF probes/probe',num2str(nProbe),'.txt'],4);
            p = p(:,1);

            [t,p] = remove_transient(t,p,RPM,nTrans);
        else
            [t,p] = extract_signal(foldername,0);
        end
    end

    if exist("df","var")
        [SPL, f] = spl(t,p,RPM,df);
    else
        [SPL, f] = spl(t,p,RPM,[]);
    end

end