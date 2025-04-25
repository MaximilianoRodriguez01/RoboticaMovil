close all

% filtro discreto de bayes
% el robot se mueve en un mundo 1D de 20 celdas
% el robot se encuentra inicialmente en la celda 10

% En cada paso, el robot puede ejecutar el comando ‘avanzar un paso’ o ‘retroceder un
% paso’. Este movimiento puede tener cierto error, por lo que el resultado puede no siempre
% ser el esperado. De hecho, el robot se comporta de la siguiente manera: al ejecutar
% ‘avanzar un paso’ el resultado ser´a el siguiente:
% el 25 % de las veces, el robot no se mover´a
% el 50 % de las veces, el robot avanzar´a una celda
% el 25 % de las veces, el robot se mover´a dos celdas
% el robot en ning´un caso se mover´a en el sentido opuesto o avanzar´a m´as de dos
% celdas.
% El modelo de ‘retroceder un paso’ es similar, pero en el sentido opuesto. Ya que el mundo
% es acotado, el comportamiento al intentar ‘avanzar un paso’ en los bordes es el siguiente:
% si el robot est´a en la ´ultima celda, al tratar de avanzar se quedar´a en la misma
% celda el 100 % de las veces
% si el robot est´a en la pen´ultima celda, al tratar de avanzar se quedar´a en la misma
% celda el 25 % de las veces, y se mover´a a la pr´oxima celda el 75 % de las veces.
% Lo mismo suceder´a en sentido contrario en el otro extremo del mundo al intentar retroceder.
% Implementar un filtro de Bayes discreto en Octave/MATLAB y estimar la posici´on final
% del robot (belief) despues de ejecutar 9 comandos consecutivos de ‘avanzar un paso’ y
% luego 3 comandos de ‘retroceder un paso’. Graficar el belief resultante de la posici´on del
% robot. Comenzar con el belief inicial de bel=[zeros(10; 1); 1; zeros(9; 1)];.




proba = [0.25; 0.5; 0.25]; % probabilidades de moverse 0, 1 o 2 celdas
n = 20; % número de celdas
bel = [zeros(n, 1); 1; zeros(n-1, 1)]; % creamos el belief inicial





function transicion = transicion(x_ant, x, accion)

    % Probabilidad de moverse de x_ant a x dado la acción
    if accion == 1 % moverse a la derecha
        if x == x_ant
        end
    end
end


function belief_nuevo = bayes_filter(belief_actual, accion)

    n = length(belief_actual);
    belief_nuevo = zeros(n, 1);

    for x = 1:n  % posición actual
        for x_ant = 1:n  % desde dónde pudo haber venido
            p = transicion(x_ant, x, accion); % prob de moverse de x_ant a x
            belief_nuevo(x) = belief_nuevo(x) + p * belief_actual(x_ant);
        end
    end

    % Normalización (suma total debe ser 1)
    belief_nuevo = belief_nuevo / sum(belief_nuevo);
end