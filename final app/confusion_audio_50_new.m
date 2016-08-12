function [result,Conf] = confusion_audio_50_new(file,SVM_grid_no)

[x,fs] = audioread(file);

%% last grid
new_ = false;
load('grid_details/present_grids.mat');
last_grid = grid_number(end);
if ~isempty(find(grid50==last_grid)) && length(grid_number)>9
    new_ = true;  
end
    
for test = 1:2
    if (test==1)
        load pole_data/Audio_50Hz_pole_data_order_8.mat
        co = 8;
    else
        load pole_data/Audio_50Hz_pole_data_order_6.mat
        co = 6;
    end
   
    Xt = [];
    Yt = [];
    win = 10*fs;
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
        mask1 = X>0;
        X = X(mask1);
        Y = Y(mask1);
        mask2 = Y>0;
        X = X(mask2);
        Y = Y(mask2);
        Xt = [Xt;X];
        Yt = [Yt;Y];
        
    end
    
    
    
    
    N = 2;
    
    Dtval1 = zeros(N*length(Xt),1);
    for kk = 1:length(Xt)
        Xd = Xt(kk)-Xtb;
        Yd = Yt(kk)-Ytb;
        Dt = Xd.^2+Yd.^2;
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
        Dt = Xd.^2+Yd.^2;
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
        Dt = Xd.^2+Yd.^2;
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
        Dt = Xd.^2+Yd.^2;
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
        Dt = Xd.^2+Yd.^2;
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
        Dt = Xd.^2+Yd.^2;
        for nn = 1:N
            [mini pos] = min(Dt);
            Dtval1(N*(kk-1)+nn)=mini;
            Dt = [Dt(1:pos-1); Dt(pos+1:end)];
        end
    end
    Dtval1 = sort(Dtval1,'descend');
    Grid_H_var1 = var(Dtval1);
    Grid_H_score1 = mean(Dtval1);
    
    if new_==true
    
        Dtval1 = zeros(N*length(Xt),1);
        for kk = 1:length(Xt)
            Xd = Xt(kk)-Xtj;
            Yd = Yt(kk)-Ytj;
            Dt = Xd.^2+Yd.^2;
            for nn = 1:N
                [mini pos] = min(Dt);
                Dtval1(N*(kk-1)+nn)=mini;
                Dt = [Dt(1:pos-1); Dt(pos+1:end)];
            end
        end
        Dtval1 = sort(Dtval1,'descend');
        Grid_J_var1 = var(Dtval1);
        Grid_J_score1 = mean(Dtval1);
        
        Grid = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J'];
        Grid_score = [Inf Grid_B_score1 Inf Grid_D_score1 Grid_E_score1  Grid_F_score1 Grid_G_score1 Grid_H_score1 Inf Grid_J_score1];
        Grid_score = Grid_score/min(Grid_score);

       
    else
    
        Grid = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I'];
    
        Grid_score = [Inf Grid_B_score1 Inf Grid_D_score1 Grid_E_score1  Grid_F_score1 Grid_G_score1 Grid_H_score1 Inf];
        Grid_score = Grid_score/min(Grid_score);
    %Grid_var = [Grid_B_var1 Grid_D_var1 Grid_E_var1  Grid_F_var1 Grid_G_var1 Grid_H_var1];
    end
    
    if (test == 1)
        Grid_score_1 = Grid_score;
    else
        Grid_score_2 = Grid_score;
    end
    
end
score_1_sorted = sort(Grid_score_1,'ascend');
score_2_sorted = sort(Grid_score_2,'ascend');
if (score_1_sorted(2)>=score_2_sorted(2))
    Score = Grid_score_1;
else
    Score = Grid_score_2;
end
Score_sorted = sort(Score);
%sprintf('%10.0000f', Grid_score)
if (Score_sorted(2)>=10)
    [mini_val Grid_no] = min(Score);
    result = Grid_no;
    disp(Grid(result));
    Conf = Score_sorted(2)/(1+Score_sorted(2));
else
    Score = Score(SVM_grid_no);
    [mini_val Grid_no] = min(Score);
    result = SVM_grid_no(Grid_no);
    disp(Grid(result));
    Conf = -1;
end



end
