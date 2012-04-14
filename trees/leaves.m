function leaves(shapes, sampleFn, leavesdistance)
    tic
    
    % width is a multiple of volume...
    nLeaves = 30;
    width = nLeaves / leavesdistance;
    voffset = 4;
    
    % normalize shape to volume 1
    for i=1:length(shapes),
        [normals, distances] = double(shapes(i));
        distances = distances./sqrt(volume(shapes(i)));
        shapes(i) = polytope(normals, distances);
    end

    % determine locations along the branch
    DX = zeros(1,nLeaves);
    for i=1:nLeaves,
        DX(i) = width*sampleFn(rand());
    end
    DX = sort(DX);
    
    
    % stores percent overlap
    POverlap = zeros(1,length(shapes));

    handle = figure('Name', sprintf('Leaves (n=%d)', nLeaves), 'Color', 'w');   
    figure(handle);
    axis equal;
    grid on; hold on;
    
    for j=1:length(shapes),
    
        shape = shapes(j);
        [H, b] = double(shape);

        % generate leaves
        leaves(1) = shape;
        for i=1:nLeaves,
            b1 = b + H * [DX(i); voffset*j];
            leaves(i) = polytope(H, b1);
        end

        % plot leaves
        for i=1:nLeaves,
            figure(handle);
            popts.shade = 0;
            popts.color = 'g';
            popts.edgecolor = popts.color;
            plot(leaves(i), popts);
        end
    
        % calculate overlapping area
        areatotal = volume(shape) * nLeaves;
        areaoverlap = 0;
    
        for i=1:nLeaves,
            overlapping = true;
            
            figure(handle);
            popts.shade=1;
            popts.color='r';
            popts.edgecolor = popts.color;
        
            if i > 1,
                itsect = intersect(leaves(i), leaves(i-1));
                if dimension(itsect) == 2,
                    v1 = volume(itsect);
                    plot(itsect, popts);
                else
                    v1 = 0;
                end
            else
                v1 = 0;
            end
            
            if i < nLeaves,
                itsect = intersect(leaves(i), leaves(i+1));
                if dimension(itsect) == 2,
                    v2 = volume(itsect);
                    plot(itsect, popts);
                else
                    v2 = 0;
                end
            else
                v2 = 0;
            end
            
            if i < nLeaves && i > 1,
                itsect = intersect(leaves(i-1), leaves(i+1));
                if dimension(itsect) == 2,
                    v3 = volume(itsect);
                    plot(itsect, popts);
                else
                    v3 = 0;
                end
            else
                v3 = 0;
            end
            
            areaoverlap = areaoverlap + v1 + v2 - v3;
            
        end

        POverlap(j) = areaoverlap/areatotal;
    end
    
    for j=1:length(shapes),
        fprintf('***** Shape %d\n,', j);
        fprintf('Number of leaves: %d\n', nLeaves);
        fprintf('Branch length: %.2fm\n', width);
        fprintf('Percent overlap: %.3f%%\n', 100 * POverlap(j));
    end
    
    toc
    
end
