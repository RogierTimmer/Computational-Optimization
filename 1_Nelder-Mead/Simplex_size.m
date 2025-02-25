clc; clear; close all

params = parameters();
x0 = [-1 -5; 1, 5; 0 -1];
tol = 1e-6;
N = 1001;

for i = 1:N
    length = i/N * 10;
    x0(3,2) = length-5;
    [x_min, f_min, iter, points_history] = nelder_mead(@objective,x0,params,tol);
    iterations(i) = iter;
end

point3 = linspace(-5,5,N);


% Function
function F = objective(x)
    F = (x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2;
end

% Parameters
function params = parameters()
    params.maxiter = 300;
end

figure
plot(point3,iterations,'.')
xlabel("y position third point of the simplex")
ylabel("Number of iterations")
title("Effect of size simplex on iterations")