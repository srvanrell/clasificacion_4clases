%% Generador de características

close all; clear all;
load('GPSmovil-AdelanteAtras.mat')

%% Pasando a medidas relativas
N = size(COORD_KM, 1);

x = COORD_KM(:,1) - repmat(COORD_KM(1,1),N,1);
y = COORD_KM(:,2) - repmat(COORD_KM(1,2),N,1);

%% km -> m
x = x * 1000;
y = y * 1000;

%% Ploteando
subplot(2,1,1)
plot(x,'*--')
subplot(2,1,2)
plot(y,'*--')

figure
plot(x,y,'*--')
% legend(num2str(1:N))

labels = cellstr( num2str((1:N)') );

text(x, y, labels, 'VerticalAlignment','bottom', ...
                   'HorizontalAlignment','right')