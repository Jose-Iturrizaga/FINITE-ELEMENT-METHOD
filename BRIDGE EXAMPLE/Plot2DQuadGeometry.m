function [] = Plot2DQuadGeometry(xyz,xyzdef,IEN,lambda,nodeID)

% Función que grafica la discretización de un dominio usando elementos
% triangulares de 3 nodos, muestra la deformada.

% DATOS DE ENTRADA

% xyz    = Es la tabla de coordenadas nodales
% xyzdef = Es la tabla de coordenadas nodales deformadas
% Lambda = Factor de Amplificación
% IEN    = Es la tabla de conectividad

% DATOS DE SALIDA

% CORRESPONDERA A UN GRÁFICO DEL ELEMENTO A DESEAR

%% Parámetros lógicos para los nodos y elementos

Node_ID = strcmp(nodeID,'true') ;

%% Aplicando el factor de amplificación

xyzdef = xyz+lambda*xyzdef;

%% Procedimiento de gráficos

Coord = triangulation(IEN(:,1:3),xyz) ;
Coordef = triangulation(IEN(:,1:3),xyzdef) ;
Coord.Points ;
Coord.ConnectivityList ;
hold on
axis equal
triplot(Coord,'Color',[0.5 0.5 0.5],'LineStyle','--','MarkerSize',3,'LineWidth',0.5)
triplot(Coordef,'Color','r','LineStyle','-','MarkerSize',3,'LineWidth',1.0')

%% Datos para la enumeración

[a,b]=size(IEN) ;

%% Enumeración de los nodos globales

if Node_ID == 1
    for j=1:b
        hold on;
        text(xyz(IEN(:,j),1),xyz(IEN(:,j),2),num2str(IEN(:,j)),'HorizontalAlignment',...
            'center','FontSize',8,'Color','k','Clipping','on');
    end
    hold on;
    scatter(xyz(:,1),xyz(:,2),10,'filled');
end
end