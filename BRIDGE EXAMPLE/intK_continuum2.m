function [k,f] = intK_continuum2(elType,XYZ,MATprop,constLaw,DpN,dNfunc,Nfunc,b,intOrder)
% En esta función los datos de entrada son los siguientes
% -   elType: Tipo de elemento
% -   XYZ: Corresponde a las coordenadas del elemento triangular
% -   MATprop: Propiedades elásticas del material
% -   constLaw: Indica el caso de leyes constitutivas
% -   DpN: Grados de libertad por nodo
% -   dNfunc: Derivada de la función de forma del elemento
% -   Nfunc: Función de forma del elemento
% -   b : Es la fuerza por unidad de volumen
% -   intOrder: Orden de la cuadratura de Gauss
% Y los datos de salida corresponderá son los siguientes:
% -   k : Es la matriz de rigidez del elemento
% -   f : Es la matriz de fuerzas internas del elemento

[D] = GetContinuumDmatrix(MATprop.E,MATprop.nu,constLaw);
[GP_N,GP_w,GP_xi]=GetGaussQuad(elType,intOrder);
Nne = size(XYZ,1);

switch upper(elType(1))
    
    case 'T'
        [k] = zeros(Nne*DpN);
        [f] = zeros(Nne*DpN,1);
        for i=1:GP_N
            Ei=GP_xi(i,1);
            ni=GP_xi(i,2);
            Wp=GP_w(i);
            dN=dNfunc([Ei ni]);
            N=Nfunc([Ei ni]);
            Ne=zeros(DpN,DpN*Nne);
            Ne(1,1:2:end)=N(1,:);
            Ne(2,2:2:end)=N(1,:);
            [B,detJ] = GetBmatrixContinuum(dN,XYZ);
            k=k+Wp*B'*D*B*MATprop.t*detJ;
            f=f+Wp*Ne'*b*detJ;
        end
end

return