function [B,detJ] = GetBmatrixContinuum(dN,XYZ)
% En esta función los datos de entrada son los siguientes:
% -   dN    : Derivada de la función de forma del elemento
% -   XYZ   : Corresponde a las coordenadas del elemento 
% Y los datos de salida son los siguientes:
% -   B     : Matriz de deformaciones Be 
% -   detJ  : Determinante del Jacobiano

nne=length(XYZ);
switch size(XYZ,2)
    case 1
        J=dN*XYZ;
        detJ=J;
        dNdx=J\dN;
        B=dNdx;
        
    case 2
        J=dN*XYZ;
        detJ=det(J);
        dNdx=J\dN;
        B=zeros(3,nne*2);
        B(1,1:2:end)=dNdx(1,:);
        B(2,2:2:end)=dNdx(2,:);
        B(3,1:2:end)=dNdx(2,:);
        B(3,2:2:end)=dNdx(1,:);
        
    case 3
        J=dN*XYZ;
        detJ=det(J);
        dNdx=J\dN;
        B=zeros(6,nne*3);
        B(1,1:3:end)=dNdx(1,:);
        B(2,2:3:end)=dNdx(2,:);
        B(3,3:3:end)=dNdx(3,:);
        B(4,2:3:end)=dNdx(3,:);
        B(4,3:3:end)=dNdx(2,:);
        B(5,1:3:end)=dNdx(3,:);
        B(5,3:3:end)=dNdx(1,:);
        B(6,1:3:end)=dNdx(2,:);
        B(6,2:3:end)=dNdx(1,:);
        
    otherwise
        error('GetBmatrixContinuum: Problem dimensions must be 1, 2 or 3')
end
return