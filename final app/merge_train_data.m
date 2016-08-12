%% power trainer
load('grid_details/present_grids.mat');

trainer_power_60 = [];
response_power_60 = [];

for Grid = char(grid60)
    
    load(sprintf('grid_details/%s_power_features',Grid));
    
    for file = file_saved
        filename = char(file);
        if exist(filename,'file')==2
            
            load(filename);
            trainer_power_60 = [ trainer_power_60' master_trainer' ]';
            response_power_60 = [response_power_60' responsevar']';
            
        end
    end
end

%%


trainer_power_50 = [];
response_power_50 = [];

for Grid = char(grid50)
    
    load(sprintf('grid_details/%s_power_features',Grid));
    
    
    for file = file_saved
        filename = char(file);
        if exist(filename,'file')==2
            
            load(filename);
            trainer_power_50 = [ trainer_power_50' master_trainer' ]';
            response_power_50 = [response_power_50' responsevar']';
            
        end
    end
end


%% audio trainer
% power 60

trainer_audio_60 = [];
response_audio_60 = [];

for Grid = char(grid60)
    load(sprintf('grid_details/%s_power_features_for_audio_train',Grid));
    
    for file = file_saved
        filename = char(file);
        if exist(filename,'file')==2
            load(filename);
            trainer_audio_60 = [ trainer_audio_60' master_trainer' ]';
            response_audio_60 = [response_audio_60' responsevar']';
            
        end
    end
end

for Grid = char(grid60)
    load(sprintf('grid_details/%s_audio_features_for_audio_train',Grid));
    
    for file = file_saved
        filename = char(file);
        if exist(filename,'file')==2
            load(filename);
            trainer_audio_60 = [ trainer_audio_60' master_trainer' ]';
            response_audio_60 = [response_audio_60' responsevar']';
            
        end
    end
end

%%
trainer_audio_50 = [];
response_audio_50 = [];

for Grid = char(grid50)

   load(sprintf('grid_details/%s_power_features_for_audio_train',Grid));

    
    for file =file_saved
        filename = char(file);
        if exist(filename,'file')==2
            load(filename);
            trainer_audio_50 = [ trainer_audio_50' master_trainer' ]';
            response_audio_50 = [response_audio_50' responsevar']';
            
        end
    end
end

for Grid = char(grid50)
    load(sprintf('grid_details/%s_audio_features_for_audio_train',Grid));
    for file = file_saved
        filename = char(file);
        if exist(filename,'file')==2
            load(filename);
            trainer_audio_50 = [ trainer_audio_50' master_trainer' ]';
            response_audio_50 = [response_audio_50' responsevar']';
           
        end
    end
end


