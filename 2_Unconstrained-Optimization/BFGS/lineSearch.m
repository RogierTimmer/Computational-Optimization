% Basic line search (backtracking)
function alpha = lineSearch(x, p, params, objectiveF, gradientF)
    alpha = 1; % Initial step size
    c = 0.5;   % Scale factor
    tau = 0.5; % Shrinkage factor

    while objectiveF(x + alpha * p, params) > objectiveF(x, params) + c * alpha * (gradientF(x, params)' * p)
        alpha = tau * alpha; % Reduce step size
    end
end