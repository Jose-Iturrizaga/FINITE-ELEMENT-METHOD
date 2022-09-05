L  = 1; H  = 1; %Geometría
NEX = 20; NEY = 20; % Malla
NELE = NEX * NEY; % # elementos
NODES = (NEX+1) * (NEY+1); % # nodos

% Relación de la numeración local y global de los nodos
[DomNodeID] = NodeIndex(NELE,NEX,NEY);

% Cálculo de las coordenadas de los puntos nodales
tanALFA=1/0.0;
DX=L/NEX;
DY=H/NEY;
for ix=1:NEX
    for jy=1:NEY
        iele=(ix-1)*NEY+jy;
        xloc(1)=(ix-1)*DX+(jy-1)*DY/(tanALFA);
        xloc(2)=xloc(1)+DX;
        xloc(3)=xloc(2)+DY/(tanALFA);
        xloc(4)=xloc(1)+DY/(tanALFA);
        yloc(1)=(jy-1)*DY;
        yloc(2)=yloc(1);
        yloc(3)=yloc(2)+DY;
        yloc(4)=yloc(3);

        for ilnode=1:4
            ignode=DomNodeID(ilnode,iele);
            X(ignode)=xloc(ilnode);
            Y(ignode)=yloc(ilnode);
        end
    end
end

A = zeros(NODES, NODES);
b = zeros(NODES, 1);
for iele = 1:NELE
%Calcula la Matriz Elemental
[Aelem, belem] =  GetElemAb(iele,DomNodeID,X,Y);
  for ilnode = 1:4
      ignode = DomNodeID(ilnode,iele);
    for jlnode = 1:4
        jgnode = DomNodeID(jlnode,iele);
       A(ignode, jgnode) = A(ignode, jgnode) + Aelem(ilnode, jlnode);
    end
       b(ignode) = b(ignode) + belem(ilnode);
  end
end

% Busqueda de los nodos en el  contorno del dominio ( T(0,y) = T(1,y)= T(x,0) = T(x,1)= 0.0)
BdBox = [0 L 0 H];
eps = 0.01*sqrt((BdBox(2)- BdBox(1))*(BdBox(4)- BdBox(3))/size(X,1));
CC = find(abs(X(1,:)-BdBox(3))<eps | abs(X(1,:)-BdBox(4))<eps ...
    | abs(Y(1,:)-BdBox(1))< eps | abs(Y(1,:)-BdBox(2)) < eps);  
A (CC,:) = []; b(CC) = [];
T = A\b;

figure(2)
plot3(X,Y,T','b.'); grid on;
tri = delaunay(X,Y);
figure
contourTri(tri,X,Y,T',50)
colormap jet 
colorbar

function [Aelem, belem] = GetElemAb(iele,DomNodeID,X,Y)
Aelem = zeros(4,4);
belem = zeros(4,1);

%Cuadratura de Gauss
NGP=3;
WGP=[0.555,0.888,0.555];
XGP = [ -0.7745966, 0.0, 0.7745966]; 

% Valor elemental de las coordenadas de los nodos
for ilnode = 1:4
    ignode = DomNodeID(ilnode,iele);
    XY(1,ilnode) = X(ignode);
    XY(2,ilnode) = Y(ignode);
end
for igp = 1:NGP
XI = XGP(igp);
WI = WGP(igp);
  for jgp = 1:NGP
      NETA = XGP(jgp);
      WJ =WGP(jgp);
      W = WI*WJ; 
      Phi = [  ((NETA-1)*(XI-1))/4; -((NETA-1)*(XI+1))/4;
            ((NETA+1)*(XI+1))/4; -((NETA+1)*(XI-1))/4];
      GradPhi=[ (NETA-1)/4  -(NETA-1)/4  (NETA+1)/4   -(NETA+1)/4;
                (XI-1)/4    -(XI+1)/4    (XI+1)/4     -(XI-1)/4];
      JAC = GradPhi * XY';
      JACinv = inv(JAC);
      JACdet = det(JAC);
      %calculando GradPhixy (derivada en relacion a x e y de las funciones base)
      GradPhixy = JACinv*GradPhi;
      for ilnode = 1:4
          for jlnode = 1:4   
          Ae =  W*JACdet*(GradPhixy(1,ilnode)*GradPhixy(1,jlnode) + ...
                          GradPhixy(2,ilnode)*GradPhixy(2,jlnode));
          Aelem(ilnode,jlnode) = Aelem(ilnode,jlnode) + Ae;
          end
          belem(ilnode) =  1.0;
      end
  end     
end
end

function [DomNodeID] = NodeIndex(NELE,NEX,NEY)
DomNodeID = zeros(4,NELE);
NodeCount = 1;
for iele = 1:NELE    
    iWestEle = 0;
    iSouthEle = 0;   
    % Elemento de la izquierda
    if (iele > NEY) 
        iWestEle = iele - NEY; 
    end   
    % Elemento de arriba
    iSouth = mod(iele-1,NEY);
    if (iSouth == 0)
        iSouthEle = 0;
    else
        iSouthEle = iele-1;
    end       
    if (iWestEle ~= 0) %nodos comunes con elemento izquierdo
        DomNodeID(1,iele) = DomNodeID(2,iWestEle);
        DomNodeID(4,iele) = DomNodeID(3,iWestEle);
    end        
    if (iSouthEle ~= 0) %nodos comunes con elemento superior    
        DomNodeID(1,iele) = DomNodeID(4,iSouthEle);
        DomNodeID(2,iele) = DomNodeID(3,iSouthEle); 
    end        
    for ilnode = 1:4    
        if (DomNodeID(ilnode,iele) == 0) 
            DomNodeID(ilnode,iele) = NodeCount;
            NodeCount = NodeCount + 1;
        end
    end
end
end

function contourTri(t,x,y,f,N)
Interval = 50; % nr of intervals for a uniform mesh
[X Y] = meshgrid(min(x(:)):(max(x(:))-min(x(:)))/Interval:max(x(:)), ...
        min(y(:)):(max(y(:))-min(y(:)))/Interval:max(y(:)));
Z = X.*0-1.3e10;
% go through triangles and interpolate mesh points:
for i=1:size(t,1)
    x1 = x(t(i,1)); x2 = x(t(i,2)); x3 = x(t(i,3));
    y1 = y(t(i,1)); y2 = y(t(i,2)); y3 = y(t(i,3));
    z1 = f(t(i,1)); z2 = f(t(i,2)); z3 = f(t(i,3));
    inp  = inpolygon(X,Y,[x1 x2 x3 x1], [y1 y2 y3 y1]);
    ids  = find(inp(:));
    for j=1:length(ids)        
        A = 0.5*det([1 1 1;x1 x2 x3;y1 y2 y3]);
        B = [x2*y3-x3*y2 y2-y3 x3-x2; x3*y1-x1*y3 y3-y1 x1-x3;
             x1*y2-x2*y1 y1-y2 x2-x1];
        Xi = 1/(2*A)*B*[1 X(ids(j)) Y(ids(j))]';
        xi1 = Xi(1); xi2 = Xi(2); xi3 = Xi(3);              
        Z(ids(j)) = [z1 z2 z3]*[xi1 xi2 xi3]';
    end
end
Z((Z==-1.3e10)) = NaN;
contour(X,Y,Z,N)
end