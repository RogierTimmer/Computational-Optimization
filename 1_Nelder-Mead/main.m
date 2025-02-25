clc; clear; close all;

params = parameters();
x0 = [1 1; -1 1; 0 -1];
tol = 1e-6;

[x_min, f_min, iter, points_history] = nelder_mead(@objective,x0,params,tol);

x_points = points_history(:, 1);
y_points = points_history(:, 2);
initial_simplex_points = points_history(1:4, :);

% Ploting the contour
x = linspace(-5,5,1001);
y = linspace(-5,5,1001);
[X,Y] = meshgrid(x,y);
Z = objective_plot(X,Y);

figure
hold on
contour(X,Y,Z,40)
colorbar
xlabel("X")
ylabel("Y")
title("Himmelblau function")

plot(x_points,y_points)
plot(initial_simplex_points(:, 1), initial_simplex_points(:, 2), 'o-', 'MarkerFaceColor', 'r');
plot(x_min(1),x_min(2),'o-','MarkerFaceColor','r','MarkerSize',10)



% Function
function F = objective(x)
    F = (x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2;
end

% Parameters
function params = parameters()
    params.maxiter = 300;
end

% Function for plotting
function F = objective_plot(x,y)
    F = (x.^2 + y - 11).^2 + (x + y.^2 - 7).^2;
end