function [Isrc,Jsrc] = pos_rio(filename,lon_rio,lat_rio)
%filename = croco_grd.nc
%lon_rio = longitud del rio que se va a modelar
%lat_rio = latitud del rio que se va a modelar


%%
%maskp=ncread(filename,'mask_psi');
latp=ncread(filename,'lat_rho');
lonp=ncread(filename,'lon_rho');

%%
[~, Jsrc] = min(abs(latp(1,:) - lat_rio))
[~, Isrc] = min(abs(lonp(:,1) - lon_rio))

end
