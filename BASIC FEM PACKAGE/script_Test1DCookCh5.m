clc, clear, close all

Lx = 7;
c = 3;
P = 11;
elType_list = {'L2','L3','L4'};
Nx_list = [1 2];

constLaw = '1D';

x_list = cell(numel(elType_list),numel(Nx_list));
ux_list = cell(numel(elType_list),numel(Nx_list));
r_supp = nan(numel(elType_list),numel(Nx_list));

Xaxis_label = cell(1,numel(Nx_list));
for j=1:numel(Nx_list)
    Nx = Nx_list(j);
    Xaxis_label{j} = sprintf('%.0f',Nx);
    
    for i=1:numel(elType_list)
        elType = elType_list{i};
        [NODE,ELEM,SUPP,LOAD,MATprop] = Build1DbarCookCh5(Lx,Nx,c,P,elType);
        
        Nn = size(NODE,1);
        dim = size(LOAD,2)-1; % Same as "size(SUPP,2)-1"
        
        [K,k] = GetGlobalK(NODE,ELEM,MATprop,elType,constLaw);
        f = ParseLoads(LOAD,Nn);
        [suppDOF,suppVAL] = ParseSupports(SUPP,Nn);
        [u,r] = FEMsolve(K,f,suppDOF,suppVAL,dim);
        
        % Store tip displacement
        x_list{i,j} = NODE;
        ux_list{i,j} = u;
        r_supp(i,j) = r;
    end
    fprintf('Done with Nx = %g\n',Nx)
end

A = MATprop.A;
E = MATprop.E;
x_exact = linspace(0,Lx,36);
u_exact = P/(A*E)*x_exact + c*Lx^2/(2*A*E)*x_exact - c/(6*A*E)*x_exact.^3;

figure, hold on, grid on, box on
palette = lines(numel(elType_list));
linetype = {'-','-.',':'};
k = 0;
for i=1:numel(elType_list)
    for j=1:length(Nx_list)
        plot(x_list{i,j},ux_list{i,j},linetype{j},'Color',palette(i,:),'LineWidth',1.25)
        k = k + 1;
        legendstr{k} = sprintf('%g x %s',Nx_list(j),elType_list{i});
    end
end
legendstr{k+1} = 'Exact';
plot(x_exact,u_exact,'k','LineWidth',1.25)
legend(legendstr,'Location','NorthWest')
ylabel('u_x'), xlabel('x')