function [N] = ShapeFuncL2(xi)

N = zeros(1,2);
N(1)= 1/2*(1-xi(1));
N(2)= 1/2*(1+xi(1));
return