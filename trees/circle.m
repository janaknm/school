function S = circle()
    theta = 0:pi/100:2*pi;
    V = zeros(length(theta), 2);
    
    i = 1;
    for t=theta,
        r = 1;
        V(i,:) = [r*cos(t), r*sin(t)];
        i = i+1;
    end
    S = polytope(V);
end