close all; clear all;

%% Cargo el registro completo (registros concatenados con tiempos muertos)
tipo = 'Cuadrado';
load(['GPSmovil-' tipo '.mat'])
dt = 1;

%% Instantes de inicio y final de recorridos
inicio = [12 136 250 344 429 550 610];
final  = [68 190 290 382 467 585 644];

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

% close all; clear all;
% 
% %% Recorridos Cuadrado
% inicio = [12 136 250 344 429 550 610];
% final  = [68 190 290 382 467 585 644];
% 
% %% Generador de características
% load('GPSmovil-Cuadrado.mat')
% 
% %% Pasando a medidas relativas
% N = size(COORD_KM, 1);
% 
% x = COORD_KM(:,1) - repmat(COORD_KM(1,1),N,1);
% y = COORD_KM(:,2) - repmat(COORD_KM(1,2),N,1);
% 
% %% km -> m
% x = x * 1000;
% y = y * 1000;
% 
% %% Extrayendo trayectorias
% 
% for i=1:length(inicio)
%     pos.x = x(inicio(i):final(i));
%     pos.y = y(inicio(i):final(i));
%     registros{i} = pos;
%     
%     plot(pos.x,pos.y,'*--')
%     labels = cellstr( num2str((inicio(i):final(i))') );
%     text(pos.x, pos.y, labels, 'VerticalAlignment','bottom', ...
%                                'HorizontalAlignment','right')
%     
%     pause
% end
