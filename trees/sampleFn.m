function fn = sampleFn(z)
    function x = cdf(y)
    %numer = -log(1+exp(6))+log(exp(6)+exp(12*y));
    %denom = log((exp(6)+exp(4*sqrt(9-z^2)))/(1+exp(6)));
        numer = 36 - log(1+exp(42)) + log(exp(6) + exp(12*y));
        denom = log((exp(6) + exp(4*sqrt(9-z^2))) / (1+exp(6)));
        x = numer/denom;
    end

    X = 0:1/100:1;
    Y = zeros(1, length(X));
    for i=1:length(X),
        Y(i) = cdf(X(i));
    end

    function x = inner(y)
        x = interp1(Y,X,y);
    end
    
    fn = @inner;
end