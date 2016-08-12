
count = 11;

grid_tot = [9,10,11,11,11,8,11,11,11];

grid_tot = 2*ones(1,9);
grids = 'A':'I';

grid_count = 1;

for grid = grids
    
    file_saved = {};
    names = {};
    
    count = grid_tot(grid_count);
    
    for i = 1:count
        
        %names{i} = sprintf('/Users/mac/Desktop/apps/data/Grid_%s/Audio_recordings/Train_Grid_%s_A%d.wav',grid,grid,i);
        file_saved{i} = sprintf('audio_class_train/%sA%d.mat',grid,i);
    end
    
    save( sprintf('grid_details/%s_audio_features_for_audio_train',grid), 'file_saved' );
    
grid_count = grid_count+1;    
end

%% present grids 
grid_number = 'A':'I';
grid60 = 'ACI';
grid50 = 'BDEFGH';
save('grid_details/present_grids.mat','grid_number','grid50','grid60');


