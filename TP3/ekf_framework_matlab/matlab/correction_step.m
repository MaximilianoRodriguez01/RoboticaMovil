function [mu_, sigma_] = correction_step(mu, sigma, z, l)
    mu_ = mu;
    sigma_ = sigma;

    R = diag([0.5^2, 0.5^2]);  % Ruido de medición asumido (range, bearing)

    for i = 1:length(z)
        j = z(i).id;
        mx = l(j).x;
        my = l(j).y;

        dx = mx - mu_(1);
        dy = my - mu_(2);
        q = dx^2 + dy^2;

        % Medición esperada
        z_hat = [sqrt(q);
                 atan2(dy, dx) - mu_(3)];
        z_hat(2) = atan2(sin(z_hat(2)), cos(z_hat(2)));  % Normalización

        % Jacobiano
        H = [ -dx / sqrt(q), -dy / sqrt(q), 0;
               dy / q,       -dx / q,     -1 ];

        % Kalman
        S = H * sigma_ * H.' + R;
        K = sigma_ * H.' / S;

        z_real = [z(i).range;
                  z(i).bearing];
        innovation = z_real - z_hat;
        innovation(2) = atan2(sin(innovation(2)), cos(innovation(2)));

        % Corrección
        mu_ = mu_ + K * innovation;
        mu_(3) = atan2(sin(mu_(3)), cos(mu_(3)));  % Normalizar theta
        sigma_ = (eye(3) - K * H) * sigma_;
    end
end
