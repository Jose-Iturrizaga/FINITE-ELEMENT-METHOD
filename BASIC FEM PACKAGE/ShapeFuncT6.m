function [N] = ShapeFuncT6(xi)

N = zeros(1,6);
N(1)= (1-xi(1)-xi(2))*(1-2*xi(1)-2*xi(2));
N(2)= xi(1)*(-1+2*xi(1));
N(3)= xi(2)*(-1+2*xi(2));
N(4)= 4*xi(1)*(1-xi(1)-xi(2));
N(5)= 4*xi(1)*xi(2);
N(6)= 4*xi(2)*(1-xi(1)-xi(2));
return