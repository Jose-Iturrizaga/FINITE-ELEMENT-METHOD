function [] = Plot2DTriangleGeometry(xyz,IEN,nodeID,elemID)

% Función que grafica la discretización de un dominio usando elementos
% triangulares de 3 Y 6 nodos.

% DATOS DE ENTRADA

% xyz    = Es la tabla de coordenadas nodales
% IEN    = Es la tabla de conectividad
% nodeID = 'true' indica mostrar enumeración de nodos globales
%          'false' no mostrar enumeración de nodos globales
% elemID = 'true' indica mostrar enumeración de nodos en el centroide
%        = 'false' indica no mostrar enumeración de nodos en el centroide

% DATOS DE SALIDA

% CORRESPONDERA A UN GRÁFICO DEL ELEMENTO A DESEAR

%% Parámetros lógicos para los nodos y elementos

Node_ID = strcmp(nodeID,'true') ;
Elem_ID = strcmp(elemID,'true') ;

%% Procedimiento de gráficos

Coord = triangulation(IEN(:,1:3),xyz) ;
Coord.Points ;
Coord.ConnectivityList ;
triplot(Coord,'Color',[0.5 0.5 0.5],'LineStyle','-','MarkerSize',3,'LineWidth',0.5)
axis equal

%% Datos para la enumeración

[a,b]=size(IEN) ;

%% Enumeración de los nodos globales

if Node_ID == 1
    for j=1:b
        hold on;
        text(xyz(IEN(:,j),1),xyz(IEN(:,j),2),num2str(IEN(:,j)),'HorizontalAlignment',...
            'center','FontSize',10,'Color','b','Clipping','on');
    end
    hold on;
    scatter(xyz(:,1),xyz(:,2),10,'filled');
end

%% Enumeración de los elementos

N_elementos = 1:1:a ;

if Elem_ID == 1
    for i=1:a
        Dx=sum(xyz(IEN(i,1:3),1))/3 ;
        Dy=sum(xyz(IEN(i,1:3),2))/3 ;
        hold on;
        text(Dx,Dy,num2str(N_elementos(i)),'FontSize',10,'Color','b','VerticalAlignment',...
            'middle','HorizontalAlignment','center','Clipping','on') ;
    end
end
end