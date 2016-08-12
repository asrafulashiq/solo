function [result,Conf] = confusion_audio_60(file,SVM_grid_no)

load pole_data/Audio_60_normalized_data.mat;

[x,fs] = audioread(file);
x = x/norm(x);

Xt = [];
Yt = [];
win = 10*fs;
lim = fix(length(x)/win);
co = 12;
%varb = [];
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
    Xd = Xt(kk)-Xta;
    Yd = Yt(kk)-Yta;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_A_var1 = var(Dtval1);
Grid_A_score1 = mean(Dtval1);

Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xtc;
    Yd = Yt(kk)-Ytc;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_C_var1 = var(Dtval1);
Grid_C_score1 = mean(Dtval1);





Dtval1 = zeros(N*length(Xt),1);
for kk = 1:length(Xt)
    Xd = Xt(kk)-Xti;
    Yd = Yt(kk)-Yti;
    Dt = sqrt(Xd.^2+Yd.^2);
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval1(N*(kk-1)+nn)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_I_var1 = var(Dtval1);
Grid_I_score1 = mean(Dtval1);



%Grid = ['A' 'C' 'I' ];

Grid_score = [Grid_A_score1 Inf  Grid_C_score1 Inf Inf Inf Inf Inf Grid_I_score1 ];
Grid_score = Grid_score /min(Grid_score );

Score = Grid_score;

[mini_val, Grid_no] = min(Score);

Score_sorted = sort(Score);

if (Score_sorted(2)>=2)
    
    result = Grid_no;
    Conf = Score_sorted(2)/(1+Score_sorted(2));
else
    Score = Score(SVM_grid_no);
    [mini_val, Grid_no] = min(Score);
    result = SVM_grid_no(Grid_no);
    Conf = -1;
end

end
