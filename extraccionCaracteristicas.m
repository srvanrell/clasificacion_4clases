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
saltoCuadrado = floor(tamBloque/3); % salto en el resto es igual a tamBloque
saltoZigZag = floor(tamBloque/2); % salto en el resto es igual a tamBloque

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
datos2arff = [];

%% Extraigo caracteristicas y armo el dataset

for i = 1:size(registros,2)
    reg = registros{i};
    
    % Genera solapamiento en los registros de Cuadrado para aumentar el
    % numero de muestras
    if i == 1
        salto = saltoCuadrado;
    elseif i == 3
        salto = saltoZigZag;
    else
        salto = tamBloque;
    end
    
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
            
            % Guardo los datos para pasarle a weka

            auxArff = sprintf('%f,%f,%f,%f,%s\n', auxCarac, reg.nombre);
            datos2arff = horzcat(datos2arff, auxArff);
            
            % Avanzo al bloque siguiente
            ini = ini + salto;
            fin = fin + salto;
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





%% Creando el archivo arff
% abro el archivo
fileid = fopen(['GPScaracteristicas_TamBloque' num2str(tamBloque) '.arff'], 'w');

%%
clases = [];
for i = 1:size(registros,2)
    clases = [clases ',' registros{i}.nombre];
end
clases = clases(2:end); % saca la primera coma

% Encabezado y preparacion del terreno
fprintf(fileid, '%% Caracteristicas extraidas de los registros de GPS\n%%\n\n');
fprintf(fileid, '@RELATION gps-caracteristicas-tambloque%d\n\n',tamBloque);
fprintf(fileid, '@ATTRIBUTE mean(dx) REAL\n');
fprintf(fileid, '@ATTRIBUTE mean(dy) REAL\n');
fprintf(fileid, '@ATTRIBUTE std(dx) REAL\n');
fprintf(fileid, '@ATTRIBUTE std(dy) REAL\n');
fprintf(fileid, ['@ATTRIBUTE class{' clases '}\n\n']);
fprintf(fileid, '@DATA\n');

% print values in column order
% the values appear on each row of the file
fprintf(fileid, '%s', datos2arff);
fclose(fileid);