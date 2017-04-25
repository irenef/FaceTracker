%
% Princeton University, COS 429, Fall 2016
%
% find_faces_single_scale.m
%   Find 36x36 faces in an image
%
% Inputs:
%   img: an image
%   stride: how far to move between locations at which the detector is run
%   thresh: probability threshold for calling a detection a face
%   params: trained face classifier parameters
%   orientations: the number of HoG gradient orientations to use
%   wrap180: if true, the HoG orientations cover 180 degrees, else 360
% Outputs:
%   outimg: copy of img with face locations marked
%   probmap: probability map of face detections
%

function [outimg, probmap] = find_faces_single_scale(img, stride, thresh, ...
        params, orientations, wrap180)

    windowsize = 36;
    if stride > windowsize
        stride = windowsize;
    end

    [height, width] = size(img);
    probmap = zeros(height, width);
    outimg = img;
    hog_descriptor_size = 100 * orientations;

    % Initialize descriptors
    descriptors = zeros(floor(width/stride), hog_descriptor_size + 1);
    
    % Loop over windowsize x windowsize windows, advancing by stride
    % Fill in here
    % TODO: change this 
    for i = 1 : floor((height-windowsize)/stride)
        descriptors(i, 1) = 1;
        y = 1+(i-1)*stride; 
        for j = 1 : floor((width-windowsize)/stride)
            % Crop out a windowsize x windowsize window starting at (i,j)
            x = 1+(j-1)*stride;
            crop = imcrop(img, [x y windowsize windowsize]); 

            % Compute a HoG descriptor, and run the classifier            
            descriptors(i, 2:hog_descriptor_size+1) = hog36(crop, orientations, wrap180);
            probability = logistic_prob(descriptors, params);
            probability = probability(i);

            % Mark detection probability in probmap
            
            win_i = y + floor((windowsize - stride) / 2);
            win_j = x + floor((windowsize - stride) / 2);
            probmap(win_i:win_i+stride-1, win_j:win_j+stride-1) = probability;
             
            % If probability of a face is below thresh, continue
            if probability < thresh
                continue;
            end
        end
    end
    
    % EXTRA CREDIT -- non max suppression 
    newProbmap = probmap; 
    for r = 2 : floor((height-windowsize)/stride)
        for c = 2 : floor((width-windowsize)/stride)
                if (probmap(r, c) < probmap(r, c-1) || probmap(r, c) < probmap(r, c+1) || ...
                         probmap(r, c) < probmap(r+1, c) || probmap(r, c+1) < probmap(r-1, c) ...
                         || probmap(r, c) < probmap(r+1, c-1) || probmap(r, c) < probmap(r-1, c+1) ...
                         || probmap(r, c) < probmap(r+1, c+1) || probmap(r, c) < probmap(r-1, c-1))
                    newProbmap(r, c) = 0.0;
                else 
                    newProbmap(r, c) = probmap(r, c);
                end
        end
    end

    for i = 1 : floor((height-windowsize)/stride)
        y = 1+(i-1)*stride; 
        for j = 1 : floor((width-windowsize)/stride)
            x = 1+(j-1)*stride;
            % Mark the face in outimg
            if newProbmap(y,x)>=thresh 
                offset = windowsize/2; 
                outimg(y-offset, x-offset:x+windowsize-1-offset) = 255;
                outimg(y+windowsize-offset, x-offset:x+windowsize-1-offset) = 255;
                outimg(y-offset:y+windowsize-1-offset, x-offset) = 255;
                outimg(y-offset:y+windowsize-1-offset, x-offset+windowsize-1) = 255;
            end
        end
    end 
end