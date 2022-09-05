model = createpde('structural','static-planestress');

R1 = [3 4 0 3 3 0 0 0 3.5 3.5]'; 
C1 = [1 1.5 3.5 1.5 0 0 0 0 0 0]';
C2 = [1 1.5 3.5 1 0 0 0 0 0 0]';

gdm = [R1 C1 C2];
ns = char('R1','C1','C2');
[g,dl] = decsg(gdm,'(R1 + C1) - C2',ns');
h=csgdel(g,dl);

geometryFromEdges(model,h);

structuralProperties(model,'YoungsModulus',30E6,...
    'PoissonsRatio',0.3);

structuralBC(model,'Edge',1,'Constraint','fixed');
structuralBoundaryLoad(model,'Edge',[8,9],'SurfaceTraction',[0;100]);

for i=4:4:60
    mesh = generateMesh(model,'Hmax',1/i);
    R = solve(model);
    [Stress] = R.Stress.syy;
    [Sigma_max,i_max] = max(Stress);
    [Dy] = R.Displacement.y;
    [Uy_max,j_max] = max(Dy); 
    sigma(i/4)=Sigma_max;
    uy(i/4)=Uy_max;
    nnodos(i/4)=size(mesh.Nodes,2);
    nelemen(i/4)=size(mesh.Elements,2);
    Size(i/4)=1/i;
    i
end

figure
plot(nelemen,sigma)
xlabel('Número de elementos')
ylabel('\sigma_{yy}')
figure
plot(nnodos,sigma)
xlabel('Número de nodos')
ylabel('\sigma_{yy}')
figure
plot(Size,sigma)
xlabel('Tamaño de malla')
ylabel('\sigma_{yy}')

figure
plot(nelemen,uy)
xlabel('Número de elementos')
ylabel('uy')
figure
plot(nnodos,uy)
xlabel('Número de nodos')
ylabel('uy')
figure
plot(Size,uy)
xlabel('Tamaño de malla')
ylabel('uy')

table(Size',nnodos',nelemen',sigma',uy',...
    'VariableNames',{'Tamaño de malla',...
    'Número de nodos','Número de elementos','σyy','uy'})

mesh = generateMesh(model,'Hmax',0.01);
    R = solve(model);
    [Stress] = R.Stress.syy;
    [Sigma_max,i_max] = max(Stress);
    [Dy] = R.Displacement.y;
    [Uy_max,j_max] = max(Dy); 

table(0.01,size(mesh.Nodes,2),size(mesh.Elements,2),Sigma_max,...
    Uy_max,'VariableNames',{'Tamaño de malla',...
    'Número de nodos','Número de elementos','σyy','uy'})

figure
pdeplot(model,'XYData',R.Stress.syy,'ColorMap','jet')
axis equal

figure
pdeplot(model,'XYData',R.Displacement.y,'ColorMap','jet')
axis equal
