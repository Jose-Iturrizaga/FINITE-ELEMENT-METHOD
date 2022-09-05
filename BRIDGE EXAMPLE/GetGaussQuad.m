function [GP_N,GP_w,GP_xi] = GetGaussQuad(elType,order)
%Función que retorna las distintas cuadraturas de Gauss
% En esta función los datos de entrada son los siguientes:
% -   elType: Tipo de elemento
% -   order : Orden de la cuadratura de Gauss
% Y los datos de salida son los siguientes:
% -   GP_N : Número de puntos de Gauss
% -   GP_w : Pesos asociados
% -   GP_xi: Puntos de Gauss

switch upper(elType(1))
    
    case 'T'
        [GP_xi,GP_w] = GetGaussQuadTria(order);
        GP_N = length(GP_w);
        
    otherwise
        error('Element type not supported')
end
return

%% Internal Quadrature functions

function [GP_xi,GP_w] = GetGaussQuadTria(order)

AParent = 1/2; % Area parent = 0.5 (need to compensate). Check near return.
switch order
    case 1
        GP_xi = [1 1] / 3;
        GP_w  = 1;
        
    case 2
        GP_xi = [2/3 1/6; 1/6 1/6; 1/6 2/3];
        GP_w  = [1/3; 1/3; 1/3];
        
    case 3
        GP_xi = [1/3 1/3; 3/5 1/5; 1/5 1/5; 1/5 3/5];
        GP_w  = [-27/48; 25/48; 25/48; 25/48];
        
    case 4
        a=0.44594849091597;
        b=0.10810301816807;
        c=0.09157621350977;
        d=0.81684757298046;
        e=0.22338158967801;
        f=0.10995174365532;
        GP_xi = [a a;b a;a b;c c;d c;c d];
        GP_w  = [e;e;e;f;f;f];
        
    case 5
        a=0.47014206410511;
        b=0.05971587178977;
        c=0.10128650732346;
        d=0.79742698535309;
        e=0.13239415278851;
        f=0.12593918054483;
        GP_xi = [1/3 1/3;a a;b a;a b;c c;d c;c d];
        GP_w  = [0.225;e;e;e;f;f;f];
        
    case 6
        a=0.24928674517091;
        b=0.50142650965818;
        c=0.06308901449150;
        d=0.87382197101700;
        e=0.31035245103378;
        f=0.63650249912140;
        g=0.05314504984482;
        h=0.11678627572638;
        i=0.05084490637021;
        j=0.08285107561837;
        GP_xi = [a a;a b;b a;c c;c d;d c;e f;f g;g e;f e;e g;g f];
        GP_w  = [h;h;h;i;i;i;j;j;j;j;j;j];
        
    otherwise
        error('GetGaussQuadTria: Rule order n=%g not available',order)
end
GP_w = AParent * GP_w;
return