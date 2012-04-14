function fn = normalFn()
    
    function y = inner(x)
        y = norminv(x, 1, 1);
    end
    
    fn = @inner;
    
end