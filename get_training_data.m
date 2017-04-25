%
% Princeton University, COS 429, Fall 2016
%
% get_training_data.m
%   Reads in examples of faces and nonfaces, and builds a matrix of HoG
%   descriptors, ready to pass in to logistic_fit
%
% Input:
%   n: number of face and nonface training examples (n of each)
%   orientations: the number of HoG gradient orientations to use
%   wrap180: if true, the HoG orientations cover 180 degrees, else 360
% Outputs:
%   descriptors: matrix of descriptors for all 2*n training examples, where
%                each row contains the HoG descriptor for one face or nonface
%   classes: vector indicating whether each example is a face (1) or nonface (0)
%

function [descriptors, classes] = get_training_data(n, orientations, wrap180)

    training_faces_dir = 'face_data/training_faces';
    training_nonfaces_dir = 'face_data/training_nonfaces';
    hog_input_size = 36;
    hog_descriptor_size = 100 * orientations;

    % Get the names of the first n training faces
    face_filenames = dir(strcat(training_faces_dir, '/*.jpg'));
    num_face_filenames = size(face_filenames, 1); 
    if (num_face_filenames > n)
        face_filenames = face_filenames(1:n);
    elseif (num_face_filenames < n)
        n = num_face_filenames;
    end

    % Initialize descriptors, classes
    descriptors = zeros(2*n, hog_descriptor_size + 1);
    classes = zeros(2*n, 1);

    % Loop over faces
    for i = 1:n
        % Read the next face file
        filename = fullfile(face_filenames(i).folder, ...
            face_filenames(i).name);
        face = imread(filename);

        % Compute HoG descriptor
        face_descriptor = hog36(face, orientations, wrap180);

        % Fill in descriptors and classes
        descriptors(i,1) = 1;
        descriptors(i,2:hog_descriptor_size+1) = face_descriptor;
        classes(i) = 1;
    end

    % Get the names of the nonfaces
    nonface_filenames = dir(strcat(training_nonfaces_dir, '/*.jpg'));
    num_nonface_filenames = size(nonface_filenames, 1);

    % Loop over all nonface samples we want
    for i = n+1:2*n
        % Read a random nonface file
        j = randi(num_nonface_filenames);
        filename = fullfile(nonface_filenames(j).folder, ...
            nonface_filenames(j).name);
        nonface = imread(filename);

        % Convert to grayscale if necessary
        if (size(nonface,3) > 1)
            nonface = rgb2gray(nonface);
        end

        % Crop out a random square at least hog_input_size
        % Fill in here
        xmin = randi([1 size(nonface, 2)-hog_input_size], 1);
        ymin = randi([1 size(nonface, 1)-hog_input_size], 1);
        sideMax = min(size(nonface, 2), size(nonface, 1)) - max(ymin, xmin); 
        side = max(sideMax, hog_input_size);
        %side = randi([hog_input_size max(sideMax, hog_input_size)], 1);
        crop = imcrop(nonface, [xmin ymin side side]);

        % Resize to be the right size
        crop = imresize(crop, [hog_input_size hog_input_size]);

        % Compute descriptor, and fill in descriptors and classes
        % Fill in here
        nonface_descriptor = hog36(crop, orientations, wrap180);
        descriptors(i,1) = 1;
        descriptors(i,2:hog_descriptor_size+1) = nonface_descriptor;
        classes(i) = 0;
    end

end

