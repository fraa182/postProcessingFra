function [x,y,z,Connections,flipFlag] = myReadstl(filename,target_pid,flipFlag)
    
    if nargin < 3
        flipFlag = 0;
    end

    [TR,~,~ ,solidID] = stlread([filename,'.stl']); 
    xAll = TR.Points(:,1)/1e3; yAll = TR.Points(:,2)/1e3; zAll = TR.Points(:,3)/1e3;

    %%% QUI EVENTUALE FUNZIONE CHE SCARTA TUTTO CIO' CHE NON SONO PALE E
    %%% DISCRIMINA OGNI BLADE IN UN DIVERSO PID %%%

    [xAll,yAll,zAll] = adjustGeometry(xAll,yAll,zAll);
    if flipFlag
        xAll = -xAll; zAll = -zAll;
    else
        [xAll,yAll,zAll,flipFlag] = interactiveFlipCheck(xAll,yAll,zAll);
    end

    if length(target_pid) > 1
    
        x = cell(1,length(target_pid)); y = cell(1,length(target_pid)); z = cell(1,length(target_pid));
        Connections = cell(1,length(target_pid));
        for b = target_pid
        
            Connections{b} = TR.ConnectivityList(solidID == b,:);
            
            x{b} = xAll(unique(reshape(Connections{b},1,size(Connections{b},1)*size(Connections{b},2))));
            y{b} = yAll(unique(reshape(Connections{b},1,size(Connections{b},1)*size(Connections{b},2))));
            z{b} = zAll(unique(reshape(Connections{b},1,size(Connections{b},1)*size(Connections{b},2))));

        end
    
    else
    
        Connections = TR.ConnectivityList(solidID == target_pid,:);
        
        x = xAll(unique(reshape(Connections,1,size(Connections,1)*size(Connections,2))));
        y = yAll(unique(reshape(Connections,1,size(Connections,1)*size(Connections,2))));
        z = zAll(unique(reshape(Connections,1,size(Connections,1)*size(Connections,2))));
    
    end

end