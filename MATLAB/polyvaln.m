function f = polyvaln(p,x,y)

    f = zeros(length(x),length(y));
    parfor i = 1:length(y)

        f(:,i) = polyval(p(i,:),x);

    end

end