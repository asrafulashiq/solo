function [result,Conf] = confusion_power_50(file,SVM_grid_no)

load pole_data/Power_50_normalized_data.mat;
[x,fs] = audioread(file);
x = x/norm(x);

Xt = [];
Yt = [];
win = 10*fs;
co = 8;
lim = fix(length(x)/win);
for k = 1:lim-1
        x1 = x((k-1)*win+1:k*win);
        p = lpc(x1,co);
        if isnan(p(2))
         continue;
        end
        zp = roots(p);
        X = real(zp);
        Y = imag(zp);
        Xt = [Xt;X];
        Yt = [Yt;Y];
     
end

N = 2;

Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xtb;
    Yd = Yt(kk)-Ytb;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_B_var1 = var(Dtval1);
Grid_B_score1 = mean(Dtval1);

Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xtd;
    Yd = Yt(kk)-Ytd;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_D_var1 = var(Dtval1);
Grid_D_score1 = mean(Dtval1);





Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xte;
    Yd = Yt(kk)-Yte;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_E_var1 = var(Dtval1);
Grid_E_score1 = mean(Dtval1);

Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xtf;
    Yd = Yt(kk)-Ytf;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_F_var1 = var(Dtval1);
Grid_F_score1 = mean(Dtval1);

Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xtg;
    Yd = Yt(kk)-Ytg;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_G_var1 = var(Dtval1);
Grid_G_score1 = mean(Dtval1);





Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xth;
    Yd = Yt(kk)-Yth;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_H_var1 = var(Dtval1);
Grid_H_score1 = mean(Dtval1);

Grid = ['B' 'D' 'E' 'F' 'G' 'H'];

Grid_score = [Inf Grid_B_score1 Inf Grid_D_score1 Grid_E_score1 Grid_F_score1 Grid_G_score1 Grid_H_score1 Inf];
Grid_score = Grid_score /min(Grid_score );

[mini_val, Grid_no] = min(Grid_score);

Grid_score_sorted = sort(Grid_score);
if (Grid_score_sorted(2)>=2)
    result = Grid_no;
    Conf = Grid_score_sorted(2)/(1+Grid_score_sorted(2));
else
    Grid_score = Grid_score(SVM_grid_no);
    [mini_val ,Grid_no] = min(Grid_score);
    result = SVM_grid_no(Grid_no);
    Conf = -1;
end

end
