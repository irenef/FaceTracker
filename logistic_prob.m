%
% Princeton University, COS 429, Fall 2016
%
% logistic_prob.m
%   Given a logistic model and some new data, predicts probability that
%   the class is 1.
%
% Inputs:
%   X: datapoints (one per row, should include a column of ones
%                  if the model is to have a constant)
%   params: vector of parameters 
% Output:
%   z: predicted probabilities (0..1)
%

function z = logistic_prob(X, params)

    % Fill in here
    % TODO: check here
    z = X * params; 
    z = logistic(z);
    % z = (X * params >= 0);
end

function val = logistic(z) 
    val = 1 ./ (1+exp(-z));
end