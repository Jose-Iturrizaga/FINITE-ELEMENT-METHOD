function [k] = intK_continuum3(elType,XYZ,MATprop,constLaw,DpN,dNfunc,intOrder)
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
Nne = size(XYZ,1);

switch upper(elType(1))
    
    case 'H'
        [k] = zeros(Nne*DpN);
        for i=1:GP_N
            Ei=GP_xi(1,i);
            ni=GP_xi(2,i);
            ui=GP_xi(3,i);
            Wp=GP_w(i);
            dN=dNfunc([Ei ni ui]);
            [B,detJ] = GetBmatrixContinuum(dN,XYZ);
            k=k+Wp*B'*D*B*detJ;
        end
        
    case 'R'
        [k] = zeros(Nne*DpN);
        for i=1:GP_N
            Ei=GP_xi(i,1);
            ni=GP_xi(i,2);
            ui=GP_xi(i,3);
            Wp=GP_w(i);
            dN=dNfunc([Ei ni ui]);
            [B,detJ] = GetBmatrixContinuum(dN,XYZ);
            k=k+Wp*B'*D*B*detJ;
        end
end

return