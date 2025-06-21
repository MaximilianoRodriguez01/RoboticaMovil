function cost = edge_cost(parent, child, map)

  threshold = 0.8;

  % Chequear si la celda hija está ocupada
  if map(child(1), child(2)) < threshold
<<<<<<< HEAD
      % Calcular distancia euclidiana
=======
      % Calcular distancia euclidiana penalizando probabilidades mayores de
      % estar ocupadas
>>>>>>> d66fcafcf78105ccb3b90682fa4eec19d6cc7cde
  cost = sqrt((child(1) - parent(1))^2 + (child(2) - parent(2))^2) + 100 * map(child(1), child(2));
  else
      % Penalizar celdas ocupadas
      cost = 1e6;
  end
end
