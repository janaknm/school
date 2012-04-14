function tree(shape, leavesdistance, branches)
    minheight = -2.8;
    maxheight = 2.8;
    nLeaves = 35;
    scale = nLeaves / leavesdistance;
    
    [normals, distances] = double(shape);
    distances = distances./sqrt(volume(shape));
    shape = polytope(normals, distances);
    [H, b] = double(shape);
    
    Z = minheight:(maxheight-minheight)/branches:maxheight;
    
    handle = figure('Name', sprintf('Tree'), 'Color', 'w');   
    figure(handle);
    axis equal;
    grid on; hold on;
    popts.shade = 0;
    popts.color = 'g';
    popts.edgecolor = popts.color;

    for z=Z,
        cdfInv = sampleFn(z);
        
        DX = zeros(1,nLeaves);
        for i=1:nLeaves,
            DX(i) = scale * cdfInv(rand());
        end
        DX = sort(DX);

        for i=1:nLeaves,
            b1 = b + H * [DX(i); scale*z];
            b2 = b + H * [-DX(i); scale*z];
            try
            leaf = polytope(H, b1);
            plot(leaf, popts);
            leaf = polytope(H, b2);
            plot(leaf, popts);
            catch ME
            end
        end
        
    end
end