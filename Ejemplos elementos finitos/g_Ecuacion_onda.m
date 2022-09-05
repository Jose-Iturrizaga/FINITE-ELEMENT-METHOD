% Malla
g = 'squareg';
[p, e, t] = initmesh(g, 'Hmax', 0.25);
 
e = e(1, :);
t = t(1 : 3, :)';
nnodes = size(p, 2);
elem = size(t, 1); 

c = 1;
m = 1;
 
K = zeros(nnodes);
M = zeros(nnodes);
 
% Ensamble
for element = 1 : elem
    nodes = t(element, :);
    P = [ones(1, 3); p(:, nodes)];
    C = inv(P);
    area_of_element = abs(det(P)) / 2;
    grads_phis  = C(:, 2:3);
    xy_mean = mean(p(:, nodes), 2);
    Ke = grads_phis * c * grads_phis' * area_of_element;
    mean_of_phis  = [1/3; 1/3; 1/3];
    Me = m * (mean_of_phis * mean_of_phis') * area_of_element; 
    K(nodes, nodes) = K(nodes, nodes) + Ke;
    M(nodes, nodes) = M(nodes, nodes) + Me;
end
 
% Condición de frontera de Dirichlet
Dirichlet = [1:4, 3, 12:18, 26:32];
K(Dirichlet, :) = 0;
M(Dirichlet, :) = 0;
M(Dirichlet, Dirichlet) = eye(numel(Dirichlet));
 
time = linspace(0.0, 10.0, 1e3);
A = [zeros(nnodes) eye(nnodes); -M \ K zeros(nnodes)];
u_0 = atan(cos(pi/2 * p(1, :)));
du_dt_0 = 3 * sin(pi * p(1, :)) .* exp(sin(pi / 2 * p(2, :)));
Z_initial = [u_0, du_dt_0];
dZ_dt = @(~, Z) A * Z;
[~, Z] = ode45(dZ_dt, time, Z_initial);

Z = Z(:, 1:nnodes);
 
%Grafica
set(gcf, 'color', 'w')
has_been_plot = false;
for z = Z'
    if ~has_been_plot
        has_been_plot = true;
        h = trisurf(t, p(1, :), p(2, :), z, 'EdgeColor', 0.75 * [1 1 1], 'FaceColor', 'interp');
        colormap(jet)
        light
        camlight left
        set(gca, 'Projection', 'perspective')
        axis([-1 1 -1 1 -3 3])
    else
       h.Vertices = [p(1, :)', p(2, :)', z];
       h.CData = z;
    end
    drawnow    
end