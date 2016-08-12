function [Xt,Yt] = lpc_calc(file,co)

% file : .wav file
% co : order of lpc

[x,fs] = audioread(file);


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
   
end
