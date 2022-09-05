clc, clear, close all

Nx = 4;
Ny = 4;
elType = 'T6';  %{'Q4' 'Q8' 'Q9' 'T3' 'T6'}
[NODE,ELEM,SUPP,LOAD,MATprop] = BuildCookModel(Nx,Ny,elType);
constLaw = 'PS';
dispFactor = 0.2;

Nn = size(NODE,1);
dim = size(LOAD,2)-1; % Same as "size(SUPP,2)-1"

[K,k] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw);
f = ParseLoads(LOAD,Nn);
[suppDOF,suppVAL] = ParseSupports(SUPP,Nn);
[u,r,D] = FEMsolve(K,f,suppDOF,suppVAL,dim);

figure, hold on, axis equal, box on, grid on
PlotDomain2(NODE,ELEM,elType,SUPP,LOAD,[0.00 0.64 0.91])
PlotDomain2(NODE + dispFactor*D(:,1:2),ELEM,elType,[],[],[1.00 0.50 0.15])
axis('tight')
drawnow

% Search for node C
dist = (NODE(:,1)-48).^2 + (NODE(:,2)-52).^2;
[~,ind] = sort(dist);
fprintf('Displacements at point C are: [ %g %g ]\n',D(ind(1),1:2))