function [mu_, sigma_] = correction_step(mu, sigma, z, l)
    mu_ = mu;
    sigma_ = sigma;

    R = 0.5^2;  % Varianza escalar, ya que sólo hay rango

    for i = 1:length(z)
        j = z(i).id;
        mx = l(j).x;
        my = l(j).y;

        dx = mx - mu_(1);
        dy = my - mu_(2);
        q = dx^2 + dy^2;

        % Medición esperada 
        z_hat = sqrt(q);

        % Jacobiano de h respecto al estado
        H = [-dx / sqrt(q), -dy / sqrt(q), 0];  % 1x3

        % Kalman
        S = H * sigma_ * H.' + R;     
        K = sigma_ * H.' / S;        

        z_real = z(i).range;
        innovation = z_real - z_hat;

        % Corrección
        mu_ = mu_ + K * innovation;
        mu_(3) = atan2(sin(mu_(3)), cos(mu_(3)));  % Normalizar theta
        sigma_ = (eye(3) - K * H) * sigma_;
    end
end
