function [dN] = ShapeDerivL4(xi)

dN = zeros(1,4);
dN(1,1) = -9/16*(3*xi(1)^2-2*xi(1)-1/9);
dN(1,2) =  9/16*(3*xi(1)^2+2*xi(1)-1/9);
dN(1,3) =  9/16*(9*xi(1)^2-2*xi(1)-3);
dN(1,4) = -9/16*(9*xi(1)^2+2*xi(1)-3);

return