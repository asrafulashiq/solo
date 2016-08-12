function data = normalize2(x,mean_,var_)
 
    
    len = size(x);
    
    data = x - ones(len(1),1)*mean_ ;  
    for i = 1:len(2)
       data(:,i) = data(:,i)/(2* sqrt( var_(i)) );
    end
   
end