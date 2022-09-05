clc, clear, close all
Lx = 10;
Ly = 1;
Lz = 2;
malla=2:5 ;
Nx = Lx*malla;
Ny = Ly*malla;
Nz = Lz*malla;
elType = {'H8' 'R4'};
desp=zeros(length(Nx),2*length(elType));
for i=1:length(Ny)
    nx=Nx(i);
    ny=Ny(i);
    nz=Nz(i);
    for j=1:length(elType)
        [u_tip, time]=test3D(elType{j},Lx,Ly,Lz,nx,ny,nz);
        desp(i,2*j-1)=u_tip;
        desp(i,2*j)=time;
    end
end
m={'Malla' 'H8u' 'H8t' 'R4u' 'R4t'};
t=array2table([malla' desp],"VariableNames",m)

function  [u_tip, time]=test3D(elType,Lx,Ly,Lz,Nx,Ny,Nz)
constLaw = '3D';
[NODE,ELEM,SUPP,LOAD,MATprop,indTIP] = Build3DCantilever(Lx,Ly,Lz,Nx,Ny,Nz,elType);
Nn = size(NODE,1);
dim = size(LOAD,2)-1; % Same as "size(SUPP,2)-1"
tic
[K,k] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw);
f = ParseLoads(LOAD,Nn);
[suppDOF,suppVAL] = ParseSupports(SUPP,Nn);
[u,r,D] = FEMsolve(K,f,suppDOF,suppVAL,dim);
time=toc;
u_tip = D(indTIP,3);
end