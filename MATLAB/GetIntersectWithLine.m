function point=GetIntersectWithLine(p1,p2,r)

    r1 = sqrt(p1(2)^2 + p1(3)^2);
    r2 = sqrt(p2(2)^2 + p2(3)^2);

    if r1 ~= r2 %%% check for perfectly vertical lines %%%
        if (r1<r && r<r2) || (r2<r && r<r1) %%% exclude non intersecting %%%
            point = p1 + ((p2 - p1)./(r2 - r1)).*(r - r1);
        else
            point = false;
        end
    else
        point = false;
    end

end