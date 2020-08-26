clear all
close all

name="singlemiddle";


difmin=9000000000;
pRef=0;
constref=1;
rads=zeros([50,9]);
ts=zeros([50,9]);
maxinds=zeros([1,9]);
for i=1:9
   [rad,t] = radii(name,i);
   [maxR, maxind] = max(rad);
   rads(:,i)=cat(1,rad,zeros([50-length(rad),1]));
   ts(:,i)=cat(1,t,zeros([50-length(t),1]));
   maxinds(i)=maxind;
end
for i=0:50
   dif = 0;
   for j=1:9
       [T,Y] = RPvarp(name,j,constref,1-0.002*i);
       t=ts(:,j);
       rad=rads(:,j);
       for k=6:maxinds(j)+1
           time = t(k)/10000;
           Tr=round(T,4);
           index = find(Tr==time);
           while isempty(index)
               time = round(time-0.0001,4);
               index=find(Tr==time);
           end
           index = index(1);
           y=Y(:,1);
           dif = dif + ((k-5)^4)*(rad(k) - y(index)*1000)^2; 
       end
   end
   
   if dif<difmin
      difmin = dif
      pRef = 1 - 0.002*i   
   end
   disp(i)
end
disp('---')
disp("constant " + constref)
disp("pressure " + pRef)

function [T,Y] = RPvarp(name,number, constant,pres0)
    rho=1000;
    g=9.81;
    L=31*10^-2;
    p0=pres0*10^5;%+rho*g*L;
    nu=1.31*10^(-6); %viscosité cinematique should be 0.8 ###########
    gamma=71.99*10^(-3);
    pv=2300;
    filename1 = "confinement_"+name+"_"+number;
    filename2 = filename1+"a";
    R = xlsread(filename1);
    A = xlsread(filename2);
    rad = R(:,7)*10^-3;
    r0 = rad(1);
    t0 = R(1,9)/1000;
    times = R(:,8);
    times = times + t0;
    acc = A(8:end,2);
    acc = acc(int16(t0*10000):int16(times(end)*10000));
    a=-acc/(10.1*10^-3);
    tp = A(8:end,1);
    tp = tp(int16(t0*10000):int16(times(end)*10000))-t0;
    Tspan = [0 times(end)-t0];
    p=zeros([length(acc) 1]);
    for i=1:length(acc)
        p(i)=(p0+constant*rho*a(i)*g*L);
    end
    [T,Y] = ode45(@(t,y) myODE(t, y, tp, p, pv, nu, gamma, rho, p0, r0), Tspan, [r0;0]);
end
function [rad, t] = radii(name,number)
    filename1 = "confinement_"+name+"_"+number;
    R = xlsread(filename1);
    rad =  R(:,7);
    t = R(:,6);
end
function dRdt = myODE(t, y, tps, p, pv, nu, gamma, rho, p0, R0)

p1 = interp1(tps, p, t); % Interpolate the data set (tp, p) at times t
    dRdt=[y(2);1/y(1)*(((((p0+2*gamma/R0)*(R0/y(1))^3))-p1)/rho-2*gamma/(rho*y(1))-3/2*y(2)^2-4*nu*y(2)/y(1))]; % Evalute ODE at times t
   
end