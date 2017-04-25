%
% Princeton University, COS 429, Fall 2016
%
% hog36.m
%   Computes a HoG descriptor for a 36x36 array, using 6x6 pixel cells,
%   2x2 blocks, L2 normalization
%
% Inputs:
%   img: a 36x36 image
%   orientations: the number of gradient orientations to use
%   wrap180: if true, the orientations cover 180 degrees, else 360
% Output:
%   descriptor: a HoG descriptor of length 100 * orientations
%

function descriptor = hog36(img, orientations, wrap180)

    % Compute gradient using tiny centered-difference filter
    img = single(img);
    gx = conv2(img, [1 0 -1], 'same');
    gx(:,1) = 0;
    gx(:,end) = 0;
    gy = conv2(img, [1;0;-1], 'same');
    gy(1,:) = 0;
    gy(end,:) = 0;
    gmag = hypot(gx, gy);
    if wrap180
        multiplier = orientations / pi;
    else
        multiplier = orientations / (2*pi);
    end
    gdir = mod(atan2(gy, gx) * multiplier, orientations);

    % Bin by orientation
    cells = zeros(6, 6, orientations);
    filter = [1 2 3 3 2 1];
    for i = 1:orientations
        % Select out by orientation, weight by gradient magnitude
        if i == orientations
            gdir_wrap = mod(gdir + 1, orientations) - 1;
            this_orientation = gmag .* max(1-abs(gdir_wrap),0);
        else
            this_orientation = gmag .* max(1-abs(gdir-i),0);
        end
        % Aggregate and downsample
        this_orientation = conv2(filter, filter, this_orientation, 'valid');
        cells(:,:,i) = this_orientation(1:6:end,1:6:end);
    end

    % Create the output vector
    descriptor = zeros(1, 5 * 5 * 4 * orientations);
    for block_i = 1:5
        for block_j = 1:5
            block = cells(block_i:block_i+1, block_j:block_j+1, :);
            block_unrolled = block(:);
            norm_block_unrolled = norm(block_unrolled);
            if (norm_block_unrolled > 0)
                block_unrolled = block_unrolled / norm(block_unrolled);
            else
                block_unrolled = 1 / size(block_unrolled,1);
            end
            first = (5*(block_i-1)+block_j-1) * 4*orientations + 1;
            last = first + 4*orientations - 1;
            descriptor(first:last) = block_unrolled;
        end
    end
    

end

