% Basic line search (backtracking)
function alpha = lineSearch(x, p, objectiveF, gradientF)
    alpha = 1; % Initial step size
    c = 0.5;   % Scale factor
    tau = 0.5; % Shrinkage factor

    while objectiveF(x + alpha * p) > objectiveF(x) + c * alpha * (gradientF(x)' * p)
        alpha = tau * alpha; % Reduce step size
    end
end