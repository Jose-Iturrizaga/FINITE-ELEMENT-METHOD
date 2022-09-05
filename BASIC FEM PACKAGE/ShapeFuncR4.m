function [N] = ShapeFuncR4(xi)

N = zeros(1,4);
N(1)= 1-xi(1)-xi(2)-xi(3);
N(2)= xi(1);
N(3)= xi(2);
N(4)= xi(3);
return