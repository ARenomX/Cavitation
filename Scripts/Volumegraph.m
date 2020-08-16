name = 'HighCav';
number = 1;
[vol,t]=quickG(name,number);

function [vol1,t1] = quickG(name,number)
    [vol1, v01, t1,t01] = volume(name,7,2);
    [vol2, v02, t2,t02] = volume(name+"Conf",number,3);
    hold on
    plot(t1-t01,vol1/v01)
    plot(t2-t02,vol2/v02)
    title('Evolution of Volume with Time')
    legend('Non-Confined','Confined','Location','northwest')
    xlabel('Time (s)')
    ylabel('V/V_0')
    hold off
end


function [vol, v0, t,t0] = volume(name,number,constant)
    topfile = name+"_top_"+number;
    sidefile = name+"_cote_"+number;
    Rtop = xlsread(topfile);
    Rside = xlsread(sidefile);
    rtop =  Rtop(:,7)*0.001;
    rside = Rside(:,7)*0.001;
    t0top = Rtop(1,9)*0.001;
    t0side = Rside(1,9)*0.001;
    ttop = t0top + Rtop(:,8);
    tside = t0side + Rside(:,8);
    tNtop = ttop(end);
    tNside = tside(end);
    t = linspace(max([t0top t0side]), min([tNtop tNside]), 20);
    rtop1 = interp1(ttop, rtop, t);
    rside1 = interp1(tside, rside, t);
    vol = constant*(1/3)*pi*rtop1.*rtop1.*rside1;
    v0 = (2/3)*pi*rtop1(1)*rtop1(1)*rside1(1);
    t0 = max([t0top, t0side]);
end

function dRdt = myODE(t, y, tps, p, pv, nu, gamma, rho, p0, R0)

p1 = interp1(tps, p, t); % Interpolate the data set (tp, p) at times t
    dRdt=[y(2);1/y(1)*(((((p0+2*gamma/R0)*(R0/y(1))^3))-p1)/rho-2*gamma/(rho*y(1))-3/2*y(2)^2-4*nu*y(2)/y(1))]; % Evalute ODE at times t
   
end
