function [me,pe] = P1mepe(elType,xeset,ueset,C,intOrder,dNfunc,Nfunc,lumpedMatrix)

% Función que entrega la matriz de masas 'me' y la matriz de tensiones 'pe'
% para el caso de elasticidad de tensiones planas de un elemento tipo tri3

% DATOS DE ENTRADA

% elType       = Tipo de elemento
% xeset        = Corresponde a las coordenadas nodales
% ueset        = Corresponde a los desplazamientos nodales
% C            = Es el Tensor de elasticidad
% intOrder     = Valor para Integracion Numerica(Cuadratura de Gauss)
% dNfunc       = Derivada de la función de forma del elemento
% Nfunc        = Función de forma del elemento
% lumpedMatrix = 'true' indica matriz masas condensada, 'false' indica matriz
%                masas consistente

% DATOS DE SALIDA

% me = Matriz de masas que puede ser condensada o consistente
% pe = Matriz de Tensiones

[GP_N,GP_w,GP_xi]=GetGaussQuad(elType,intOrder);
Nne = size(xeset,1);
ue=reshape(ueset',[],1);

%% Calculamos las tensiones
[pe] = zeros(Nne,3);
[me] = zeros(Nne);

%% Matriz de masas consistente y masas condensada

ro = 1;      % Caso de Tensiones Planas
t = 1;       % Caso de Tensiones Planas

for i=1:GP_N
    Ei=GP_xi(i,1);
    ni=GP_xi(i,2);
    Wp=GP_w(i);
    dN=dNfunc([Ei ni]);
    [B,detJ] = GetBmatrixContinuum(dN,xeset);
    sigma = C*B*ue;
    N=Nfunc([Ei ni]);
    pe(:,1)=pe(:,1)+sigma(1,1)*Wp*N'*detJ;
    pe(:,2)=pe(:,2)+sigma(2,1)*Wp*N'*detJ;
    pe(:,3)=pe(:,3)+sigma(3,1)*Wp*N'*detJ;
    
    if strcmp(lumpedMatrix,'true')
        me=me+diag(sum(ro*t*Wp*(N'*N)*detJ,2));
    elseif strcmp(lumpedMatrix,'false')
        me=me+ro*t*Wp*(N'*N)*detJ;
    end
end