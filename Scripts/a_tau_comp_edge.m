%clear all
%close all
names = ["interactedge","twoconfedge",];
number = [9 5];
titlelist = ["Edge bubble without confining cylinder","Edge bubble with confining cylinder"];

alist=[];
taulist=[];
rr1list=[];
rr2list=[];

for i=1:length(names)
    figure(i+5)
    for j=1:number(i)
        [a,tau,rr]=confread(names(i),j);
        alist(end+1) = a;
        taulist(end+1) = tau;
        rr1list(end+1) = rr;
    end
    scatter(taulist,alist,60,rr1list,'filled')
    xlim([0.014 0.016])
    ylim([31 34])
    caxis([3 7])
    title(titlelist(i))
    xlabel('Tau (s)')
    ylabel('a/g')
    c=colorbar;
    c.Label.String = 'R/R0';
    alist=[];
    taulist=[];
    rr1list=[];
end

% figure(1)
% scatter(taulist,alist,60,rr1list,'filled')
% %axis([0.13 0.16 31 37])
% %caxis([4 14])
% title('Confined Bubbles')
% xlabel('Tau (s)')
% ylabel('a/g')
% c=colorbar;
% c.Label.String = 'R/R0';
% figure(2)
% scatter(taulist,alist,60,rr2list,'filled')
% %axis([0.13 0.16 31 37])
% title('non-Confined Bubbles')
% xlabel('Tau (s)')
% ylabel('a/g')
% q=colorbar;
% q.Label.String = 'R/R0';
% caxis([4 14])


function [a,tau,rr1] = confread(name, number)
    file1 = "confinement_" + name + "_" + number + "a";
    file2 = "confinement_" + name + "_" + number;

    A = xlsread(file1);
    R = xlsread(file2);

    acc = A(:,2);
    acc = acc(3:end);
    r = R(:,7);

    r0 = r(1);
    rmax = max(r);

    [Amax, index] = max(acc);
    Ahalf = Amax/2;

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
