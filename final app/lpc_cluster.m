function [X_array,Y_array] = lpc_cluster(str)
    [x fs] = audioread(str);
    win = fs*5;
    lim = fix(length(x)/win);
    
    X_array = [];
    Y_array = [];
    
    for k=1:lim-1
        xm = x((k-1)*win+1:k*win);
        [p,g] = lpc(xm,8);
        pz = roots(p);
        X = real(pz);Y = imag(pz);
        
        X_array = [X_array' X']';
        Y_array = [Y_array' Y']';
        
    end
    
    ph = angle(X_array+1j*Y_array);
        index = find(ph>=50*pi/180 & ph<=70*pi/180);
       X_array = X_array(index);
        Y_array = Y_array(index);

       
end