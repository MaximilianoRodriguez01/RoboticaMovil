clear all
close all

% Definir número de celdas
n_celdas = 20;

% Belief inicial: el robot está en la celda 11
bel = [zeros(10, 1); 1; zeros(9, 1)];

% Crear figura
figure;
tiledlayout(4, 4, 'TileSpacing', 'compact');

% Ejecutar 9 comandos de avanzar (+1)
for i = 1:9
    bel = bayes_filter(bel, 1);
    nexttile
    bar(1:n_celdas, bel, 'FaceColor', '#5DADE2');
    title(['Paso ', num2str(i)]);
end

% Luego, 3 comandos de retroceder (-1)
for i = 1:3
    bel = bayes_filter(bel, -1);
    nexttile
    bar(1:n_celdas, bel, 'FaceColor', '#F1948A');
    title(['Retroceso ', num2str(i)]);
end

% Último subplot: belief final
nexttile
bar(1:n_celdas, bel, 'FaceColor', '#58D68D');
title('Belief final');
xlabel('Celda');
ylabel('Belief');

sgtitle('Evolución del belief del robot');


% Funciones usadas
function transicion = transicion(x_ant, x, accion)
    transicion = 0; % Inicializar en cero
    n = 20; % Número de celdas del mundo

    if accion == 1 % moverse a la derecha
        if x_ant == n
            if x == n
                transicion = 1.0;
            end
        elseif x_ant == n-1
            if x == n-1
                transicion = 0.25;
            elseif x == n
                transicion = 0.75;
            end
        else
            if x == x_ant
                transicion = 0.25;
            elseif x == x_ant + 1
                transicion = 0.5;
            elseif x == x_ant + 2
                transicion = 0.25;
            end
        end
    elseif accion == -1 % moverse a la izquierda
        if x_ant == 1
            if x == 1
                transicion = 1.0;
            end
        elseif x_ant == 2
            if x == 1
                transicion = 0.75;
            elseif x == 2
                transicion = 0.25;
            end
        else
            if x == x_ant
                transicion = 0.25;
            elseif x == x_ant - 1
                transicion = 0.5;
            elseif x == x_ant - 2
                transicion = 0.25;
            end
        end
    end
end

function belief_nuevo = bayes_filter(belief_actual, accion)
    n = length(belief_actual);
    belief_nuevo = zeros(n, 1);

    for x = 1:n
        for x_ant = 1:n
            p = transicion(x_ant, x, accion);
            belief_nuevo(x) = belief_nuevo(x) + p * belief_actual(x_ant);
        end
    end

    % Normalización
    belief_nuevo = belief_nuevo / sum(belief_nuevo);
end