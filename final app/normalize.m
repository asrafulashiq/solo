function [data,mean_,var_] = normalize(x)
    
    mean_ = mean(x);
    var_ = var(x);
    
    len = size(x);
    
 
    data = x - ones(len(1),1)*mean_ ;  
    for i = 1:len(2)
       data(:,i) = data(:,i)/(2* sqrt( var_(i)) );
    end
   
    
end
