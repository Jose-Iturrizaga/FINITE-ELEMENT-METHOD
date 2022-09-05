% Malla de 2 elementos
global geom connec nel nne nnd RI RE
nnd = 13; % # de nodos

%Coordenadas de nodos

geom = ...
[RI 0.;                                         % node 1
RI*cos(pi/8) RI*sin(pi/8);                      % node 2
RI*cos(pi/4) RI*sin(pi/4);                      % node 3
RI*cos(3*pi/8) RI*sin(3*pi/8);                  % node 4
RI*cos(pi/2) RI*sin(pi/2);                      % node 5
(RI+RE)/2 0.;                                   % node 6
((RI+RE)/2)*cos(pi/4) ((RI+RE)/2)*sin(pi/4);	% node 7
((RI+RE)/2)*cos(pi/2) ((RI+RE)/2)*sin(pi/2);    % node 8
RE 0.;                                          % node 9
RE*cos(pi/8) RE*sin(pi/8);                      % node 10
RE*cos(pi/4) RE*sin(pi/4);                      % node 11
RE*cos(3*pi/8) RE*sin(3*pi/8);                  % node 12
RE*cos(pi/2) RE*sin(pi/2)];                     % node 13

nel = 2; % # de elementos
nne = 8; % # de nodos por elemento

% Conexiones

connec = [1 6 9 10 11 7 3 2;     % Element 1
            3 7 11 12 13 8 5 4]; % Element 2