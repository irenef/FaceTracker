%
% Princeton University, COS 429, Fall 2016
%
% test_face_classifier.m
%   Train and test a face classifier.
%
% Inputs:
%   ntrain: number of face and nonface training examples (ntrain of each)
%   ntest: number of face and nonface testing examples (ntest of each)
%   orientations: the number of HoG gradient orientations to use
%   wrap180: if true, the HoG orientations cover 180 degrees, else 360
%

function test_face_classifier(ntrain, ntest, orientations, wrap180)

    % Get some training data
    [descriptors classes] = get_training_data(ntrain, orientations, wrap180);

    % Train a classifier
    % TODO: experiment with lambda value
    params = logistic_fit(descriptors,classes, 0.001);

    % Evaluate the classifier on the training data
    predicted = logistic_prob(descriptors, params);
    % Save training result 
    set(figure(1), 'Name', 'Training');
    plot_errors(predicted, classes);
    title('Performance on training set for varying threshold');
    
    % Get some test data
    [tdescriptors tclasses] = get_testing_data(ntest, orientations, wrap180);

    % Evaluate the classifier on the test data
    tpredicted = logistic_prob(tdescriptors, params);
    set(figure(2), 'Name', 'Test');
    plot_errors(tpredicted, tclasses);
    title('Performance on test set for varying threshold');
    
    % uncomment this if need to save a new one mat file
    % save('face_classifier.mat', 'params', 'orientations', 'wrap180');
end

%
% Plot a log/log graph of miss rate (false negatives) vs false positives
% for a variety of thresholds on probability.
%
% Inputs:
%   predicted: probabilities that the class is 1
%   classes: ground-truth class labels (0/1)
%

function plot_errors(predicted, classes)

    nthresh = 99;
    npts = size(predicted,1);

    falsepos = zeros(nthresh,1);
    falseneg = zeros(nthresh,1);

    stepsize = 1 / (nthresh + 1);
    for i = 1:nthresh
        thresh = i * stepsize;
        falsepos(i) = sum(predicted >= thresh & classes == 0) / npts; 
        falseneg(i) = sum(predicted <  thresh & classes == 1) / npts; 
    end

    limit = 10^-4;
    loglog(max(falsepos,limit), max(falseneg,limit), 'o-');
    axis([limit,1,limit,1]);
    xlabel('False positive rate');
    ylabel('False negative rate');

end

