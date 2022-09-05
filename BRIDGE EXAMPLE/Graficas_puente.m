FEM_puente;

%% %%%%%%%%%%%%%%%%%%%%%  GRÁFICAS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%  DISCRETIZACIÓN DEL PUENTE  %%%%%%%%%%%%%%%%%%

%% Ploteamos el puente sin nodos ni elementos

nodeID_1 = 'false' ;   % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'
elemID_1 = 'false' ;   % Cambia entre 'true = Encender elementos' y 'false = Apagar elementos'

figure
Plot2DTriangleGeometry(xyz,IEN,nodeID_1,elemID_1)
title('Discretización del puente mediante elementos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor
xlim([-40 40])
ylim([-2 8])

%% Ploteamos el puente con nodos y sin # elementos

nodeID_2 = 'true' ;    % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'
elemID_2 = 'false' ;   % Cambia entre 'true = Encender elementos' y 'false = Apagar elementos'

figure
Plot2DTriangleGeometry(xyz,IEN,nodeID_2,elemID_2)
title('Puente - Enumeración de nodos globales '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor
xlim([-40 40])
ylim([-2 8])

%% Ploteamos Zoom del puente con nodos y sin # elementos

nodeID_3 = 'true' ;    % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'
elemID_3 = 'false' ;   % Cambia entre 'true = Encender elementos' y 'false = Apagar elementos'

figure
Plot2DTriangleGeometry(xyz,IEN,nodeID_3,elemID_3)
title('Zoom de la enumeración de los nodos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor
xlim([ 3 13])
ylim([ 2 7])

%% Ploteamos el puente sin nodos y con # elementos

nodeID_4 = 'false' ;  % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'
elemID_4 = 'true' ;   % Cambia entre 'true = Encender elementos' y 'false = Apagar elementos'

figure
Plot2DTriangleGeometry(xyz,IEN,nodeID_4,elemID_4)
title('Puente - Enumeración de los elementos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor
xlim([-40 40])
ylim([-2 8])

%% Ploteamos Zoom del puente sin nodos y con # elementos

nodeID_5 = 'false' ;  % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'
elemID_5 = 'true' ;   % Cambia entre 'true = Encender elementos' y 'false = Apagar elementos'

figure
Plot2DTriangleGeometry(xyz,IEN,nodeID_5,elemID_5)
title('Zoom de la enumeración de los elementos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor
xlim([ 3 13])
ylim([ 2 7])

%% %%%%%%%%%%  DISCRETIZACIÓN DEL PUENTE DEFORMADO   %%%%%%%%%%%%%

%% Ploteamos el puente deformado

nodeID_1 = 'false' ;     % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'

figure('Name','Puente deformado');
Plot2DQuadGeometry(xyz,xyzdef,IEN,lambda,nodeID_1)
title('Puente - Deformado '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor; hold on
quiver(xyz(:,1),xyz(:,2),xyzdef(:,1),xyzdef(:,2),lambda/1e3,'b')
xlim([-40 40])
ylim([-2 8])

%% Ploteamos el puente deformado con enumeración de nodos

nodeID_2 = 'true' ;     % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'

figure('Name','Puente deformado - Enumeración de nodos');
Plot2DQuadGeometry(xyz,xyzdef,IEN,lambda,nodeID_2)
title('Puente deformado - Enumeración de nodos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor; hold on
quiver(xyz(:,1),xyz(:,2),xyzdef(:,1),xyzdef(:,2),lambda/1e3,'b')
xlim([-40 40])
ylim([-2 8])

%% Ploteamos Zoom del puente deformado con enumeración de nodos

nodeID_3 = 'true' ;     % Cambia entre 'true = Encender nodos' y 'false = Apagar nodos'

figure('Name','Zoom de puente deformado - Enumeración de nodos');
Plot2DQuadGeometry(xyz,xyzdef,IEN,lambda,nodeID_3)
title('Zoom de puente deformado - Enumeración de nodos '+el,'FontName','Times New Roman','FontSize', 14)
grid on; grid minor; hold on
quiver(xyz(:,1),xyz(:,2),xyzdef(:,1),xyzdef(:,2),lambda/1e3,'b')
xlim([ 3 13])
ylim([ 2 7])