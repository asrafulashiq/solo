function [X, Y, label] = cluster_pole_zero()

    Grid = ['A','C','I'];

   
    label = [];
    total = 12;

    l = 0;
    
    X = [];
    Y = [];
    
    %r = 0;g=0;b=0;

    for grid = Grid

        

        for i = 1:total
        filename = sprintf('data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',grid,grid,i);

            if exist(filename,'file')==2
                [a,b]=lpc_cluster(filename);
                X = [X' a']';
                Y = [Y' b']';

            end

        end

        ph = angle(X+1j*Y);
        index = ph>=50*pi/180 & ph<=70*pi/180;
        X = X(index);
        Y = Y(index);
        label = [label' ((grid - 'A' + 1)*ones(length(X)-l,1))']';
        l = length(X);
        %scatter(X(index),Y(index),'*',colors(counter));

        %scatter(X(index),Y(index),'MarkerEdgeColor',[r/255 g/255 b/255]);

        %axis([-1.5 1.5 -1.5 1.5]);

        %hold on;

        %counter = counter + 1;
    end
end