clear all
close all

scan = load('-ascii', 'laserscan.dat');
angulos = linspace(-pi/2, pi/2, size(scan,2));

mediciones_x = scan .* cos(angulos);
mediciones_y = scan .* sin(angulos);

figure()
hold on
axis equal
grid on
xlabel('X [m]')
ylabel('Y [m]')
title('Mediciones del laser')
title('Mediciones del laser')
plot(mediciones_x, mediciones_y, "o");

pose_robot = [5; -7];
figure();
grid on
title("Posicion del robot en la terna global");
hold on
axis equal
xlabel('X [m]')
ylabel('Y [m]')
plot(pose_robot(1), pose_robot(2), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'r');

theta_robot = -pi/4;
theta_lidar = pi;

% Pose del robot en la global
T_robot_a_global = [cos(theta_robot), -sin(theta_robot), 5;
                    sin(theta_robot),  cos(theta_robot), -7;
                    0, 0, 1];

% Pose del LIDAR respecto al robot
T_lidar_a_robot = [cos(theta_lidar), -sin(theta_lidar), 0.2;
                   sin(theta_lidar),  cos(theta_lidar), 0;
                   0, 0, 1];

% Pose del LIDAR en la global
T_lidar_a_global = T_robot_a_global * T_lidar_a_robot;

% Origen del LIDAR en su propio sistema de referencia
posicion_lidar_homogeneo = [0; 0; 1];

% Posición del LIDAR en coordenadas globales
posicion_lidar_global = T_lidar_a_global * posicion_lidar_homogeneo;

% Graficar
figure();
plot(pose_robot(1), pose_robot(2), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold on
plot(posicion_lidar_global(1), posicion_lidar_global(2), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'g')
xlabel("X [m]");
ylabel("Y [m]");
xlim([4 6]);
ylim([-8 -6]);
title("Posición del LIDAR en la terna global");
axis equal;
grid on;


mediciones = [mediciones_x ; mediciones_y];
mediciones_homogeneas = [mediciones; ones(1, size(mediciones, 2))]; 

mediciones_terna_global = T_lidar_a_global * mediciones_homogeneas;

figure();
plot(pose_robot(1), pose_robot(2), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold on
plot(posicion_lidar_global(1), posicion_lidar_global(2), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(mediciones_terna_global(1, :), mediciones_terna_global(2, :), "o");
xlabel("X [m]");
ylabel("Y [m]");
title("Mediciones con respecto a la terna global");
axis equal;
grid on


function [x_n, y_n, theta_n] = diffdrive(x, y, theta, v_l, v_r, t, l)
    v = (v_r + v_l) / 2;
    w = (v_r - v_l) / l;

    if abs(w) < 1e-6
        x_n = x + v * cos(theta) * t;
        y_n = y + v * sin(theta) * t;
    else
        R = v / w;
        x_n = x - R * sin(theta) + R * sin(theta + w * t);
        y_n = y + R * cos(theta) - R * cos(theta + w * t);
    end

    theta_aux = theta + w * t;
    theta_n = mod(theta_aux, 2*pi);
end 


pose = [0; 0; pi/4];
poses = pose;

acciones = [
    0.1  0.5  2;
    0.5  0.1  2;
    0.2  0.2  2;
    1.0  0.0  4;
    0.4  0.4  2;
    0.2 -0.2  2;
    0.5  0.5  2
];

l = 0.5;

for i = 1:size(acciones, 1)
    v_l = acciones(i, 1);
    v_r = acciones(i, 2);
    t   = acciones(i, 3);

    [x_n, y_n, theta_n] = diffdrive(pose(1), pose(2), pose(3), v_l, v_r, t, l);
    pose = [x_n; y_n; theta_n];
    poses = [poses pose];
end

figure();
hold on
axis equal
grid on
xlabel('X [m]')
ylabel('Y [m]')
title('Trayectoria del robot')

% % Dibuja la trayectoria conectando los puntos
% plot(poses(1, :), poses(2, :), 'b.-');  % X vs Y

% Dibuja la trayectoria conectando los puntos
plot(poses(1, :), poses(2, :), 'o');  % X vs Y

% Dibuja la pose inicial
plot(poses(1, 1), poses(2, 1), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Dibuja la pose final
plot(poses(1, end), poses(2, end), "o", 'MarkerSize', 10, 'MarkerFaceColor', 'r');

quiver(poses(1, :), poses(2, :), cos(poses(3, :)), sin(poses(3, :)), 0.3, 'k');


function tray = simular_movimiento(x, y, theta, v_l, v_r, t_total, l, dt)
    pasos = floor(t_total / dt);
    tray = zeros(3, pasos + 1);
    tray(:,1) = [x; y; theta];

    for i = 1:pasos
        [x, y, theta] = diffdrive(x, y, theta, v_l, v_r, dt, l);
        tray(:, i+1) = [x; y; theta];
    end
end


pose = [0; 0; pi/4];
poses_anim = pose; 

acciones = [
    0.1  0.5  2;
    0.5  0.1  2;
    0.2  0.2  2;
    1.0  0.0  4;
    0.4  0.4  2;
    0.2 -0.2  2;
    0.5  0.5  2
];  
dt = 0.05;

figure();
axis equal
grid on
xlabel('X [m]')
ylabel('Y [m]')
title('Animación del movimiento del robot')
hold on

h_trayectoria = plot(nan, nan, 'b-');        % línea de trayectoria
h_robot = plot(pose(1), pose(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  
h_orient = quiver(pose(1), pose(2), cos(pose(3)), sin(pose(3)), 0.4, 'k');        

for i = 1:size(acciones, 1)
    v_l = acciones(i, 1);
    v_r = acciones(i, 2);
    t_total = acciones(i, 3);

    pasos = round(t_total / dt);

    for j = 1:pasos
        [x_n, y_n, theta_n] = diffdrive(pose(1), pose(2), pose(3), v_l, v_r, dt, l);
        pose = [x_n; y_n; theta_n];
        poses_anim = [poses_anim pose];

        % actualizar gráficos
        set(h_trayectoria, 'XData', poses_anim(1,:), 'YData', poses_anim(2,:));
        set(h_robot, 'XData', pose(1), 'YData', pose(2));
        set(h_orient, 'XData', pose(1), 'YData', pose(2), ...
                      'UData', cos(pose(3)), 'VData', sin(pose(3)));

        pause(dt * 0.5);  
    end
end

plot(poses_anim(1,1), poses_anim(2,1), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');  % inicio
plot(poses_anim(1,end), poses_anim(2,end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  % final
