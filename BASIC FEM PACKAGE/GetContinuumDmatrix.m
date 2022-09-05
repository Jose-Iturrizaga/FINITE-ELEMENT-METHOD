function [D] = GetContinuumDmatrix(E,nu,constLaw)
% En esta función los datos de entrada son los siguientes:
% -   E     : Modulo de elasticidad
% -   nu    : Coeficiente de poisson
% -   constLaw: Indica el caso de leyes constitutivas
% Y los datos de salida son los siguientes:
% -   D: Matriz constitutiva

prefix = E/(1+nu)/(1-2*nu);
prefix1=E/(1-nu^2);

switch upper(constLaw)
    case '1D'
        D = [ E ];
    case 'PW'
        D = prefix * [ 1-nu ] ;
    case 'PS' 
        D = prefix1*[ 1   nu         0    ;
                     nu    1         0    ;
                      0    0   (1 - nu)/2];
    case 'PE'
        D = prefix * [ 1 - nu     nu        0       ;
                        nu     1 - nu       0       ;
                         0        0    (1 - 2*nu)/2];
    case '3D'
        D = prefix * [1-nu  nu   nu      0          0          0      ;
                       nu  1-nu  nu      0          0          0      ;
                       nu   nu  1-nu     0          0          0      ;
                       0    0    0   (1-2*nu)/2     0          0      ;
                       0    0    0       0      (1-2*nu)/2     0      ;
                       0    0    0       0          0      (1-2*nu)/2];
    otherwise
        error('Constitutive law is unknown')
end

return