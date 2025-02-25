clc; clear; close all

params = parameters();
x0 = [-5 1; -5 -1; -4 0];
tol = 1e-6;
N = 1001;

for i = 1:N
    length = i/N * 9;
    x0(1,1) = length -5;
    x0(2,1) = length -5;
    x0(3,1) = length -4;
    [x_min, f_min, iter, points_history] = nelder_mead(@objective,x0,params,tol);
    iterations(i) = iter;
end

pos = linspace(0,9,N);

figure
plot(pos,iterations,'.')
xlabel("Postion of the simplex left boundary")
ylabel("Number of iterations")
title("Effect of position simplex on iterations")

% Function
function F = objective(x)
    F = (x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2;
end

% Parameters
function params = parameters()
    params.maxiter = 300;
end