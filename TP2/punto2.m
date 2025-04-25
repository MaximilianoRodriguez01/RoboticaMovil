clear all
close all


n = 5000;

x_t = [2; 4; pi/2];
u_t = [pi/4; 0; 1];

alpha = [0.1; 0.1; 0.01; 0.01];

x_t_mas_1 = zeros(3, n);

for i = 1:n
    % Calcular la odometría
    x_t_mas_1(:, i) = odometria(x_t, u_t, alpha);
end

figure;
hold on
title('Odometría')
xlabel('x_{t+1}');
scatter(x_t_mas_1(1, :), x_t_mas_1(2, :), '.')



function z = normal_box_muller(mu, sigma, n)
    z = zeros(1, n);
    for i = 1:n
        u1 = rand(1, 1);
        u2 = rand(1, 1);
        z(i) = mu + sigma * sqrt(-2*log(u1)) * cos(2*pi*u2);
    end
end




function x_t_mas_1 = odometria(x, u, alpha)
    % Extraer componentes
    delta_rot1 = u(1);
    delta_rot2 = u(2);
    delta_trans = u(3);

    % Agregar ruido a cada componente
    delta_rot1_hat = delta_rot1 + normal_box_muller(0, sqrt(alpha(1)*abs(delta_rot1) + alpha(2)*delta_trans), 1);
    delta_trans_hat = delta_trans + normal_box_muller(0, sqrt(alpha(3)*delta_trans + alpha(4)*(abs(delta_rot1) + abs(delta_rot2))), 1);
    delta_rot2_hat = delta_rot2 + normal_box_muller(0, sqrt(alpha(1)*abs(delta_rot2) + alpha(2)*delta_trans), 1);

    % Calcular nueva pose
    x_t_mas_1 = zeros(3, 1);
    x_t_mas_1(1) = x(1) + delta_trans_hat * cos(x(3) + delta_rot1_hat);
    x_t_mas_1(2) = x(2) + delta_trans_hat * sin(x(3) + delta_rot1_hat);
    x_t_mas_1(3) = x(3) + delta_rot1_hat + delta_rot2_hat;
end
