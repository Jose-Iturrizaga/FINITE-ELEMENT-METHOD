elem=4;
E(1:elem)=210*10^9;
area(1:elem)=10*10^-4; %misma área
nodos=[4 4 3 ; 0 4 0 ; 0 4 6 ; 4 0 3 ; 8 -1 1];
UnionNodos=[1 2 ;1 3 ; 1 4 ; 1 5];
%[dx1 dy1 dz1 dx2 dy2 dz2 dx3 dy3 dz3...](0 si está empotrado y 1 si puede moverse)
Desplazamientos=[1 1 1 0 0 0 0 0 0 0 0 0 0 0 0];
%[Fx1 Fy1 Fz1 Fx2 Fy2 Fz2 Fx3 Fy3 Fz3...]
Fuerzas=[0 -10000 0 0 0 0 0 0 0 0 0 0 0 0 0];

L = zeros(1,elem);
Cx = zeros(1,elem);
Cy = zeros(1,elem);
Cz = zeros(1,elem);
LAMBDA = zeros(6,6);

for i = 1:elem
    indice = UnionNodos(i,:);                                   
    P1 = [nodos(indice(1),1) nodos(indice(1),2) nodos(indice(1),3)];
    P2 = [nodos(indice(2),1) nodos(indice(2),2) nodos(indice(2),3)];
    L(i) = norm(P1-P2);
    Cx(i) = (P2(1) - P1(1))/ L(i);
    Cy(i) = (P2(2) - P1(2))/ L(i);
    Cz(i) = (P2(3) - P1(3))/ L(i);
    lambda = [Cx(i)^2 Cx(i)*Cy(i) Cx(i)*Cz(i) ; Cy(i)*Cx(i) Cy(i)^2 Cy(i)*Cz(i) ;...
           Cz(i)*Cx(i) Cz(i)*Cy(i) Cz(i)^2];
    LAMBDA(:,:,i) = [lambda -lambda ; -lambda lambda];
end

k = (E.*area)./L;   
A = zeros(6,6);     

%Ensamble de la matriz global
for i = 1:elem
    A(:,:,i) = k(i)*LAMBDA(:,:,i);
    %Dividimos la matriz A 6x6 en sub matrices de3x3
    j = UnionNodos(i,:);  
    B(:,:,i) = mat2cell(A(:,:,i),[3 3],[3 3]);
    
    %Asignamos cada sub matriz segun indice
    C(j(1),j(1),i) = B(1,1,i);
    C(j(1),j(2),i) = B(1,2,i);
    C(j(2),j(1),i) = B(2,1,i);
    C(j(2),j(2),i) = B(2,2,i);
end
A
S = 3*size(nodos,1);                       
m = cell(S/3,S/3);

for i = 1:size(nodos,1)
    for j = 1:size(nodos,1)
        clear x
        x(:,:,:) = cell2mat(reshape(C(i,j,:),1,[],elem));
        m(i,j) = {sum(x,3)};
        
        %Si esta vacio se asigna 0
        if size(m{i,j}) == [0 0]
            m(i,j) = {zeros(3,3)};
        end        
    end
end

MG = cell2mat(m)          %Convertimos la matriz global en un arreglo numérico

%Reducir la matriz global
v = find(Desplazamientos==0);                   
MGR = MG;
MGR(v,:) = 0;     
MGR(:,v) = 0;
indicefil = zeros(1,S);
indicecol = zeros(1,S);
for i = 1:S
    if MGR(i,:) == 0
        indicefil(i) = i;
    end
    if MGR(:,i) == 0
        indicecol(i) = i;
    end
end

MGR(indicefil~=0,:) = [];    %Eliminar filas y columnas de ceros para tener la matriz global reducida
MGR(:,indicecol~=0) = []
Fuerzas(indicefil~=0) = [];  %Eliminar filas y columnas de ceros de las fuerzas

%Desplazamientos de nodos
d = MGR\Fuerzas';         
dfinal = zeros(S,1);
k = 1;

for i = 1:length(Desplazamientos)
    if Desplazamientos(i) == 0
        dfinal(i,1) = 0;
    else
        dfinal(i,1) = d(k);
        k = k+1;
    end
end

%Resultados

d2 = mat2cell(dfinal,3*ones(1,size(nodos,1)),1); %Dividimos dfinal en paquetes de 3x1
Esfuerzos = zeros(1,elem);
Flocal = zeros(elem,6);
j = 1;
for i = 1:elem
    indice = UnionNodos(i,:);
    Esfuerzos(i) = (E(i)./L(i)) * [-Cx(i) -Cy(i) -Cz(i) Cx(i) Cy(i) Cz(i)] * [d2{indice(1,1)} ; d2{indice(1,2)}];
    Flocal(i,:) = A(:,:,i)*[d2{indice(1,1)} ; d2{indice(1,2)}];
    j = j + 2;
end
                           
Reacciones=reshape(MG*dfinal,[3,5]).'
dfinal = reshape(dfinal,[3,5]).'
Esfuerzos=Esfuerzos'
Flocal