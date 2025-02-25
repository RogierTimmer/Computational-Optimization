function [x_min, f_min, iter, points_history] = nelder_mead(func, initial_simplex, params, tol)
    % func: Function to minimize
    % initial_simplex: Matrix of simplex points (each row is a point)
    % params: Struct containing parameters (maxiter, etc.)
    % tol: Error tolerance for stopping
    % points_history: Stores all points visited during the algorithm

    % Initialize simplex
    simplex = initial_simplex;
    num_points = size(simplex, 1); % Number of points in the simplex
    iter = 0;
    max_iter = params.maxiter;
    
    % Store history of simplex points
    points_history = [];

    while iter < max_iter
        % Evaluate function values at simplex points
        f_vals = zeros(1, num_points);
        for i = 1:num_points
            f_vals(i) = func(simplex(i, :)); % Correctly pass rows to func
        end
        
        % Store the current simplex points (before sorting)
        points_history = [points_history; simplex];
        
        % Sort simplex points by function value
        [f_vals, indices] = sort(f_vals);
        simplex = simplex(indices, :);
        
        % Identify best, second worst, and worst points
        x_best = simplex(1, :);
        x_second_worst = simplex(end-1, :);
        x_worst = simplex(end, :);
        
        % Compute centroid of all points except the worst
        centroid = mean(simplex(1:end-1, :), 1);
        
        % Reflection
        direction = centroid - x_worst; % Reflection direction
        alpha = 1; % Reflection coefficient
        x_reflected = centroid + alpha * direction;
        f_reflected = func(x_reflected);
        
        if f_reflected < f_vals(1) % Better than the best
            % Expansion
            gamma = 2; % Expansion coefficient
            x_expanded = centroid + gamma * direction;
            f_expanded = func(x_expanded);
            
            if f_expanded < f_reflected
                simplex(end, :) = x_expanded; % Replace the worst with expanded
            else
                simplex(end, :) = x_reflected; % Replace the worst with reflected
            end
            
        elseif f_reflected < f_vals(end-1) % Better than the second worst
            simplex(end, :) = x_reflected; % Replace the worst with reflected
            
        else % Worse than the second worst
            % Contraction
            beta = 0.5; % Contraction coefficient
            x_contracted = centroid + beta * (x_worst - centroid);
            f_contracted = func(x_contracted);
            
            if f_contracted < f_vals(end)
                simplex(end, :) = x_contracted; % Replace the worst with contracted
            else
                % Shrink the entire simplex towards the best point
                sigma = 0.5; % Shrink coefficient
                for i = 2:num_points
                    simplex(i, :) = x_best + sigma * (simplex(i, :) - x_best);
                end
            end
        end
        
        % Check for convergence
        if max(abs(f_vals - mean(f_vals))) < tol
            break;
        end
        
        iter = iter + 1;
    end

    % Return results
    x_min = simplex(1, :); % Best point
    f_min = func(x_min); % Function value at the minimum
end
