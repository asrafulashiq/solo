function [result,Conf] = confusion_power_60(file,SVM_grid_no)


[x fs] = audioread(file);



%% last grid
new_=false;
load('grid_details/present_grids.mat');
last_grid = grid_number(end);
if ~isempty(find(grid60==last_grid)) && length(grid_number)>9
    new_ = true;  
end



%%
load pole_data/Power_60_pole_data.mat

%%


Xt = [];
Yt = [];
win = fs*10;
lim = fix(length(x)/win);
co = 8;
    
 for k = 1:lim-1
     x1 = x((k-1)*win+1:k*win);
     p = lpc(x1,8);
     if isnan(p(2))
         continue;
     end
     zp = roots(p);
     X = real(zp);
     Y = imag(zp);
     mask1 = X>0.1;
     X = X(mask1);
     Y = Y(mask1);
     mask2 = Y>0.1;
     X = X(mask2);
     Y = Y(mask2);
     Xt = [Xt;X];
     Yt = [Yt;Y];

 end
 
XC = Xt;
YC = Yt;
mask = XC>0.7;
Xt1 = XC(mask);
Yt1 = YC(mask);
Xt2 = XC(mask==0);
Yt2 = YC(mask==0);

XC = XYaC(:,1);
YC = XYaC(:,2);
mask = XC>0.7;
XC1 = XC(mask);
YC1 = YC(mask);
XC2 = XC(mask==0);
YC2 = YC(mask==0);
XYaC1 = [XC1,YC1];
XYaC2 = [XC2,YC2];

XC = XYcC(:,1);
YC = XYcC(:,2);

mask = XC>0.7;
XC1 = XC(mask);
YC1 = YC(mask);
XC2 = XC(mask==0);
YC2 = YC(mask==0);
XYcC1 = [XC1,YC1];
XYcC2 = [XC2,YC2];

XC = XYiC(:,1);
YC = XYiC(:,2);

mask = XC>0.7;
XC1 = XC(mask);
YC1 = YC(mask);
XC2 = XC(mask==0);
YC2 = YC(mask==0);
XYiC1 = [XC1,YC1];
XYiC2 = [XC2,YC2];


N = 2;

%display('Calulating results for cluster 1');

Dtval = zeros(N*length(Xt1),1);
for kk = 1:length(Xt1)
    Xd = Xt1(kk)-XYaC1(:,1);
    Yd = Yt1(kk)-XYaC1(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_A_var = var(Dtval);
Grid_A_score = mean(Dtval);

Dtval = zeros(N*length(Xt1),1);
for kk = 1:length(Xt1)
    Xd = Xt1(kk)-XYcC1(:,1);
    Yd = Yt1(kk)-XYcC1(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_C_var = var(Dtval);
Grid_C_score = mean(Dtval);

Dtval = zeros(N*length(Xt1),1);
for kk = 1:length(Xt1)
    Xd = Xt1(kk)-XYiC1(:,1);
    Yd = Yt1(kk)-XYiC1(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_I_var = var(Dtval);
Grid_I_score = mean(Dtval);


Grid = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I'];
Grid_var = [Grid_A_var Grid_C_var  Grid_I_var];
Grid_score = [Grid_A_score Inf Grid_C_score Inf Inf Inf Inf Inf Grid_I_score];
Grid_score = Grid_score/min(Grid_score);


%display('Calculating reults for cluster 2');

Dtval = zeros(N*length(Xt2),1);
for kk = 1:length(Xt2)
    Xd = Xt2(kk)-XYaC2(:,1);
    Yd = Yt2(kk)-XYaC2(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_A_var = var(Dtval);
Grid_A_score = mean(Dtval);

Dtval = zeros(N*length(Xt2),1);
for kk = 1:length(Xt2)
    Xd = Xt2(kk)-XYcC2(:,1);
    Yd = Yt2(kk)-XYcC2(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_C_var = var(Dtval);
Grid_C_score = mean(Dtval);

Dtval = zeros(N*length(Xt2),1);
for kk = 1:length(Xt2)
    Xd = Xt2(kk)-XYiC2(:,1);
    Yd = Yt2(kk)-XYiC2(:,2);
    Dt = Xd.^2+Yd.^2;
    for nn = 1:N
        [mini pos] = min(Dt);
        Dtval(kk+nn-1)=mini;
        Dt = [Dt(1:pos-1); Dt(pos+1:end)];
    end
end
Grid_I_var = var(Dtval);
Grid_I_score = mean(Dtval);

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
        
            Grid = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I'];

    Grid_score = [Grid_A_score1 Inf Grid_C_score1 Inf Inf Inf Inf Inf Grid_I_score1 Grid_J_score1];
    Grid_score = Grid_score/min(Grid_score );

       
    else


%Grid_var = [Grid_A_var Grid_C_var  Grid_I_var];
Grid_score = [Grid_A_score Inf Grid_C_score Inf Inf Inf Inf Inf Grid_I_score];
Grid_score = Grid_score/min(Grid_score);

end

Grid_score_sorted = sort(Grid_score);
%sprintf('%10.0000f', Grid_score)
if (Grid_score_sorted(2)>=10)
    [mini_val Grid_no] = min(Grid_score);
    result = Grid_no;
    disp(Grid(result));
    Conf = Grid_score_sorted(2)/(1+Grid_score_sorted(2));
else
    Grid_score = Grid_score(SVM_grid_no);
    [mini_val Grid_no] = min(Grid_score);
    result = SVM_grid_no(Grid_no);
    disp(Grid(result));
    Conf = -1;
end


end
