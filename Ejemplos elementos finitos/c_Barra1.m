E=70e6;
L=[1 2 1];
A=0.005;
nodos= 4;
conex = [1 2;2 3;3 4];
f=[2 -10;4 15]; %nodo y fuerza

elem = size(L,2);
K=zeros(nodos);

for i=1:elem
    ke=E*A/L(i)*[1 -1;-1 1];
    m=conex(i,1);
    n=conex(i,2);
    K(m,m) = K(m,m) + ke(1,1);
    K(m,n) = K(m,n) + ke(1,2);
    K(n,m) = K(n,m) + ke(2,1);
    K(n,n) = K(n,n) + ke(2,2);
end
K

%Fuerzas nodo
F=zeros(nodos,1);
F(f(1,1))=f(1,2);
F(f(2,1))=f(2,2);

%Desplazamientos nodo
u=zeros(nodos,1);

a=2:4; %simplificación de matriz
u(a)=K(a,a)\F(a)
F=K*u

Ue=zeros(elem,2);
Fe=zeros(elem,2);
Se=zeros(elem,2);

for i=1:elem
    ke=E*A/L(i)*[1 -1;-1 1];
    ue=[u(conex(i,1)); u(conex(i,2))];
    fe=ke*ue;
    sigmae=fe/A;
    Ue(i,1)=ue(1);
    Ue(i,2)=ue(2);
    Fe(i,1)=fe(1);
    Fe(i,2)=fe(2);
    Se(i,1)=sigmae(1);
    Se(i,2)=sigmae(2);
end

t2=table([1:elem]',conex(:,1),conex(:,2),Fe(:,1),Se(:,1),'VariableNames',{'Elemento','Nodo1','Nodo2','Fuerza','Esfuerzo'})