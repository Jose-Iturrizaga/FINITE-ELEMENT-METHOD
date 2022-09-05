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

generateMesh(symModel,'Hmax',radius/6);
Rsym = solve(symModel);

figure
pdeplot(symModel,'XYData',Rsym.Stress.sxx,'ColorMap','jet');
axis equal