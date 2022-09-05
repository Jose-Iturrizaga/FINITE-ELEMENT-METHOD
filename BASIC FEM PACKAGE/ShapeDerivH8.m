function [dN] = ShapeDerivH8(xi)

dN = zeros(3,8);
dN(1,1)= -1/8*(1-xi(2))*(1-xi(3));
dN(1,2)=  1/8*(1-xi(2))*(1-xi(3));
dN(1,3)=  1/8*(1+xi(2))*(1-xi(3));
dN(1,4)= -1/8*(1+xi(2))*(1-xi(3));
dN(1,5)= -1/8*(1-xi(2))*(1+xi(3));
dN(1,6)=  1/8*(1-xi(2))*(1+xi(3));
dN(1,7)=  1/8*(1+xi(2))*(1+xi(3));
dN(1,8)= -1/8*(1+xi(2))*(1+xi(3));
dN(2,1)= -1/8*(1-xi(1))*(1-xi(3));
dN(2,2)= -1/8*(1+xi(1))*(1-xi(3));
dN(2,3)=  1/8*(1+xi(1))*(1-xi(3));
dN(2,4)=  1/8*(1-xi(1))*(1-xi(3));
dN(2,5)= -1/8*(1-xi(1))*(1+xi(3));
dN(2,6)= -1/8*(1+xi(1))*(1+xi(3));
dN(2,7)=  1/8*(1+xi(1))*(1+xi(3));
dN(2,8)=  1/8*(1-xi(1))*(1+xi(3));
dN(3,1)= -1/8*(1-xi(1))*(1-xi(2));
dN(3,2)= -1/8*(1+xi(1))*(1-xi(2));
dN(3,3)= -1/8*(1+xi(1))*(1+xi(2));
dN(3,4)= -1/8*(1-xi(1))*(1+xi(2));
dN(3,5)=  1/8*(1-xi(1))*(1-xi(2));
dN(3,6)=  1/8*(1+xi(1))*(1-xi(2));
dN(3,7)=  1/8*(1+xi(1))*(1+xi(2));
dN(3,8)=  1/8*(1-xi(1))*(1+xi(2));
return