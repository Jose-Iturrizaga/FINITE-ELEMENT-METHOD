k=[200e6*0.01/2 1000 ];
f=[2 25];
nodos= 3;
conex = [1 2;2 3];
f=[2 25]; %nodo y fuerza

elem = size(k,2);
K=zeros(nodos);

for i=1:elem
    ke=k(i)*[1 -1;-1 1];
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
F(f(1))=f(2);

%Desplazamientos nodo
u=zeros(nodos,1);

a=2; %simplificación de matriz
u(a)=K(a,a)\F(a);
F=K*u;

t1=table([1:nodos]',F(:,1),u(:,1),'VariableNames',{'Nodos','Fuerza','Dezplazamiento'})

Ue=zeros(elem,2);
Fe=zeros(elem,2);

for i=1:elem
    ke=k(i)*[1 -1;-1 1];
    ue=[u(conex(i,1)); u(conex(i,2))];
    fe=ke*ue;
    Ue(i,1)=ue(1);
    Ue(i,2)=ue(2);
    Fe(i,1)=fe(1);
    Fe(i,2)=fe(2);
end

sigma1=Fe(1,:)/0.01
f2=Fe(2,:)

%t2=table([1:elem]',conex(:,1),conex(:,2),Fe(:,1),[Fe(1,:)/0.01;'-'],'VariableNames',{'Elemento','Nodo1','Nodo2','Fuerza','Esfuerzo'})