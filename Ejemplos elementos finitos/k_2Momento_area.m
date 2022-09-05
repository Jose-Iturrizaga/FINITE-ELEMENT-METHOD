global geom connec nel nne nnd RI RE

RI = 40; % Radio Interno
RE = 70; % Radio Externo

k_Malla2 % Datos de entrada

% Numero de puntos de Gauss
ngp = 3; % polinomios de grado 5

% Valores de x y pesos asociados
samp=zeros(ngp,2);

if ngp==1
    samp=[0. 2];
elseif ngp==2
    samp=[-1/sqrt(3) 1; 1/sqrt(3) 1];
elseif ngp==3
    samp= [-.2*sqrt(15) 5/9; 0 8/9; .2*sqrt(15) 5/9];
elseif ngp==4
    samp= [-0.861136311594053 0.347854845137454; 
            -0.339981043584856 0.652145154862546;
            0.339981043584856 0.652145154862546;
            0.861136311594053 0.347854845137454];
end

Ixx = 0.;

for k=1:nel
    coord=zeros(nne,2);%coordenadas del elemento
    for i=1: nne
        coord(i,:)=geom(connec(k,i),:);
    end
    
    X = coord(:,1);
    Y = coord(:,2);

    for i=1:ngp
        xi = samp(i,1);
        WI = samp(i,2);
        for j =1:ngp
            eta = samp(j,1);
            WJ = samp(j,2);
            [der,fun] = fmquad(samp, i,j);
            JAC = der*coord; % jacobiano
            DET =det(JAC);
            Ixx =Ixx+ (dot(fun,Y))^2*WI*WJ*DET;
        end
    end
end
Ixx 

function[der,fun] = fmquad(samp, ig,jg)
%vector de funcion de forma y derivadas
xi=samp(ig,1);
eta=samp(jg,1);
etam=(1.-eta);
etap=(1.+eta);
xim=(1.-xi);
xip=(1.+xi);

fun(1) = -0.25*xim*etam*(1.+ xi + eta);
fun(2) = 0.5*(1.- xi^2)*etam;
fun(3) = -0.25*xip*etam*(1. - xi + eta);
fun(4) = 0.5*xip*(1. - eta^2);
fun(5) = -0.25*xip*etap*(1. - xi - eta);
fun(6) = 0.5*(1. - xi^2)*etap;
fun(7) = -0.25*xim*etap*(1. + xi - eta);
fun(8) = 0.5*xim*(1. - eta^2);

der(1,1)=0.25*etam*(2.*xi + eta); der(1,2)=-1.*etam*xi;
der(1,3)=0.25*etam*(2.*xi-eta); der(1,4)=0.5*(1-eta^2);
der(1,5)=0.25*etap*(2.*xi+eta); der(1,6)=-1.*etap*xi;
der(1,7)=0.25*etap*(2.*xi-eta); der(1,8)=-0.5*(1.-eta^2);

der(2,1)=0.25*xim*(2.*eta+xi); der(2,2)=-0.5*(1. - xi^2);
der(2,3)=-0.25*xip*(xi-2.*eta); der(2,4)=-1.*xip*eta;
der(2,5)=0.25*xip*(xi+2.*eta); der(2,6)=0.5*(1.-xi^2);
der(2,7)=-0.25*xim*(xi-2.*eta); der(2,8)=-1.*xim*eta;
end