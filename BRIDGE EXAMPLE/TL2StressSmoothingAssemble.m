function [M,P] = TL2StressSmoothingAssemble(elType,xyz,xyzdef,IEN,C,lumpedMatrix)

% Función que ensambla la matriz de masa M y la matriz de tensiones P
% correspondiente al método de suavización de tensiones

% DATOS DE ENTRADA

% xyz          = Corresponde a la tabla de coordenadas nodales
% xyzdef      = Corresponde al campo de desplazamientos
% IEN          = Correspondiente a la tabla de conectividad IEN
% C            = Tensor de elasticidad
% lumpedMatrix = 'true' para masas condensada, 'false' para la matriz de
%                masas consistente

% DATOS DE SALIDA

% M = Corresponde a la matriz de masas que puede ser condensada o
%     consistente
% P = Corresponde a la matriz de tensiones

%% Se procede al ensamblaje
Nn = size(xyz,1);
Ne = size(IEN,1);   % #de elementos

switch elType
    
    case 'T3'
        dNfunc = @ShapeDerivT3;
        Nfunc = @ShapeFuncT3;
        M = zeros(Nn,Nn);           % Matriz de almacenamiento M
        P = zeros(Nn,3);            % Matriz de almacenamiento P
        for i=1:Ne
            [me,pe] = P1mepe(elType,xyz(IEN(i,:),:),xyzdef(IEN(i,:),:),...
                C,2,dNfunc,Nfunc,lumpedMatrix);
            edof=IEN(i,:);
            M(edof,edof) = M(edof,edof) + me;
            P(edof,1) = P(edof,1)+pe(:,1);
            P(edof,2) = P(edof,2)+pe(:,2);
            P(edof,3) = P(edof,3)+pe(:,3);
        end
        
    case 'T6'
        dNfunc = @ShapeDerivT6;
        Nfunc = @ShapeFuncT6;
        M = zeros(Nn,Nn);           % Matriz de almacenamiento M
        P = zeros(Nn,3);            % Matriz de almacenamiento P
        for i=1:Ne
            [me,pe] = P1mepe(elType,xyz(IEN(i,:),:),xyzdef(IEN(i,:),:),...
                C,4,dNfunc,Nfunc,lumpedMatrix);
            edof=IEN(i,:);
            M(edof,edof) = M(edof,edof) + me;
            P(edof,1) = P(edof,1)+pe(:,1);
            P(edof,2) = P(edof,2)+pe(:,2);
            P(edof,3) = P(edof,3)+pe(:,3);
        end
end
end