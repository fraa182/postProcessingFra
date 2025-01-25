function [xAirfoilIntersect,yAirfoilIntersect,zAirfoilIntersect] = intersectAirfoil(xAirfoil,yAirfoil,zAirfoil,ConnectionsFiltered,R)

    intersections = [];
    for cc = 1:length(xAirfoil)
        for a=1:size(ConnectionsFiltered,1) %%% scan whole airfoil connections matrix %%%
            Row=ConnectionsFiltered(a,:); %%%% get a row %%%

            for iii=1:length(Row)
                value=Row(iii); %%% scan a row to check points id %%%
        
                if value == cc
                    p1 = [xAirfoil(Row(1)) yAirfoil(Row(1)) zAirfoil(Row(1))];
                    p2 = [xAirfoil(Row(2)) yAirfoil(Row(2)) zAirfoil(Row(2))];
                    p3 = [xAirfoil(Row(3)) yAirfoil(Row(3)) zAirfoil(Row(3))];

                    result=GetIntersectWithLine(p1,p2,R);

                    if result
                        intersections=vertcat(intersections,result);
                    end

                    result=GetIntersectWithLine(p1,p3,R);
                    if result
                        intersections=vertcat(intersections,result);
                    end

                    result=GetIntersectWithLine(p2,p3,R);
                    if result
                        intersections=vertcat(intersections,result);
                    end
                end
            end
        end
    end

    xAirfoilIntersect = intersections(:,1);
    yAirfoilIntersect = intersections(:,2);
    zAirfoilIntersect = intersections(:,3);

end