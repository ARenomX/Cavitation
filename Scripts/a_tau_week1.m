clear all
close all
name = "thindouble";
number = 8;

alist=[];
taulist=[];
rr1list=[];
rr2list=[];


for j=1:number
    [a,tau,rr1,rr2]=confread(name,j);
    alist(end+1) = a;
    taulist(end+1) = tau;
    rr1list(end+1) = rr1;
    rr2list(end+1) = rr2;
end


figure(1)
scatter(taulist,alist,60,rr1list,'filled')
axis([0.013 0.0145 34 38])
caxis([4 14])
title('Confined Bubbles')
xlabel('Tau (s)')
ylabel('a/g')
c=colorbar;
c.Label.String = 'R/R0';
figure(2)
scatter(taulist,alist,60,rr2list,'filled')
axis([0.013 0.0145 34 38])
title('non-Confined Bubbles')
xlabel('Tau (s)')
ylabel('a/g')
q=colorbar;
q.Label.String = 'R/R0';
caxis([4 14])


function [a,tau,rr1,rr2] = confread(name, number)
    file1 = "confinement_" + name + "_" + number + "a";
    file2 = "confinement_" + name + "_" + number;

    A = xlsread(file1);
    R = xlsread(file2);

    acc = A(:,2);
    acc = acc(3:end);
    r = R(:,7);

    r0 = r(1);
    rmax = max(r);
    
    r2 = R(:,15);

    r20 = r2(1);
    r2max = max(r2);
    rr2 = r2max/r20;

    [Amax, index] = max(acc);
    Ahalf = Amax/2;
    check = 0;

    for i=1:index
        if acc(i)>=Ahalf
            i1 = i;
            break
        end
    end
    for i=index:length(acc)
        if acc(i)<=Ahalf
            i2 = i;
            break
        end
    end
    rr1 = rmax/r0;
    tau = (i2-i1)/10000;
    a = Amax/(10.1 * 10^(-3));
end
