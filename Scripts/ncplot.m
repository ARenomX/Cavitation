clear all
close all

name = 'nc';
num = 3;

[R, e, t1, t2,t3]=quickG(name,num);


function [max1, max2, t1, t2,t3] = quickG(name,number)
    figure(number)
    [R, t1] = radii("top_"+name,number);
    [e, t2] = radii("cote_"+name,number);
    [acc, t3] = accel(name, number, t1);
    yyaxis left
    plot(t1,R)
    hold on
    plot(t2,e)
    ylabel('Radius (mm)')
    yyaxis right
    [b,c]=butter(5,0.1);
    acc = filter(b,c,acc);
    plot(t3, acc)
    title('Evolution of Radius with Time')
    legend('Horizontal Radius','Thickness', 'Acceleration','Location','northwest')
    xlabel('Time (s)')
    ylabel('Acceleration')
    hold off
    max1 = max(R);
    max2 = max(e);
end


function [rad, t] = radii(name,number)
    filename1 = name+"_"+number;
    R = xlsread(filename1);
    rad =  R(:,7);
    t = R(:,8)+R(1,9)/1000;
end

function [acc, t] = accel(name,number,t)
    filename1 = "top_"+name+"_"+number+"a";
    A = xlsread(filename1);
    start = round(t(1)-0.01,4);
    stop = round(t(end)+0.01,4);
    acc = A(start*10000:stop*10000,2);
    t = linspace(start,stop,length(acc));
end


