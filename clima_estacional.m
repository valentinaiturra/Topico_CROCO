clc
clear all
close all

datos=ncread('SST_estacional_Promedio.nc','SST');

LON_DATA=ncread('SST_estacional_Promedio.nc','X');
LAT_DATA=ncread('SST_estacional_Promedio.nc','Y');

%%


LON_CROCO=ncread("lon_rho.nc",'lon_rho');
LAT_CROCO=ncread("lat_rho.nc",'lat_rho');

modelo= ncread("temp_estacional_sup_mean.nc",'temp');
modelo(find(modelo == 0)) = NaN;

%%
%Encontrar las lat y long que corresponden al modelo realizado
difx=abs(min(LON_CROCO(:,1))-LON_DATA);
dify=abs(min(LAT_CROCO(1,:))-LAT_DATA);
minx=min(difx);
miny=min(dify);
poslon1=find(difx == minx);
poslat1=min(find(dify == miny));
clear difx dify

difx=abs(max(max(LON_CROCO))-LON_DATA);
dify=abs(max(max(LAT_CROCO))-LAT_DATA);
minx=min(difx);
miny=min(dify);
poslon2=find(difx == minx);
poslat2=min(find(dify == miny));

AA = datos(poslon1:poslon2,poslat1:poslat2);

%% 
[x,y]=meshgrid(1:139,1:160);
[u,v]=meshgrid(linspace(1,139,44),linspace(1,160,43));
NUEVA=interp2(x,y,AA,u,v);

    cmap_points = [0 0 1; % Azul
               1 1 1; % Blanco
               1 0 0]; % Rojo

french_flag_grad = interp1([1, 128, 256], cmap_points, linspace(1, 256, 256));

ERROR = modelo - NUEVA;

ERROR_vec = ERROR(:);

edges = min(ERROR_vec):0.2:max(ERROR_vec);


    figure()
%subplot(2,2,1)
    contourf(LON_CROCO,LAT_CROCO,NUEVA)
    %shading flat
    colormap(cmocean('thermal'))
    caxis([14 22]);
    colorbar
    hold on
    contour(LON_CROCO,LAT_CROCO, isnan(NUEVA),[0.1 0.1], 'k','Linewidth', 1)
    ylabel(colorbar,'Temperatura °C')
    xlabel('Longitud')
    ylabel('Latitud')
    title("Datos")
%subplot(2,2,2)
    figure()
    contourf(LON_CROCO,LAT_CROCO,modelo)
    %shading flat
    colormap(cmocean('thermal'))
    caxis([14 22]);
    colorbar
    hold on
    contour(LON_CROCO,LAT_CROCO, isnan(modelo),[0.1 0.1], 'k','Linewidth', 1)
    ylabel(colorbar,'Temperatura °C')
    xlabel('Longitud')
    ylabel('Latitud')
    title("Modelo")
%subplot(2,2,3)
    figure()
    contourf(LON_CROCO,LAT_CROCO,ERROR)
    %shading flat
    colormap(gca,french_flag_grad)
    caxis([-3 3]);
    colorbar
    hold on
        contour(LON_CROCO,LAT_CROCO, isnan(ERROR),[0.1 0.1], 'k','Linewidth', 1)
    ylabel(colorbar,'Temperatura °C')
    xlabel('Longitud')
    ylabel('Latitud')
    title("Error")
%subplot(2,2,4)
figure()
    histogram(ERROR_vec,edges,'Normalization','probability','FaceColor','b')
    hold on 
    xline(2,'LineWidth',2,'Color','r')
    xline(-2,'LineWidth',2,'Color','r')
    axis tight
    legend('Porcentaje de error','Límites de error aceptable','Location','northwest')
    ylabel('Probabilidad')
    xlabel('Error')
    title('Histograma de error')

