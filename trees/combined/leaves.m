function simulate(shape, sampleFn, nLeaves)
    leaves = [];
    [H, b] = double(shape);
    for i=1:nLeaves,
        dx = sampleFn(rand());
        b1 = b + H *[dx, 0];
        leaves(i) = polytope(H, b1);
    end
    
    handle = figure('Name', sprintf('Leaves (n=%d)', nLeaves), 'Color', 'w');   
    figure(handle);
    axis equal;
    grid on; hold on; 

    % plot leaves
    for i=1:nLeaves,
        figure(handle);
        popts.shade = 0;
        popts.color = 'g';
        popts.edgecolor = popts.color;
        plot(leaves(i), popts);
    end
    
end
