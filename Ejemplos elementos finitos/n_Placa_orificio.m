model = createpde('structural','static-planestress');

radius = 20.0;
width = 50.0;
Length = 200;

%Geometria
R1 = [3 4 -Length  Length ...
           Length -Length ...
          -width -width width width]'; 
C1 = [1 0 0 radius 0 0 0 0 0 0]';

gdm = [R1 C1];
ns = char('R1','C1');
g = decsg(gdm,'R1 - C1',ns');

geometryFromEdges(model,g);%incluir la geometria al modelo

%Parámetros
structuralProperties(model,'YoungsModulus',200E3,...
    'PoissonsRatio',0.25);

%Coniciones de borde
structuralBC(model,'Edge',3,'XDisplacement',0);
structuralBC(model,'Vertex',3,'YDisplacement',0);
structuralBoundaryLoad(model,'Edge',1,'SurfaceTraction',[100;0]);

%Malla
generateMesh(model,'Hmax',radius/6);
figure
pdemesh(model)

R = solve(model);

figure
pdeplot(model,'XYData',R.Stress.sxx,'ColorMap','jet')
axis equal


%Interpolación de esfuerzos
thetaHole = linspace(0,2*pi,200);
xr = radius*cos(thetaHole);
yr = radius*sin(thetaHole);
CircleCoordinates = [xr;yr];

stressHole = interpolateStress(R,CircleCoordinates);

figure
plot(thetaHole,stressHole.sxx)
xlabel('\theta')
ylabel('\sigma_{xx}')
title 'Normal Stress Around Circular Boundary';