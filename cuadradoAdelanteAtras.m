close all; clear all;

%% Cargo el registro completo (registros concatenados con tiempos muertos)
tipo = 'AdelanteAtras';
load(['GPSmovil-' tipo '.mat'])
dt = 1;

%% Instantes de inicio y final de recorridos
inicio = [ 35 186 313 448 565];
final  = [157 296 436 562 698];

%% km -> m
x = COORD_KM(:,1);
y = COORD_KM(:,2);

x = x * 1000;
y = y * 1000;

%% Extrayendo recorridos y guardo en .mat individual
for i=1:length(inicio)
    pos.x = x(inicio(i):final(i));
    pos.y = y(inicio(i):final(i));
    
    %% Pasando a medidas relativas al punto inicial
    pos.x = pos.x - pos.x(1);
    pos.y = pos.y - pos.y(1);
    
    %% Guardo pos.x, pos.y, dt    
    save(['GPS_xydt_' tipo num2str(i) '.mat'],'pos','dt');
    
    plot(pos.x,pos.y,'*--')
    labels = cellstr( num2str((inicio(i):final(i))') );
    text(pos.x, pos.y, labels, 'VerticalAlignment','bottom', ...
                               'HorizontalAlignment','right')
    
    pause
end
