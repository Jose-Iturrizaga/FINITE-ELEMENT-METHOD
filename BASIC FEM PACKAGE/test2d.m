clc, clear, close all

Nx = 4:4:40;
Ny = 4:4:40;
elType = {'Q4' 'Q8' 'Q9' 'T3' 'T6'};
desp=zeros(length(Nx),2*length(elType));
for i=1:length(Nx)
    nx=Nx(i);
    ny=Ny(i);
    for j=1:length(elType)
        desp(i,2*j-1:2*j)=test2D(elType{j},nx,ny);
    end
end
m={'Malla' 'Q4x' 'Q4y' 'Q8x' 'Q8y' 'Q9x' 'Q9y' 'T3x' 'T3y' 'T6x' 'T6y'};
t=array2table([Nx' desp],"VariableNames",m)

function  [desp]=test2D(elType,Nx,Ny)

[NODE,ELEM,SUPP,LOAD,MATprop] = BuildCookModel(Nx,Ny,elType);
constLaw = 'PS';
dispFactor = 0.2;
Nn = size(NODE,1);
dim = size(LOAD,2)-1; % Same as "size(SUPP,2)-1"
[K,k] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw);
f = ParseLoads(LOAD,Nn);
[suppDOF,suppVAL] = ParseSupports(SUPP,Nn);
[u,r,D] = FEMsolve(K,f,suppDOF,suppVAL,dim);
dist = (NODE(:,1)-48).^2 + (NODE(:,2)-52).^2;
[~,ind] = sort(dist);
desp=D(ind(1),1:2);
end