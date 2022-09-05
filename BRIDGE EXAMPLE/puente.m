function [xyz,elem,SUPP,Qaplic] = puente(elType)

% Función que entrega la data inicial el problema

% DATOS DE SALIDA
% xyz   = Matriz de coordenadas de nodos
% elem  = Matriz de conctividad de elementos
% SUPP  = Vector de nodos restringidos
% elem  = Vector de nodos donde se aplica la carga q

%% Definimos las formas básicas

pol1=[2 20 ...
    -35 35 35 29 29 19 19 13 13 3 3 -3 -3 -13 -13 -19 -19 -29 -29 -35 ...
    6  6  0  0  1  1  0  0  1 1 0  0  1   1   0   0   1   1   0   0]';
E1=[4 -24 1 5 4 0]';
E2=[4  -8 1 5 4 0]';
E3=[4   8 1 5 4 0]';
E4=[4  24 1 5 4 0]';

E1 = [E1;zeros(length(pol1) - length(E1),1)];
E2 = [E2;zeros(length(pol1) - length(E2),1)];
E3 = [E3;zeros(length(pol1) - length(E3),1)];
E4 = [E4;zeros(length(pol1) - length(E4),1)];
gd=[pol1 E1 E2 E3 E4];

ns = char('pol1','E1','E2','E3','E4');
ns = ns';
sf = 'pol1-E1-E2-E3-E4'; % Combinación de figuras
dl = decsg(gd,sf,ns);  % Creación de la nueva geometría

%% Añadimos la geometría al modelo

model = createpde;  % Nuevo modelo
geometryFromEdges(model,dl);

%% Generamos la malla

switch elType
    
    case 'T3'
        m1 = generateMesh(model,'GeometricOrder','linear','Hmax',0.5);
        xyz=m1.Nodes';
        elem=m1.Elements';
        SUPP = findNodes(m1,'region','Edge',[12 13 14 15 16]);
        Qaplic = findNodes(m1,'region','Edge',[1]);
        
    case 'T6'
        m2 = generateMesh(model,'GeometricOrder','quadratic','Hmax',0.5);
        xyz=m2.Nodes';
        elem=m2.Elements';
        SUPP = findNodes(m2,'region','Edge',[12 13 14 15 16]);
        Qaplic = findNodes(m2,'region','Edge',[1]);     
end