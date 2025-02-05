clc; clear; close all

params = parameters();
x0 = [0,0];
tol = 10e-6;

data = BFGS(x0, tol, params, @objectiveF, @gradientF);

fprintf('Optimal solution: x1 = %.6f, x2 = %.6f\n', data(1,end), data(2,end));

% Define the range for x and y
x = linspace(0, 10, 401);
y = linspace(0, 5, 401);

% Create a meshgrid for x and y
[X, Y] = meshgrid(x, y);

Z = objectiveF_2(X, Y, params);

figure
hold on
contour(X, Y, Z, 60);
colorbar
xlabel('x_1')
ylabel('x_2')
title('Contour Plot of Objective Function')
grid on

% Plot the way to the minimum in blue
plot(data(1,:), data(2,:), '-bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b')

% Plot the calculated minimum in red
plot(data(1,end), data(2,end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r')

hold off






%%Objective

%Objective function
function F = objectiveF(x, params)
    dL1 = sqrt(x(1)^2 + (params.L0 - x(2))^2) - params.L0;
    dL2 = sqrt(x(1)^2 + (params.L0 + x(2))^2) - params.L0;
    F = 0.5 * params.k1 * dL1^2 + 0.5 * params.k2 * dL2^2 - params.P1 * x(1) - params.P2 * x(2);
end

% Gradient of the function
function grad = gradientF(x, params)
    % Partial derivatives
    dF_dx1 = params.k1*x(1) - params.P1 + params.k2*x(1) - (params.L0*params.k1*x(1))/(x(1)^2 + (params.L0 - x(2))^2)^(1/2) - ...
        (params.L0*params.k2*x(1))/((params.L0 + x(2))^2 + x(1)^2)^(1/2);
       
    dF_dx2 = (params.k1*(params.L0 - (x(1)^2 + (params.L0 - x(2))^2)^(1/2))*(2*params.L0 - 2*x(2)))/(2*(x(1)^2 + ...
        (params.L0 - x(2))^2)^(1/2)) - params.P2 - (params.k2*(params.L0 - ...
        ((params.L0 + x(2))^2 + x(1)^2)^(1/2))*(2*params.L0 + 2*x(2)))/(2*((params.L0 + x(2))^2 + x(1)^2)^(1/2));
       
    grad = [dF_dx1; dF_dx2];
end

%Parameters of the objective

function params = parameters()
    params.L0 = 10;
    params.k1 = 8;
    params.k2 = 4;
    params.P1 = 5;
    params.P2 = 10;
end

% Objective function for contour plot
function F = objectiveF_2(x, y, params)
    dL1 = sqrt(x.^2 + (params.L0 - y).^2) - params.L0;
    dL2 = sqrt(x.^2 + (params.L0 + y).^2) - params.L0;
    F = 0.5 * params.k1 * dL1.^2 + 0.5 * params.k2 * dL2.^2 - params.P1 * x - params.P2 * y;
end
