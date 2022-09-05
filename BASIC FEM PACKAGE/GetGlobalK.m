function [K,DpN] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw)
% En esta función los datos de entrada son los siguientes:
% -   NODE   : Matriz de coordenadas nodales
% -   ELEM  : Tabla de conectividad
% -   MATprop: Propiedades elásticas del material
% -   elType: Tipo de elemento
% -   constLaw: Indica el caso de leyes constitutivas
% Y los datos de salida son los siguientes:
% -   K : Corresponde a la matriz de rigidez global ensamblada
% -   DpN  : Grados de libertad por nodo

Nn = size(NODE,1);
Ne = size(ELEM,1);
elType = upper(elType);
%% === Shape functions and integration defaults ===
switch elType
    case 'L2'
        dNfunc = @ShapeDerivL2;
        DpN = 1; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum1('L',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,1);
            edof=[ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'L3'
        dNfunc = @ShapeDerivL3;
        DpN = 1; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum1('L',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,2);
            edof=[ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'L4'
        dNfunc = @ShapeDerivL4;
        DpN = 1; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum1('L',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,4);
            edof=[ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'Q4'
        dNfunc = @ShapeDerivQ4;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum2('Q',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,2);
            edof=[2*ELEM(i,:)-1; 2*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'Q8'
        dNfunc = @ShapeDerivQ8;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum2('Q',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,3);
            edof=[2*ELEM(i,:)-1; 2*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'Q9'
        dNfunc = @ShapeDerivQ9;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum2('Q',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,3);
            edof=[2*ELEM(i,:)-1; 2*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'T3'
        dNfunc = @ShapeDerivT3;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum2('T',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,2);
            edof=[2*ELEM(i,:)-1; 2*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'T6'
        dNfunc = @ShapeDerivT6;
        DpN = 2; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum2('T',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,3);
            edof=[2*ELEM(i,:)-1; 2*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'H8'
        dNfunc = @ShapeDerivH8;
        DpN = 3; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum3('H',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,2);
            edof=[3*ELEM(i,:)-2;3*ELEM(i,:)-1;3*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    case 'R4'
        dNfunc = @ShapeDerivR4;
        DpN = 3; % DOF per node
        K = sparse(DpN*Nn,DpN*Nn);
        for i=1:Ne
            [ke] = intK_continuum3('R',NODE(ELEM(i,:),:),...
                MATprop,constLaw,DpN,dNfunc,1);
            edof=[3*ELEM(i,:)-2;3*ELEM(i,:)-1;3*ELEM(i,:)];
            K(edof,edof) = K(edof,edof) + ke;
        end
        
    otherwise
        error('Element %s not supported',elType)
end

return