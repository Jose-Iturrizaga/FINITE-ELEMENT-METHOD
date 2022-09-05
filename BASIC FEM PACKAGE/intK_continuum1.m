function [k] = intK_continuum1(elType,XYZ,MATprop,constLaw,DpN,dNfunc,intOrder)
% En esta función los datos de entrada son los siguientes
% -   elType: Tipo de elemento
% -   XYZ: Corresponde a las coordenadas del elemento triangular
% -   MATprop: Propiedades elásticas del material
% -   constLaw: Indica el caso de leyes constitutivas
% -   DpN: Grados de libertad por nodo
% -   dNfunc: Derivada de la función de forma del elemento
% -   intOrder: Orden de la cuadratura de Gauss
% Y los datos de salida corresponderá son los siguientes:
% -   k : Es la matriz de rigidez del elemento

[D] = GetContinuumDmatrix(MATprop.E,MATprop.nu,constLaw);
[GP_N,GP_w,GP_xi]=GetGaussQuad(elType,intOrder);
Nne = size(XYZ,2);
[k] = zeros(Nne*DpN);

for i=1:GP_N
    Ei=GP_xi(i);
    We=GP_w(i);
    dN=dNfunc(Ei);
    [B,detJ] = GetBmatrixContinuum(dN,XYZ);
    k=k+We*B'*MATprop.A*D*B*detJ;
end

return