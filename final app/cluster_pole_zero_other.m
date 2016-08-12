function [X, Y, label] = cluster_pole_zero_other(Grid,type,freq)

   
    label = [];
    total = 12;

    l = 0;
    
    X = [];
    Y = [];
    
    M = '';N='';
    %r = 0;g=0;b=0;
    if strcmp(type,'power')
        M='Power';
        N='P';
        
    else
        M='Audio';
        N='A';
    end
    
    if freq==50
        t1=40*pi/180;
        t2=60*pi/180;
    else
        t1=50*pi/180;
        t2=70*pi/180;
    end

    
    
    for grid_ = Grid

        

        for i = 1:total
        filename = sprintf('data/Grid_%s/%s_recordings/Train_Grid_%s_%s%d.wav',grid_,M,grid_,N,i);

            if exist(filename,'file')==2
                [a,b]=lpc_cluster(filename);
                X = [X' a']';
                Y = [Y' b']';

            
                %fprintf('fatal:file does not exist for pole : %s\n',filename);
                
            end

        end

        ph = angle(X+1j*Y);
        index = ph>=t1 & ph<=t2;
        X = X(index);
        Y = Y(index);
        label = [label' ( (grid_ - 'A' + 1)*ones(length(X)-l,1) )']';
        %(grid_ - 'A' + 1)*ones(length(X)-l,1)
        l = length(X);
        
      
    end
end