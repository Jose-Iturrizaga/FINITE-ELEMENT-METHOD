clc, clear, close all

Lx = 10;
Ly = 1;
Lz = 2;

Nx = 16;
Ny = 2;
Nz = 4;

elType = 'R4';  %{'H8' 'R4'}
constLaw = '3D';
dispFactor = 10e2;

[NODE,ELEM,SUPP,LOAD,MATprop,indTIP] = Build3DCantilever(Lx,Ly,Lz,Nx,Ny,Nz,elType);

Nn = size(NODE,1);
dim = size(LOAD,2)-1; % Same as "size(SUPP,2)-1"

fprintf('--- Running FEM analysis...\n')
tic
[K,k] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw);
f = ParseLoads(LOAD,Nn);
[suppDOF,suppVAL] = ParseSupports(SUPP,Nn);
[u,r,D] = FEMsolve(K,f,suppDOF,suppVAL,dim);
fprintf('DONE! FEM analysis took: %g seconds\n',toc)

figure('Color','w'), hold('on')
PlotDomain3(NODE,ELEM,SUPP,LOAD,[0.00 0.64 0.91])
PlotDomain3(NODE+dispFactor*D,ELEM,[],[],[1.00 0.50 0.15])
view(-30,20), rotate3d('on'), axis('equal','tight'), box('on')
xlabel('X'), ylabel('Y'), zlabel('Z'), drawnow

figure('Color','w'), hold('on')
% PlotDomain3(NODE,ELEM,SUPP,LOAD,[0.00 0.64 0.91])
PlotDomain3(NODE+dispFactor*D,ELEM,[],[],[1.00 0.50 0.15])
view(-30,20), rotate3d('on'), axis('equal','tight'), box('on')
xlabel('X'), ylabel('Y'), zlabel('Z'), drawnow

P = sum(LOAD(:,4));
L = Lx;
I = Ly*Lz^3/12;
E = MATprop.E;
u_anal = P*L^3/(3*E*I);

fprintf('u_tip  = %g\nu_anal = %g\n',D(indTIP,3),u_anal)