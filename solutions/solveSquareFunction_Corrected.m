function [res] = solveSquareFunction(a,b,c)
%res = solveSquareFunction(a,b,c)
% INPUTS:
% a, b, c - the coefficients of the quadratic function a * x^2 + b * x + c = 0
% OUTPUTS:
% res - an array containing the two solutions for the quadratic formula

x1 = -b/(2*a) + sqrt(b^2/(4*a^2)-c/a); 
x2 = -b/(2*a) - sqrt(b^2/(4*a^2)-c/a);
 
res = [x1;x2];
