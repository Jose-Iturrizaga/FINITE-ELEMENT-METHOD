close all; clear; clc;

%% Cargamos los datos de nodos y conectividad de elementos

elType = 'T6';
tic
[xyz,IEN,SUPP,Qaplic] = puente(elType);

%% Se tienen los siguientes datos

E = 2.6*10^6;       % Módulo de Elasticidad [tn/m2]
v = 0.20 ;          % Coeficiente de Poisson
esp = 1 ;           % Espesor fuera del plano [m]
bx = 0 ;            % Fuerzas sobre volumen [tonf/m3] en la direccion x
by = -2 ;           % Fuerzas sobre volumen [tonf/m3] en la direccion y
q = -5 ;            % Carga distribuida [ton/m2]
MATprop=struct('E',E,'nu',v,'t',esp);

%% Calculando el Vector de fuerzas internas b y carga distribuida t

b = [bx; by];   % Vector de fuerzas por volumen
tx = 0   ;      % Carga en la dirección x [tonf/m]
ty = q*esp ;    % Corresponde a la carga distribuida por metro lineal [tonf/m]
t = [tx; ty];   % Vector de fuerzas por carga q

%% Calculando el valor del tensor C y matriz de masa

constLaw= 'PS';     % Caso tensiones planas
[C] = GetContinuumDmatrix(MATprop.E,MATprop.nu,constLaw);
lumpedMatrix = 'false' ; % 'false' para masas consistente,

%% Variables para los datos de salida

lambda = 300 ;      % Factor de amplificación

if strcmp(elType,'T3'),       el="T3";
elseif strcmp(elType,'T6'),   el="T6";
end

if strcmp(constLaw,'PS'),       d="Tensiones planas";
elseif strcmp(constLaw,'PE'),   d="Deformaciones planas";
end

if strcmp(lumpedMatrix,'true'),         ma="Masa condensada";
elseif strcmp(lumpedMatrix,'false'),    ma="Masa consistente";
end

%% Encontramos los valores de la matriz de rigidez K y de fuerzas internas f

[K,f] = GetGlobalK(xyz,IEN,MATprop,elType,constLaw,b);

%% Calculamos las longitudes entre cada punto

L=arrayfun(@(i) norm(xyz(Qaplic(i+1),:) - xyz(Qaplic(i),:)),1:length(Qaplic)-1);

%% Calculando las fuerzas sobre la superficie del elemento

fex = zeros(length(f),1) ;

if strcmp(elType,'T3')          % fe=L*t/2 *[tx;ty;tx;ty]
    for i=1:length(L)
        ndof=[2*Qaplic(i)-1; 2*Qaplic(i); 2*Qaplic(i+1)-1; 2*Qaplic(i+1)];
        fex(ndof,1)=fex(ndof,1)+L(i)/2*[t;t];
    end
    
elseif strcmp(elType,'T6')      % fe=L*t/6 *[tx;ty;4*tx;4*ty;tx;ty]
    for i=1:2:length(L)
        ndof=[2*Qaplic(i)-1; 2*Qaplic(i);
            2*Qaplic(i+1)-1; 2*Qaplic(i+1);
            2*Qaplic(i+2)-1; 2*Qaplic(i+2);];
        fex(ndof,1)=fex(ndof,1)+L(i)/6*[t;4*t;t];
    end
end

%% La fuerza aplicada en general es

Ft = f + fex ;

%% Definiendo los nodos y desplazamientos restringidos

suppDOF=zeros(2*length(SUPP),1);
suppDOF(1:2:end)=arrayfun(@(i) 2*SUPP(i)-1,1:length(SUPP));
suppDOF(2:2:end)=arrayfun(@(i) 2*SUPP(i),1:length(SUPP));
suppVAL = zeros(length(suppDOF),1);

%% Calculando las deformaciones aplicando F=K*u

[u,r,xyzdef] = FEMsolve(K,Ft,suppDOF,suppVAL,2);

%% CÁLCULO DE TENSIONES
%% Aplicando la función para calcular M y P
[M,P] = TL2StressSmoothingAssemble(elType,xyz,xyzdef,IEN,C,lumpedMatrix);

%% Calculando M*S = P

Sigmaxx = M\P(:,1);   % Tensión Normal en xx
Sigmayy = M\P(:,2);   % Tensión Normal en yy
Tauxy   = M\P(:,3);   % Corte en xy

Sigma_1  =  (Sigmaxx + Sigmayy)/2 + ( ((Sigmaxx - Sigmayy)/2).^2 + Tauxy.^2 ).^0.5 ;   % Tensión principal 1
Sigma_2  =  (Sigmaxx + Sigmayy)/2 - ( ((Sigmaxx - Sigmayy)/2).^2 + Tauxy.^2 ).^0.5 ;   % Tensión principal 2
Sigma_VM =  (Sigmaxx.^2 - Sigmaxx.*Sigmayy + Sigmayy.^2 + 3*Tauxy.^2 ).^0.5 ;          % Tensión de Von Misses
toc
%% Entrega de resultados máximos y mínimos

maxi = max(Sigma_VM);
mini = min(Sigma_VM);

disp('======================================================================')
fprintf(d+': Tensión máxima de Von Mises [tonf/m2] usando '+ma+'\n\n');
display(round(maxi,4));disp(' ')
disp('======================================================================')
fprintf(d+': Tensión mínima de Von Mises [tonf/m2] usando '+ma+'\n\n');
display(round(mini,4));disp(' ')
disp('======================================================================')

%% Punto de control P

disp('======================================================================')
fprintf('Desplazamientos y tensiones en los puntos de control "P" \n\n');

n = [122;17;281;262];
Punto=n;
Coord_xyz=xyz(n,:);
Deformacion=xyzdef(n,:);
Ampl=lambda*ones(length(n),1);
Coord_final=(xyz(n,:)+lambda*xyzdef(n,:));
Sigma1=Sigma_1(n);
Sigma2=Sigma_2(n);
SigmaVM=Sigma_VM(n);

Tabla = table(Punto,Coord_xyz,Deformacion,Ampl,Coord_final,Sigma1,Sigma2,SigmaVM);
disp(Tabla);disp(' ');

disp('======================================================================')