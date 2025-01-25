function dp = extractPressureDistribution(x,y,z,p,rTarget,x1,toll,varargin)

    flipFlag = varargin{1};

    % Geometry rotation to ensure consistency and generality of the code
    [x,y,z] = adjustGeometry(x,y,z);
    if flipFlag
        x = -x; z = -z;
    else
        [x,y,z] = interactiveFlipCheck(x,y,z);
    end

    % Partition into radial strips
    r = sqrt(y.^2 + z.^2);

    % Initialize vectors to save on memory allocation
    xSS = zeros(length(x1),length(rTarget)); pSS = zeros(length(x1),length(rTarget));
    xPS = zeros(length(x1),length(rTarget)); pPS = zeros(length(x1),length(rTarget));

    % For each radial strip:
    for i = 1:length(rTarget)
        % Airfoil extraction (coordinates and corresponding pressure)
        xx = x(abs(r-rTarget(i))./r <= toll);
        yy = y(abs(r-rTarget(i))./r <= toll); 
        zz = z(abs(r-rTarget(i))./r <= toll);
        pp = p(abs(r-rTarget(i))./r <= toll);

        % Airfoil rotation in yz plane
        [~,yc,zc] = centroid(xx,yy,zz); alpha = atan2(zc,yc) + pi;
        xAirfoil = yy*sin(-alpha) + zz*cos(-alpha); yAirfoil = -xx;

        % Filtering on unique value (needed to perform interpolation below)
        [xAirfoil,uniqueIdx] = unique(xAirfoil);
        yAirfoil = yAirfoil(uniqueIdx); pp = pp(uniqueIdx);

        % LE and TE localization to calculate blade twist angle
        LE = [min(xAirfoil) yAirfoil(xAirfoil == min(xAirfoil))];
        TE = [max(xAirfoil) yAirfoil(xAirfoil == max(xAirfoil))];

        % Blade twist calculation to rotate the airfoil in xy plane
        gamma = -atan2((TE(2)-LE(2)),(TE(1)-LE(1)));

        % Airfoil rotation in xy plane to ensure consistency and generality of the code
        xAirfoil = xAirfoil - LE(1); yAirfoil = yAirfoil - LE(2);
        xxAirfoil = xAirfoil*cos(gamma) - yAirfoil*sin(gamma); yyAirfoil = xAirfoil*sin(gamma) + yAirfoil*cos(gamma);

        % LE and TE recalculation (used to complete the camber line)
        TE = TE - LE; 
        TE = ([cos(gamma) -sin(gamma); sin(gamma) cos(gamma)]*TE')'; LE = [0,0];
    
        % Airfoil camber line localization to discriminate between PS and SS
        nBeams = 5; nBeams = min([nBeams length(xx)]);
        dx = (TE(1))/nBeams;
        ycbIn = zeros(1,nBeams); xcbIn = zeros(1,nBeams);
        for ii = 1:nBeams
            xcbIn(ii) = mean(xxAirfoil((xxAirfoil >= (ii-1)*dx) & (xxAirfoil <= ii*dx)));
            ycbIn(ii) = mean(yyAirfoil((xxAirfoil >= (ii-1)*dx) & (xxAirfoil <= ii*dx)));
        end
        xcb = [LE(1) xcbIn TE(1)]; ycb = [LE(2) ycbIn TE(2)];
        polyCamber = polyfit(xcb,ycb,4);
    
        % Discrimination between PS and SS to compute dp = pPS - pSS according to the signed distance within the camber line (up or down?)
        idx_SS = yyAirfoil - polyval(polyCamber,xxAirfoil) <= 0; idx_PS = yyAirfoil - polyval(polyCamber,xxAirfoil) >= 0;

        % Extraction of x and p for SS and PS
        xxSS = xxAirfoil(idx_SS); xxPS = xxAirfoil(idx_PS);
        ppSS = pp(idx_SS); ppPS = pp(idx_PS);

        % Resampling of x and p for SS and PS
        xSS(:,i) = pchip(2*(xxSS-min(xxSS))/(max(xxSS)-min(xxSS))-1,xxSS,x1); xPS(:,i) = pchip(2*(xxPS-min(xxPS))/(max(xxPS)-min(xxPS))-1,xxPS,x1);
        pSS(:,i) = pchip(2*(xxSS-min(xxSS))/(max(xxSS)-min(xxSS))-1,ppSS,x1); pPS(:,i) = pchip(2*(xxPS-min(xxPS))/(max(xxPS)-min(xxPS))-1,ppPS,x1);
             
    end

    % Calculation of pressure difference
    dp = pPS - pSS;

end