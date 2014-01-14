%% Generando los vectores de características para todas las trayectorias
% Se van a tomar tramos de M muestras y obtener en ellos las siguientes
% características:
%%
% * Promedio $\Delta x$
% * Promedio $\Delta y$
% * Desvío estándar $\Delta x$
% * Desvío estándar $\Delta y$
%

clear all; close all; clc;
tamBloque = 10;

%% Defino los parametros para cargar los registros
nombreInicial = 'GPS_xydt_'; 

aux1.nombre = 'Cuadrado';
aux1.repeticiones = 3:7; % Saco los dos primeros porque frenamos en las esquinas
                         % De paso son 5 para cada tipo
aux2.nombre = 'CuadradoLento';
aux2.repeticiones = 1:5;
aux3.nombre = 'CuadradoZigZag';
aux3.repeticiones = 1:5;
aux4.nombre = 'AdelanteAtras';
aux4.repeticiones = 1:5;

registros = {aux1, aux2, aux3, aux4};
contador = 0;

%% Extraigo caracteristicas y armo el dataset

for i = 1:size(registros,2)
    reg = registros{i};
    
    
    for j = 1:size(reg.repeticiones,2)
        rep = reg.repeticiones(j);
        nombArchi = [nombreInicial reg.nombre num2str(rep) '.mat'];
        
        load(nombArchi)
        
        ini = 1;
        fin = tamBloque;
        
        % Si puedo tomar la suficiente cantidad de muestras
        % calculo y agrego una linea al archivo para clasificar
        while fin <= length(pos.x)
            contador = contador + 1;
            xloc = pos.x(ini:fin);
            yloc = pos.y(ini:fin);
            
            % Matriz para calcular los delta x, delta y 
            auxDelta = diag(-ones(tamBloque,1)) +diag(ones(tamBloque-1,1),1);
            auxDelta = auxDelta(1:end-1,:);
            
            dx = auxDelta * xloc;
            dy = auxDelta * yloc;
            
            % Creo un codigo binario para identificar la clase
            % Todos ceros excepto el número de la clase
            auxClase = zeros(size(registros));
            auxClase(i) = 1;
            
            % Extraigo caracteristicas
            auxCarac = [mean(dx) mean(dy) std(dx) std(dy)];
            
            % Guardo los datos a sacar en el archivo
            datos2txt(:,contador) = horzcat(auxCarac, auxClase)';
            
            % Avanzo al bloque siguiente
            ini = ini + tamBloque;
            fin = fin + tamBloque;
        end      
    end
end

%%

% open a file for writing
fileid = fopen(['GPScaracteristicas_TamBloque' num2str(tamBloque) '.txt'], 'w');
%%
clases = [];
for i = 1:size(registros,2)
    clases = [clases ',' registros{i}.nombre];
end
%%
% print a title, followed by a blank line
fprintf(fileid, ['mean(dx),mean(dy),std(dx),std(dy)' clases ',\n\n']);

% print values in column order
% the values appear on each row of the file
fprintf(fileid, '%f,%f,%f,%f,%d,%d,%d,%d\n', datos2txt);
fclose(fileid);