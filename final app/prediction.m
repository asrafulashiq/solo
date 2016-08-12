function [predicted_grid,confidence] = prediction(filename,file_wav)

load(filename);

%c
%sig

load('grid_details/present_grids.mat');

tmp1 = grid60-'A'+1;  %[1 3 9]; % 60 hz 
tmp2 = grid50-'A'+1;   %[2 4 5 6 7 8]; % 50 hz 

l = size(master_trainer);

load('take_index.mat');
load('normalizer.mat');

if strcmp(sig,'power') && c==50
    
    file_to_load = 'classifier/nogrid_p50.mat';
    file_to_load2 = 'classifier/p50.mat';
    take = take_p50;
    mean_ = mean_p50;
    var_ = var_p50;
    
elseif strcmp(sig,'power') && c==60
    
    file_to_load = 'classifier/nogrid_p60.mat';
    file_to_load2 = 'classifier/p60.mat';
    take = take_p60;
    mean_ = mean_p60;
    var_ = var_p60;
    
elseif strcmp(sig,'audio') && c==50
    
    file_to_load = 'classifier/nogrid_a50.mat';
    file_to_load2 = 'classifier/a50.mat';
    take = take_a50;
    mean_ = mean_a50;
    var_ = var_a50;
    
elseif strcmp(sig,'audio') && c==60
    
    file_to_load = 'classifier/nogrid_a60.mat';
    file_to_load2 = 'classifier/a60.mat';
    take = take_a60;
    mean_ = mean_a60;
    var_ = var_a60;
end


%% predict no grid
load(file_to_load);

tolerance = .15;

[predicted_label, ~,~] = svmpredict(zeros(l(1),1), ...
    master_trainer,model);

len = length(find(predicted_label == -1));
if len/length(predicted_label) >= tolerance 
    predicted_grid = 'N';
    confidence = len/length(predicted_label)*100;
    return;
end

%% predict normal grid

load(file_to_load2);

master_trainer = normalize2(master_trainer,mean_,var_);

[predicted_label ,accuracy,decision_values] = svmpredict(zeros(l(1),1), ...
    master_trainer(:,take),model,'-b 1');

    result = [];
    lenn = length(grid_number);
    
    for i = 1:lenn
       result = [result length(find(predicted_label == i ))   ] ;
    end

         
      result = result/length(result);

      probability = zeros(1,lenn);
      
      if c == 60
        probability(tmp1) = geomean(decision_values);
      else
       probability(tmp2) = geomean(decision_values);
      end
       
      probability = probability.*result;
      probability = probability./sum(probability);
      
      ln = size(master_trainer);
      ln = ln(1);
       g = find(probability ~= 0);
          
       
     %% pole matching   
          if strcmp(sig,'audio') && c == 50
              [g,conf] = confusion_audio_50(file_wav,g);
          elseif strcmp(sig,'audio') && c == 60
              [g,conf] = confusion_audio_60(file_wav,g);
          elseif strcmp(sig,'power') && c == 60
              [g,conf] = confusion_power_60(file_wav,g);
          elseif strcmp(sig,'power') && c == 50
              [g,conf] = confusion_power_50(file_wav,g);
          end
           
          if conf ~= -1
              probability(g) = conf;
          end

           % GRD = [GRD g+'A'-1];


          predicted_grid =  grid_number(g); %g+'A'-1;
             
        %%%%%%%
        
       % fprintf('file : %s result(%s %d hz) : ',filename,sig,c);
       % fprintf('%4d ',probability);
       % fprintf('\n');
       % fprintf('predicted grid: %d\n',predicted_grid);
             
        confidence = probability(g)*100;

end