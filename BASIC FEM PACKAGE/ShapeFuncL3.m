function [N] = ShapeFuncL3(xi)

N = zeros(1,3);
N(1)= 1/2*xi(1)*(-1+xi(1));
N(2)= 1/2*xi(1)*(1+xi(1));
N(3)= (1-xi(1)^2);
return