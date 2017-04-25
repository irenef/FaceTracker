%
% Princeton University, COS 429, Fall 2016
%
% logistic_fit.m
%   Performs L2-regularized logistic regression via Gauss-Newton iteration
%
% Inputs:
%   X: datapoints (one per row, should include a column of ones
%                  if the model is to have a constant)
%   z: labels (0/1)
%   lambda: regularization parameter (will be scaled by the number of examples)
% Output:
%   params: vector of parameters 
%

function params = logistic_fit(X, z, lambda)

    [num_pts, num_vars] = size(X);

    % Linear regression to compute initial estimate.
    % We need to apply a correction to z for just the first
    % linear fit, since the nonlinearity isn't being applied.
    z_corr = z; % 2 * z - 1;
    % regularization 
    params = (X' * X + lambda * num_pts * eye(num_vars)) \ (X' * z_corr);
  
    % Now iterate to improve params
    for iter = 1 : 10
        % Fill in here
        
        sol = X * params;
        prediction = logistic(sol);
        devS = prediction .* (1-prediction);
        r = z_corr - prediction;
        W = diag(devS, 0);
        J = W * X;
        delta = (J' * J + lambda * num_pts * eye(num_vars)) \ (J' * r);
        params = params + delta;
        
    end
end

%
% The logistic "sigmoid" function
%

function val = logistic(z) 
    val = 1.0 ./ (1.0+exp(-z));
end

