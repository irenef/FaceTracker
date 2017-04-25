%
% Princeton University, COS 429, Fall 2016
%
% test_single_scale.m
%   Test face detection on all single-scale images
%
% Inputs:
%   stride: how far to move between locations at which the detector is run
%   thresh: probability threshold for calling a detection a face
%

function test_single_scale(stride, thresh)

    load('face_classifier.mat');
    single_scale_scenes_dir = 'face_data/single_scale_scenes';
    scene_filenames = dir(strcat(single_scale_scenes_dir, '/*.jpg'));

    for i = 1:length(scene_filenames)

        filename = fullfile(scene_filenames(i).folder, scene_filenames(i).name);
        fprintf('Detecting faces in %s...\n', filename);

        img = imread(filename);
        [outimg probmap] = find_faces_single_scale(img, stride, thresh, ...
            params, orientations, wrap180);

        imshow(outimg);
        fprintf('Press a key to continue\n');
        pause;

    end

end

