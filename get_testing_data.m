%
% Princeton University, COS 429, Fall 2016
%
% get_testing_data.m
%   Reads in examples of faces and nonfaces, and builds a matrix of HoG
%   descriptors, ready to pass in to logistic_predict
%
% Input:
%   n: number of face and nonface testing examples (n of each)
%   orientations: the number of HoG gradient orientations to use
%   wrap180: if true, the HoG orientations cover 180 degrees, else 360
% Outputs:
%   descriptors: matrix of descriptors for all 2*n testing examples, where
%                each row contains the HoG descriptor for one face or nonface
%   classes: vector indicating whether each example is a face (1) or nonface (0)
%

function [descriptors classes] = get_testing_data(n, orientations, wrap180)

    testing_faces_dir = 'face_data/testing_faces';
    testing_nonfaces_dir = 'face_data/testing_nonfaces';
    hog_input_size = 36;
    hog_descriptor_size = 100 * orientations;

    % Get the names of the first n testing faces
    face_filenames = dir(strcat(testing_faces_dir, '/*.jpg'));
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
        % Fill in here
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

    % Loop over nonfaces
    nonface_filenames = dir(strcat(testing_nonfaces_dir, '/*.jpg'));
    for i = n+1:2*n
        % Fill in here
        % Note that unlike in get_training_data, you are not sampling
        % random patches from the nonface images, just reading them in
        % and using them directly.
        
        % Read a random nonface file
        j = randi(n);
        filename = fullfile(nonface_filenames(j).folder, ...
            nonface_filenames(j).name);
        nonface = imread(filename);

        % Compute descriptor, and fill in descriptors and classes
        % Fill in here
        nonface_descriptor = hog36(nonface, orientations, wrap180);
        descriptors(i,1) = 1;
        descriptors(i,2:hog_descriptor_size+1) = nonface_descriptor;
        classes(i) = 0;
    end
end

