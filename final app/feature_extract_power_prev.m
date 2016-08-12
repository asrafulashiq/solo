load('grid_details/present_grids.mat');

grids = char(grid_number);

win_time = 2; % 2 sec window time

%% check new grid
new_=false;
last_grid = grid_number(end);
if  length(grid_number)>9
    new_ = true;  
    grids = grid_number(end);
else
   return;  % return if no new grid
end


for Grid = grids
    counter = 1;
    
    file_saved = {}; % extracted features file
    
   %% 
    load(sprintf('grid_details/%s_power.mat',Grid)); 
    [sig,c] = nominaltypecombined(char(names{1}));
    
    if c==50
        if isempty(find(grid50==Grid))
            grid50(end+1) = Grid;
            save('grid_details/present_grids.mat','grid50','-append');
        end
    else
        if isempty(find(grid60==Grid))
            grid60(end+1) = Grid;
            save('grid_details/present_grids.mat','grid60','-append');
        end
    end
    
    %%
    for file = names
        
        filename = char(file);
        
        if exist(filename,'file')==2
             
            file_to_save = sprintf('power_prev/%sP%d.mat',Grid,counter);
           
            if exist(file_to_save,'file')==0
                fprintf('loading from %s\n',filename);
                enf = power_enf(filename,win_time);
                feature_extract(enf,char(Grid),file_to_save);
                
                file_saved{counter} = file_to_save;
                counter = counter + 1;
            else
                fprintf('%s does exist\n',file_to_save);
            end
                  
        else
            fprintf('%s does not exist\n',filename);
        end
        
    end
    
    save(sprintf('grid_details/%s_power_features',Grid),'file_saved');
    
end