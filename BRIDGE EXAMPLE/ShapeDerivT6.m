function [dN] = ShapeDerivT6(xi)

dN = zeros(2,6);
dN(1,1)= 4*xi(1)+4*xi(2)-3;
dN(1,2)= 4*xi(1)-1;
dN(1,3)= 0;
dN(1,4)= 4*(1-2*xi(1)-xi(2));
dN(1,5)= 4*xi(2);
dN(1,6)= -4*xi(2);
dN(2,1)= 4*xi(1)+4*xi(2)-3;
dN(2,2)= 0;
dN(2,3)= 4*xi(2)-1;
dN(2,4)= -4*xi(1);
dN(2,5)= 4*xi(1);
dN(2,6)= 4*(1-2*xi(2)-xi(1));
return