function a = points2CST(x,y,N,M,n)

    % x, y: input vectors of airfoil coordinates
    % N, M: exponents of the class function C(x)
    % n: degree of the Bernstein polynomial for the shape function S(x)
    % a: output CST coefficients for the shape function

    % Normalize x to range [0, 1]
    x_norm = (x - min(x)) / (max(x) - min(x));
    
    % Number of points
    num_points = length(x_norm);
    
    % Preallocate the matrix for the least squares problem
    A = zeros(num_points, n+1);
    
    % Build the matrix for Bernstein polynomials (Shape function)
    for i = 0:n
        
        A(:,i+1) = nchoosek(n,i) * (x_norm.^i) .* ((1 - x_norm).^(n-i));

    end
    
    % Class function
    C = (x_norm.^N) .* ((1 - x_norm).^M);

    y(C == 0) = [];
    A(C == 0,:) = [];
    C(C == 0) = [];
    
    % Solve the least squares problem: A * a = y / C
    a = (A \ (y ./ C));

end