function [dN] = ShapeDerivR4(xi)

dN = zeros(3,4);
dN(1,1)= -1;
dN(1,2)= 1;
dN(1,3)= 0;
dN(1,4)= 0;
dN(2,1)= -1;
dN(2,2)= 0;
dN(2,3)= 1;
dN(2,4)= 0;
dN(3,1)= -1;
dN(3,2)= 0;
dN(3,3)= 0;
dN(3,4)= 1;
return