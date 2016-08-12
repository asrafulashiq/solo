function [feature] = practice_zeros(filename)
     [a,b]=lpc_cluster(filename);
     feature = [a b];    
end