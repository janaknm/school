function P = folium(a, b),
    n = 200;
    theta = 0:2*pi/n:2*pi;
    V = zeros(n, 2);
    i = 1;
    for t=theta,
        r = -b * cos(t) + 4*a*cos(t)*(sin(t))^2;
        V(i,:) = [r*cos(t+pi/2), r*sin(t+pi/2)];
        i = i+1;
    end
    P = polytope(V);
end