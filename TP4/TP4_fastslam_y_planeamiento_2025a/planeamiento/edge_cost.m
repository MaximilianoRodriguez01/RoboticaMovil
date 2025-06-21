function cost = edge_cost(parent, child, map)

  threshold = 0.8;

  % Chequear si la celda hija está ocupada
  if map(child(1), child(2)) < threshold
      % Calcular distancia euclidiana
  cost = sqrt((child(1) - parent(1))^2 + (child(2) - parent(2))^2) + 100 * map(child(1), child(2));
  else
      % Penalizar celdas ocupadas
      cost = 1e6;
  end
end
