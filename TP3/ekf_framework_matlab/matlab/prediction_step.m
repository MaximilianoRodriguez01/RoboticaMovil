function [mu_, sigma_] = prediction_step(mu, sigma, u)
    % Updates the belief, i. e., mu and sigma, according to the motion model
    %
    % u: odometry reading (r1, t, r2)
    % mu: 3 x 1 vector representing the mean (x, y, theta) of the normal distribution
    % sigma: 3 x 3 covariance matrix of the normal distribution

    % Compute the noise-free motion. This corresponds to the function g, evaluated
    % at the state mu.
    theta = mu(3);
    mu_ = mu + [u.t * cos(theta + u.r1);
           u.t * sin(theta + u.r1);
           u.r1 + u.r2];

    % Compute the Jacobian of g with respect to the state
    G = [1, 0, -u.t * sin(theta + u.r1);
         0, 1,  u.t * cos(theta + u.r1);
         0, 0,  1];

    V = [-u.t*sin(theta+u.r1), cos(theta+u.r1), 0;
          u.t*cos(theta+u.r1), sin(theta+u.r1), 0;
          1,                    0,              1];

    % Motion noise
    Q = [0.2, 0, 0; 
        0, 0.2, 0; 
        0, 0, 0.02];

    sigma_ = G * sigma * G.' + V*Q*V.';
end
