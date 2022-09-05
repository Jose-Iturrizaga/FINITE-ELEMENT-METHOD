FEM_puente;

%% Reordenamos para la triangulación de T6

if strcmp(elType,'T6')
    IENN(:,1)=IEN(:,1);
    IENN(:,2)=IEN(:,4);
    IENN(:,3)=IEN(:,2);
    IENN(:,4)=IEN(:,5);
    IENN(:,5)=IEN(:,3);
    IENN(:,6)=IEN(:,6);
    
else
    IENN=IEN;
end

%% %%%%%%%%%%%%%%%%%%%%%  GRÁFICAS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%  CAMPO DE TENSIONES  %%%%%%%%%%%%%%%%%%%%%%%

%% Ploteando resultados de Tensiones normales x

figure ('Name',ma+': Tensiones Sigma_xx');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigmaxx,'FaceColor','flat');
title({ma+': Tensiones \sigma_{xx} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \sigma_{xx} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigmaxx,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% Ploteando resultados de Tensiones normales y

figure ('Name',ma+': Tensiones Sigma_yy');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigmayy,'FaceColor','flat');
title({ma+': Tensiones \sigma_{yy} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \sigma_{yy} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigmayy,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% Ploteando resultados de Tensiones cortantes

figure ('Name',ma+': Tensiones Tauxy');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Tauxy,'FaceColor','flat');
title({ma+': Tensiones \tau_{xy} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \tau_{xy} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Tauxy,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% Ploteando resultados de Tensiones principales sigma 1

figure ('Name',ma+': Tensión Principal Sigma_1');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_1,'FaceColor','flat');
title({ma+': Tensiones \sigma_{1} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \sigma_{1} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_1,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% Ploteando resultados de Tensiones principales sigma 2

figure ('Name',ma+': Tensión Principal Sigma_2');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_2,'FaceColor','flat');
title({ma+': Tensiones \sigma_{2} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \sigma_{2} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_2,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% Ploteando resultados de Tensiones principales de Von Mises

figure ('Name',ma+': Tensión de Von Mises: Sigma_VM');hold on;
subplot(2,1,1)
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_VM,'FaceColor','flat');
title({ma+': Tensiones \sigma_{VM} - Sin Suavizar '+el});
colormap('jet'); colorbar;grid on; grid minor; shading flat; hold off
axis equal
xlim([-40 40])
ylim([-2 8])
subplot(2,1,2)
title({ma+': Tensiones \sigma_{VM} - Suavizado '+el});
patch('faces',IENN,'vertices',xyz,'facevertexcdata',Sigma_VM,'FaceColor','interp');
colormap('jet'); colorbar;grid on; grid minor; shading interp; hold off
axis equal
xlim([-40 40])
ylim([-2 8])

%% %%%%%%%  Puntos en donde el material es propenso a fallar  %%%%%%%%%%%%%

nodeID = 'true'  ;
elemID = 'false' ;

%% Zoom superior (de 1 solo arco)

figure ('Name',ma+' para '+d+' - Zoom 1');hold on;
Plot2DStress(xyz,IENN,Sigma_VM,nodeID,elemID);
title({ma+' para '+d+': Zoom 1 - Enumeración '+el});
axis equal
xlim([-10 -6])
ylim([3 7])

%% Zoom izquierda (de 1 solo pilar)

figure ('Name',ma+' para '+d+' - Zoom 2');hold on;
Plot2DStress(xyz,IENN,Sigma_VM,nodeID,elemID);
title({ma+' para '+d+': Zoom 2 - Enumeración '+el});
axis equal
xlim([-16 -10])
ylim([-1 5])

%% Zoom derecha (de 1 solo pilar)

figure ('Name',ma+' para '+d+' - Zoom 3');hold on;
Plot2DStress(xyz,IENN,Sigma_VM,nodeID,elemID);
title({ma+' para '+d+': Zoom 3 - Enumeración '+el});
axis equal
xlim([26 32])
ylim([-1 5])