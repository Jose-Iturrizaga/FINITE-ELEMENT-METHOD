function [dN] = ShapeDerivL3(xi)

dN = zeros(1,3);
dN(1,1) = 1/2*(-1+2*xi(1));
dN(1,2) = 1/2*(1+2*xi(1));
dN(1,3) = -2*xi(1);
return