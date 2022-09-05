global nnd nel nne nodof eldof n
global geom connec dee nf Nodal_loads
global Length Width NXE NYE X_origin Y_origin dhx dhy

format long g

Length = 60.;
Width =20.;
NXE = 24; % #elementos x
NYE = 10; % #elementos y
dhx = Length/NXE;
dhy = Width/NYE;
X_origin = 0 ;
Y_origin = Width/2 ;

nne = 3; % #nodos elemento
nodof = 2; % grados de libertad nodo
eldof = nne*nodof;

%Malla
nnd = 0;
k = 0;
for i = 1:NXE
    for j=1:NYE
        k = k + 1;
        n1 = j + (i-1)*(NYE + 1);
        geom(n1,:) = [(i-1)*dhx - X_origin (j-1)*dhy - Y_origin ];
        n2 = j + i*(NYE+1);
        geom(n2,:) = [i*dhx - X_origin (j-1)*dhy - Y_origin ];
        n3 = n1 + 1;
        geom(n3,:) = [(i-1)*dhx - X_origin j*dhy - Y_origin ];
        n4 = n2 + 1;
        geom(n4,:) = [i*dhx- X_origin j*dhy - Y_origin ];
        nel = 2*k;
        m = nel -1;
        connec(m,:) = [n1 n2 n3];
        connec(nel,:) = [n2 n4 n3];
        nnd = n4;
    end
end

% Propiedades Material
E = 200000.; % Modulo de Young
vu = 0.3; % Coeficiente Poisson
thick = 5; % Grosor (mm)

c=E/(1.-vu*vu);
dee=c*[1 vu 0. ; vu 1 0. ; 0. 0. .5*(1.-vu)];

%Condiciones de frontera
nf = ones(nnd, nodof); 
% Restringe los nodos donde x = Length
for i=1:nnd
    if geom(i,1) == Length;
        nf(i,:) = [0 0];
    end
end

n=0; for i=1:nnd
    for j=1:nodof
        if nf(i,j) ~= 0
            n=n+1;
            nf(i,j)=n;
        end
    end
end

% Cargas
Nodal_loads= zeros(nnd, 2); 
% Aplicar la carga en los nodos donde X = Y =0.
Force = 1000.; % N
for i=1:nnd
    if geom(i,1) == 0. && geom(i,2) == 0.
        Nodal_loads(i,:) = [0. -Force];
    end
end

%Ensamble
fg=zeros(n,1);
for i=1: nnd
    if nf(i,1) ~= 0
        fg(nf(i,1))= Nodal_loads(i,1);
    end
    if nf(i,2) ~= 0
        fg(nf(i,2))= Nodal_loads(i,2);
    end
end

kk = zeros(n, n);
for i=1:nel
    global eldof
    [bee,g,A] = elem_T3(i);
    ke=thick*A*bee'*dee*bee;
    for i=1:eldof
        if g(i) ~= 0
            for j=1: eldof
                if g(j) ~= 0
                    kk(g(i),g(j))= kk(g(i),g(j)) + ke(i,j);
                end
            end
        end
    end
end
delta = kk\fg ; % Solucion

%Desplazamiento de nodos
for i=1: nnd
    if nf(i,1) == 0
        x_disp =0.;
    else
        x_disp = delta(nf(i,1));
    end
    %
    if nf(i,2) == 0 
        y_disp = 0;
    else
        y_disp = delta(nf(i,2));
    end
    node_disp(i,:) =[x_disp y_disp];
end

k = 0;
vertical_disp=zeros(1,NXE+1);
for i=1:nnd;
    if geom(i,2)== 0.
        k=k+1;
        x_coord(k) = geom(i,1);
        vertical_disp(k)=node_disp(i,2);
    end
end
%
for i=1:nel
    [bee,g,A] = elem_T3(i); %Coord. del elemento y vector
    eld=zeros(eldof,1);
    for m=1:eldof
        if g(m)==0
            eld(m)=0.;
        else
            eld(m)=delta(g(m)); % Desplazamiento de elemento
        end
    end
    eps=bee*eld;
    EPS(i,:)=eps ;
    sigma=dee*eps;
    SIGMA(i,:)=sigma ; % Esfuerzos
end

%Gráfica
x_stress = SIGMA(:,1);
cmin = min(x_stress);
cmax = max(x_stress);
caxis([cmin cmax]);
patch('Faces', connec, 'Vertices', geom, 'FaceVertexCData',x_stress, ...
    'Facecolor','flat','Marker','o');
colorbar;

function[bee,g,A] = elem_T3(i)
global nnd nel nne nodof eldof n
global geom connec dee nf load

x1 = geom(connec(i,1),1); y1 = geom(connec(i,1),2);
x2 = geom(connec(i,2),1); y2 = geom(connec(i,2),2);
x3 = geom(connec(i,3),1); y3 = geom(connec(i,3),2);
A = (0.5)*det([1 x1 y1; 1 x2 y2; 1 x3 y3]);

m11 = (x2*y3 - x3*y2)/(2*A);
m21 = (x3*y1 - x1*y3)/(2*A);
m31 = (x1*y2 - y1*x2)/(2*A);
m12 = (y2 - y3)/(2*A);
m22 = (y3 - y1)/(2*A);
m32 = (y1 - y2)/(2*A);
m13 = (x3 - x2)/(2*A);
m23 = (x1 - x3)/(2*A);
m33 = (x2 -x1)/(2*A);

bee = [m12 0 m22 0 m32 0;0 m13 0 m23 0 m33;m13 m12 m23 m22 m33 m32];%
l=0;
for k=1:nne
    for j=1:nodof
        l=l+1;
        g(l)=nf(connec(i,k),j);
    end
end
end