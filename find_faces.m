%
% Princeton University, COS 429, Fall 2016
%
% find_faces.m
%   Find faces in an image
%
% Inputs:
%   img: an image
%   stride: how far to move between locations at which the detector is run,
%       at the finest (36x36) scale.  This is effectively scaled up for
%       larger windows.
%   thresh: probability threshold for calling a detection a face
%   params: trained face classifier parameters
%   orientations: the number of HoG gradient orientations to use
%   wrap180: if true, the HoG orientations cover 180 degrees, else 360
% Outputs:
%   outimg: copy of img with face locations marked
%

function outimg = find_faces(img, stride, thresh, ...
    params, orientations, wrap180)
    origWindowsize = 72;
    cropsize = 36; 
    windowsize = origWindowsize;
    growScale = 1.2;
    
    firstIter = true; 
    if stride > windowsize
        stride = windowsize;
    end
    
    [height, width] = size(img);
    probmap = zeros(height, width);
    outimg = img;
    hog_descriptor_size = 100 * orientations;
    
    while (windowsize < min(size(img,1), size(img,2)))
        % Initialize descriptors
        descriptors = zeros(floor(width/stride), hog_descriptor_size + 1);

        % Loop over windowsize x windowsize windows, advancing by stride
        % Fill in here
        for i = 1 : floor((height-windowsize)/stride)
            descriptors(i, 1) = 1;
            y = 1+(i-1)*stride; 
            for j = 1 : floor((width-windowsize)/stride)
                % Crop out a windowsize x windowsize window starting at (i,j)
                x = 1+(j-1)*stride;
                crop = imcrop(img, [x y windowsize windowsize]); 
                crop = imresize(crop, [cropsize cropsize]);
                
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

                % Mark the face in outimg
                outimg(y, x:x+windowsize-1) = 255;
                outimg(y+windowsize-1, x:x+windowsize-1) = 255;
                outimg(y:y+windowsize-1, x) = 255;
                outimg(y:y+windowsize-1, x+windowsize-1) = 255;
            end
        end
        windowsize = floor(windowsize * growScale);
        stride = floor(stride * growScale);
    end
end
