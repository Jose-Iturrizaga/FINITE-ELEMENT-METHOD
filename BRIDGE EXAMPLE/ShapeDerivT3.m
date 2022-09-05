function [dN] = ShapeDerivT3(xi)

dN = zeros(2,3);
dN(1,1)= -1;
dN(1,2)= 1;
dN(1,3)= 0;
dN(2,1)= -1;
dN(2,2)= 0;
dN(2,3)= 1;
return