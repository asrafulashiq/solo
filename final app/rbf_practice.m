
merge_train_data;
nogrd = [];
%%
train_data = trainer_power_50;
s = size(train_data);

model = svmtrain(ones(s(1),1),train_data,'-s 2 -t 2 -n 0.001');
save('classifier/nogrid_p50.mat','model');

  
  %%
train_data = trainer_power_60;
s = size(train_data);

model = svmtrain(ones(s(1),1),train_data,'-s 2 -t 2  -n 0.001');
save('classifier/nogrid_p60.mat','model');

 
%%
train_data = trainer_audio_50;
s = size(train_data);

model = svmtrain(ones(s(1),1),train_data,'-s 2 -t 2 -n 0.001');
save('classifier/nogrid_a50.mat','model');


%%
train_data = trainer_audio_60;
s = size(train_data);

model = svmtrain(ones(s(1),1),train_data,'-s 2 -t 2 -n 0.001');
save('classifier/nogrid_a60.mat','model');
 
  
%% tmp 
response_audio_50 = response_audio_50 - 'A'+1;
response_audio_60 = response_audio_60 - 'A'+1;
response_power_50 = response_power_50 - 'A'+1;
response_power_60 = response_power_60 - 'A'+1;

%% normalize
[trainer_power_50,mean_p50,var_p50] = normalize(trainer_power_50);
[trainer_power_60,mean_p60,var_p60] = normalize(trainer_power_60);
[trainer_audio_50,mean_a50,var_a50] = normalize(trainer_audio_50);
[trainer_audio_60,mean_a60,var_a60] = normalize(trainer_audio_60);

save('normalizer.mat','mean_p50','mean_p60','mean_a50','mean_a60'...
   ,'var_p50','var_p60','var_a50','var_a60');
%%
% take selective features

load('take_index');

%% power classifier

    
     bestcv = 0;
     bestc = 0;
     bestg = 0;

     for log2c = -1.1:3.1
         for log2g = -4.1:1.1
             cmd = ['-t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q' ];
             cv = svmtrain(response_power_50, trainer_power_50(:,take_p50), cmd);

             if cv >= bestcv
                 bestcv = cv;
                 bestc = 2^log2c;
                 bestg = 2^log2g;
             end
         end
     end

    cmd = ['-t 2 -b 1 -c ',num2str(bestc), ' -g ',num2str(bestg),' -q'];

    model = svmtrain(response_power_50, trainer_power_50(:,take_p50), cmd);
    
    save('classifier/p50','model');
    fprintf('________________\n');

%%
    
     bestcv = 0;
     bestc = 0;
     bestg = 0;


     for log2c = -1.1:3.1
         for log2g = -4.1:1.1
             cmd = ['-t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q' ];
             cv = svmtrain(response_power_60, trainer_power_60(:,take_p60), cmd);

             if cv >= bestcv
                 bestcv = cv;
                 bestc = 2^log2c;
                 bestg = 2^log2g;
             end
         end
     end

    cmd = ['-t 2 -b 1 -c ',num2str(bestc), ' -g ',num2str(bestg),' -q'];

    model = svmtrain(response_power_60, trainer_power_60(:,take_p60), cmd);
    
    save('classifier/p60','model');
    fprintf('________________\n');

%% audio classifier

    bestc = 0;
    bestg = 0;
    bestcv = 0;

     for log2c = -1.1:3.1
         for log2g = -4.1:1.1
             cmd = ['-t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q' ];
             cv = svmtrain(response_audio_50, trainer_audio_50(:,take_a50), cmd);

             if cv >= bestcv
                 bestcv = cv;
                 bestc = 2^log2c;
                 bestg = 2^log2g;
             end
         end
     end

    cmd = ['-t 2 -b 1 -c ',num2str(bestc), ' -g ',num2str(bestg)];

    model = svmtrain(response_audio_50, trainer_audio_50(:,take_a50), cmd);
    save('classifier/a50','model');
    fprintf('________________\n');

%%

    bestc = 0;
    bestg = 0;
    bestcv = 0;

     for log2c = -1.1:3.1
         for log2g = -4.1:1.1
             cmd = ['-t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q' ];
             cv = svmtrain(response_audio_60, trainer_audio_60(:,take_a60), cmd);

             if cv >= bestcv
                 bestcv = cv;
                 bestc = 2^log2c;
                 bestg = 2^log2g;
             end
         end
     end

    cmd = ['-t 2 -b 1 -c ',num2str(bestc), ' -g ',num2str(bestg),' -q'];

    model = svmtrain(response_audio_60, trainer_audio_60(:,take_a60), cmd);
    save('classifier/a60','model');
    
    fprintf('________________\n');
