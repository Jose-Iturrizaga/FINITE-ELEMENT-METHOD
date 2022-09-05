nodos = [0 0;5 7;5 0;10 7;10 0;15 0];
conn = [1 2;1 3;2 3;2 4;2 5;3 5;4 5;4 6;5 6];

A=5e-3;
E=210e6;

p=[3 20];

nn=size(nodos,1);
ndof=2*nn; %grados de libertad

f=zeros(ndof,1);
f(p(1))=p(2);

isol=[3 4 5 6 7 8 9 10]; %simplifica matriz en nodos libres

ne=size(conn,1);

K=zeros(ndof,ndof);
d=zeros(ndof,1);

for e=1:ne
    n1 = conn(e,1);
    n2 = conn(e,2);
    L = norm(nodos(n2,:)-nodos(n1,:));
    C = (nodos(n2,1)-nodos(n1,1))/L; %cos
    S = (nodos(n2,2)-nodos(n1,2))/L; %sin
    ke = (A*E/L) * [C^2 C*S -C^2 -C*S; C*S S^2 -C*S -S^2;
                    -C^2 -C*S C^2 C*S; -C*S -S^2 C*S S^2];
    
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2]; %posicion en matriz global
    K(sctr,sctr) = K(sctr,sctr) + ke;
    
end

d(isol) = K(isol,isol)\f(isol);

f = K*d;
sigma=zeros(ne,1);

for e=1:ne
    n1 = conn(e,1);
    n2 = conn(e,2);
    L = norm(nodos(n2,:)-nodos(n1,:));
    C = (nodos(n2,1)-nodos(n1,1))/L; %cos
    S = (nodos(n2,2)-nodos(n1,2))/L; %sin
    B = E/L*[-C -S C S];
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2];
    sigma(e) = B*d(sctr);
end

clf
sclf=1000; %escala deformacion

for e=1:ne
    n1 = conn(e,1);
    n2 = conn(e,2);
    x1 = nodos(n1,1); y1 = nodos(n1,2);
    x2 = nodos(n2,1); y2 = nodos(n2,2);
    u1 = d(2*n1-1); v1 = d(2*n1);
    u2 = d(2*n2-1); v2 = d(2*n2);
    plot([x1, x2],[y1, y2],'k--');
    plot([x1, x2]+sclf*[u1, u2],[y1, y2]+sclf*[v1,v2],'b');
    hold on
end
title('Gráfica Deformación')
axis equal

Fuerzas = reshape(f,[2,nn]).'
Desplazamientos = reshape(d,[2,nn]).'
sigma

