k=[170 170 170 170];
conex = [1 2;2 3;2 3;3 4];  
nodos= 4;
f=[4 25]; %nodo y fuerza

elem = size(k,2);
K=zeros(nodos);

%Ensamble
for i=1:elem
    ke=k(i)*[1 -1;-1 1];
    m=conex(i,1);
    n=conex(i,2);
    K(m,m) = K(m,m) + ke(1,1);
    K(m,n) = K(m,n) + ke(1,2);
    K(n,m) = K(n,m) + ke(2,1);
    K(n,n) = K(n,n) + ke(2,2);
end

%Fuerzas nodo
F=zeros(nodos,1);
F(f(1))=f(2);

%Desplazamientos nodo
u=zeros(nodos,1);

a=2:4; %simplificación de matriz
u(a)=K(a,a)\F(a);
F=K*u;

t1=table([1:nodos]',F(:,1),u(:,1),'VariableNames',{'Nodos','Fuerza','Dezplazamiento'})

Ue=zeros(elem,2);
Fe=zeros(elem,2);
T=cell(elem,1);

for i=1:elem
    ke=k(i)*[1 -1;-1 1];
    ue=[u(conex(i,1)); u(conex(i,2))];
    fe=ke*ue;
    Ue(i,1)=ue(1);
    Ue(i,2)=ue(2);
    Fe(i,1)=fe(1);
    Fe(i,2)=fe(2);
    if fe(1)>0
        T{i}='Compresión';
    else
        T{i}='Tensión';
    end
end

t2=table([1:elem]',conex(:,1),conex(:,2),abs(Fe(:,1)),T,'VariableNames',{'Elemento','Nodo1','Nodo2','Fuerza','Tipo'})