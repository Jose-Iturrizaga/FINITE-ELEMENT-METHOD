symModel = createpde('structural','static-planestress');

radius = 20.0;
width = 50.0;
Length = 200;

R1 = [3 4 0 Length/2 Length/2 ...
      0 0 0 width width]';
C1 = [1 0 0 radius 0 0 0 0 0 0]'; 
gm = [R1 C1];
sf = 'R1-C1';
ns = char('R1','C1');
g = decsg(gm,sf,ns');
geometryFromEdges(symModel,g);

structuralProperties(symModel,'YoungsModulus',200E3, ...
    'PoissonsRatio',0.25);

structuralBC(symModel,'Edge',[3 4],'Constraint','symmetric');
structuralBoundaryLoad(symModel,'Edge',1,'SurfaceTraction',[100;0]);

for i=10:10:100
    mesh = generateMesh(symModel,'Hmax',radius/i);
    Rsym = solve(symModel);
    [Stress] = Rsym.Stress.sxx;
    [Sigma_max,index_max] = max(Stress); 
    sigma(i/10)=Sigma_max;
    nnodos(i/10)=size(mesh.Nodes,2);
    nelemen(i/10)=size(mesh.Elements,2);
    Size(i/10)=radius/i;
end

figure
plot(nelemen,sigma)
xlabel('Número de elementos')
ylabel('\sigma_{xx}')
figure
plot(nnodos,sigma)
xlabel('Número de nodos')
ylabel('\sigma_{xx}')
figure
plot(Size,sigma)
xlabel('Tamaño de malla')
ylabel('\sigma_{xx}')

table(Size',nnodos',nelemen',sigma',...
    'VariableNames',{'Tamaño de malla',...
    'Número de nodos','Número de elementos','σxx'})

mesh = generateMesh(symModel,'Hmax',0.3);
Rsym = solve(symModel);
[Stress] = Rsym.Stress.sxx;
[Sigma_max,index_max] = max(Stress)

table(0.3,size(mesh.Nodes,2),size(mesh.Elements,2),Sigma_max,...
    'VariableNames',{'Tamaño de malla',...
    'Número de nodos','Número de elementos','σxx'})
