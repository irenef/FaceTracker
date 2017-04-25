%
% Princeton University, COS 429, Fall 2016
%
% logistic_predict.m
%   Given a logistic model and some new data, predicts classification
%
% Inputs:
%   X: datapoints (one per row, should include a column of ones
%                  if the model is to have a constant)
%   params: vector of parameters 
% Output:
%   z: predicted labels (0/1)
%

function z = logistic_predict(X, params)

    % We could evaluate the linear part, apply the nonlinearity, and
    % compare against a theshold of 0.5.  But that's equivalent to just
    % comparing the linear part, before the nonlinearity, against 0.
    
    % DELETE: testing purposes
    % z = (X * params >= 0);
    a = X * params; 
    a = logistic(a);
    z = (a >= 0.5);
end

function val = logistic(z) 
    val = 1 ./ (1+exp(-z));
end