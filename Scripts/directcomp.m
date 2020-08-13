close all

name = "thindouble";
number = 8;

[t,r1,r2] = getradius(name,number);
plot(t*1000,r1)
hold on
plot(t*1000,r2)
xlabel("Time (ms)")
ylabel("Radius (mm)")
title("Comparison of evolution or Radius")
legend('Confined Bubble','Non-Confined Bubble','Location','northwest')
hold off


function [t,r1,r2]  = getradius(name,number)
    file = "confinement_" + name + "_" + number;
    R = xlsread(file);
    r1 = R(:,7);
    r2 = R(:,15);
    t = R(:,16);
end