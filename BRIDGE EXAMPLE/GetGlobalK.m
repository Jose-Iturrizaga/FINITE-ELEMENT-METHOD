function [K,f] = GetGlobalK(xyz,IEN,MATprop,elType,constLaw,b)
% En esta función los datos de entrada son los siguientes:
% -   xyz   : Matriz de coordenadas nodales
% -   IEN  : Tabla de conectividad
% -   MATprop: Propiedades elásticas del material
% -   elType: Tipo de elemento
% -   constLaw: Indica el caso de leyes constitutivas
% -   b : Es la fuerza por unidad de volumen
% Y los datos de salida son los siguientes:
% -   K : Corresponde a la matriz de rigidez global ensamblada
% -   K : Corresponde a la matriz de fuerzas internas global ensamblada

Nn = size(xyz,1);
Ne = size(IEN,1);
elType = upper(elType);
%% === Shape functions and integration defaults ===
switch elType
    
    case 'T3'
        dNfunc = @ShapeDerivT3;
        Nfunc = @ShapeFuncT3;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        f=zeros(DpN*Nn,1);
        for i=1:Ne
            [ke,fe] = intK_continuum2('T',xyz(IEN(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,Nfunc,b,1);
            edof=[2*IEN(i,:)-1; 2*IEN(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
            f(edof,1) = f(edof,1) + fe;
        end
        
    case 'T6'
        dNfunc = @ShapeDerivT6;
        Nfunc = @ShapeFuncT6;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        f=zeros(DpN*Nn,1);
        for i=1:Ne
            [ke,fe] = intK_continuum2('T',xyz(IEN(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,Nfunc,b,2);
            edof=[2*IEN(i,:)-1; 2*IEN(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
            f(edof,1) = f(edof,1) + fe;
        end
        
    otherwise
        error('Element %s not supported',elType)
end

return