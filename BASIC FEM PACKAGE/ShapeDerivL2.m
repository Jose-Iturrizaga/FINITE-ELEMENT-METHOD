function [dN] = ShapeDerivL2(xi)

dN = zeros(1,2);
dN(1,1) = -1/2;
dN(1,2) = 1/2;
return