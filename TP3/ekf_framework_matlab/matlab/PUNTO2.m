close all
clear all


c = 0:10:200;
mediciones = [101, 82, 91, 112, 99, 151, 96, 85, 99, 105];
l = zeros(1,21);

for i = 1:size(mediciones,2)
    for j = 1:size(c,2)
        if c(j) >= mediciones(i) - 20 && c(j) <= mediciones(i) + 20
            l(j) = l(j) + inv_sensor_model(mediciones(i), c(j)) - log(0.5 / (1 - 0.5));
        end
    end
end

m = 1 - 1./(1 + exp(l));

figure();
plot(c,m);
ylim([0 1]);
title('Belief final con mediciones del sensor 1');

%%
mediciones2 = [101, 99, 97, 102, 99, 100, 96, 104, 99, 105];
l2 = zeros(1,21);

for i = 1:size(mediciones2,2)
    for j = 1:size(c,2)
        if c(j) >= mediciones2(i) - 20 && c(j) <= mediciones2(i) + 20
            l2(j) = l2(j) + inv_sensor_model(mediciones2(i), c(j)) - log(0.5 / (1 - 0.5));
        end
    end
end

m2 = 1 - 1./(1 + exp(l2));

figure();
plot(c,m2);
ylim([0 1]);
title('Belief final con mediciones del sensor 2');


%%
function l = inv_sensor_model(medicion, posicion)
    if (posicion < medicion)
        l = log(0.3/(1-0.3));
    else
        l = log(0.6/(1-0.6));
    end
end