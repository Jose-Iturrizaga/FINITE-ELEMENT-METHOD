function [u,r,D] = FEMsolve(K,f,suppDOF,suppVAL,dim)
% En esta función los datos de entrada son los siguientes:
% -   K     : Matriz de global de rigidez
% -   f       : Vector de fuerzas totales
% -   suppDOF: Nodos restringidos
% -   suppVAL: Valores de desplazamientos restringidos
% -   dim: dimensión de matriz de desplazamientos (2)
% Y los datos de salida son los siguientes:
% -   u : Vector de desplazamientos
% -   r  : Vector de reacciones
% -   D: Matriz de desplazamientos ordenada

Ndof = size(f,1);
freeDOF = setdiff(1:Ndof,suppDOF);

u=zeros(Ndof,1);
u(freeDOF)=K(freeDOF,freeDOF)\(f(freeDOF)-K(freeDOF,suppDOF)*suppVAL);
u(suppDOF)=suppVAL;

r=K(suppDOF,:)*u;
% Displacements in XYZ format
D = reshape(u,dim,numel(u)/dim)';

return