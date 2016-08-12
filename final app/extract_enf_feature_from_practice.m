% extract feature from filename
% then extract enf

function file_to_save = extract_enf_feature_from_practice(filename)

  
    win = 5;
    overlap = 3; 
    
    qq = strsplit(filename,'/');
    %% file to save
    if ispc
        qq = strsplit(filename,'\');
    end        
    qq = qq(end);
    qq = strsplit(char(qq),'.');
    ss = char(qq(end-1));
    
    file_to_save = sprintf('test_data/%s.mat',ss) ;
    
   
    
    %%
    %fprintf('extracting enf from %s\n',filename);
    [x,sig,c] = enf_extract_from_audio_and_power(filename,win,overlap);

    %%
    
    %fprintf('extracting features from %s\n',filename);
    

    
    %% feature extract
    
    
     window_sample = 32;       %enf window
      
    windows = 5:window_sample:(length(x)-window_sample) ;
    len = length(windows);
    
    
     wav_coef = [];
     AR_coef=[];
    
     mean_x = zeros(1,len);
     var_x = zeros(1,len);
     range = zeros(1,len); % difference between max and min value
     diff_x = zeros(1,len); % mean of maximum 3 differences
   
     counter = 1;
     
    for i = windows
        
        mean_x(counter) = mean( x(i:(i+window_sample-1)) );
        
        var_x(counter) = log( var( x(i:(i+window_sample-1)) ) );
        
        range(counter) = log(abs( max(x(i:(i+window_sample-1))) - min(x(i:(i+window_sample-1)))) );
        
        % diff
        d_m = abs(diff(x(i:(i+window_sample-1)))); %make a difference matrix

        d1 = sort(d_m,'descend');
        
        d = (d1(1)+d1(2)+d1(3))/3;           %taking mean of max 3 differences

        diff_x(counter) = log(d);
        
        AR=ar(x(i:(i+window_sample-1)),2);           %2nd order Autoregressive model
        bb=AR.a(2:3); 
        AR_coef(:,counter)=bb;
        
        %% wavelet analysis
        
       temp1= x(i:(i+window_sample-1));
       %temp2=F1(i:(i+window_sample-1));                  % for normalized ENF

       [C ,~]=wavedec(temp1,5,'haar');

       %[C1 ,~]=wavedec(temp2,5 ,'haar');      % for normalized ENF

        wav_coef(:,counter)=C;
        
        %% increment counter
        counter = counter + 1;
        
    end
  
    master_trainer = [ var_x' mean_x' diff_x' .....
                       AR_coef' wav_coef' range'];

    
                   
    save(file_to_save,'master_trainer','sig','c');

   
end
