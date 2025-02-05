function x = BFGS(x0, tol, objectiveF, gradientF)
    maxIter = 100;
    B_inv = eye(2);
    % Preallocate space for storing iterations
    x = zeros(length(x0), maxIter + 1);
    x(:,1) = x0;  % Store the initial guess
    

    for iter = 1:maxIter
        % Compute function gradient
        grad = gradientF(x(:,iter));

        % Check convergence
        if norm(grad) < tol
            fprintf('Converged in %d iterations\n', iter);
            x = x(:, 1:iter); % Trim unused preallocated space
            return;
        end

        % Compute search direction
        p = -B_inv * grad;

        % Line search
        alpha = lineSearch(x(:,iter), p, objectiveF, gradientF);

        % Update x
        x(:, iter+1) = x(:, iter) + alpha * p;

        % Compute step differences
        s = x(:, iter+1) - x(:, iter);
        y = gradientF(x(:, iter+1)) - grad;

        % BFGS Update
        rho = 1 / (y' * s);
        if rho > 0  % Ensure update is valid
            B_inv = (eye(2) - rho * (s * y')) * B_inv * (eye(2) - rho * (y * s')) + rho * (s * s');
        end
    end

    % Trim unused preallocated space if max iterations were reached
    x = x(:, 1:maxIter+1);
end
