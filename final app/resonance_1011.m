function varargout = resonance_1011(varargin)
% RESONANCE_1011 MATLAB code for resonance_1011.fig
%      RESONANCE_1011, by itself, creates a new RESONANCE_1011 or raises the existing
%      singleton*.
%
%      H = RESONANCE_1011 returns the handle to a new RESONANCE_1011 or the handle to
%      the existing singleton*.
%
%      RESONANCE_1011('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESONANCE_1011.M with the given input arguments.
%
%      RESONANCE_1011('Property','Value',...) creates a new RESONANCE_1011 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resonance_1011_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resonance_1011_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resonance_1011

% Last Modified by GUIDE v2.5 11-Jan-2016 14:17:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resonance_1011_OpeningFcn, ...
                   'gui_OutputFcn',  @resonance_1011_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before resonance_1011 is made visible.
function resonance_1011_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resonance_1011 (see VARARGIN)

% Choose default command line output for resonance_1011
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.test_file_select,'Value',2);


% UIWAIT makes resonance_1011 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resonance_1011_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







% --- Executes on selection change in test_file_select.
function test_file_select_Callback(hObject, eventdata, handles)
% hObject    handle to test_file_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns test_file_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from test_file_select

global pop_up_value;
pop_up_value = get(handles.test_file_select,'Value'); % 0 = files, 1 = folder



% --- Executes during object creation, after setting all properties.
function test_file_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_file_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_test.
function browse_test_Callback(hObject, eventdata, handles)
% hObject    handle to browse_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pop_up_value;
if pop_up_value==1
    [filename, pathname] = uigetfile( ...
        {'*.wav;*.mat;*.slx;*.mdl',...
        'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)';
        '*.m',  'Code files (*.m)'; ...
        '*.fig','Figures (*.fig)'; ...
        '*.mat','MAT-files (*.mat)'; ...
        '*.mdl;*.slx','Models (*.slx, *.mdl)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a file','MultiSelect', 'on');
    
    if isequal(filename,0)
        disp('user canceled');
        return;
    end
    
    message = '';
    
    file_number = 0;
    
    files = fullfile(pathname,filename);
    
    if iscell(files)
        r = size(files,2);
        file_number = r;
        for i = 1:r
            file_saved = extract_enf_feature_from_practice(char(files(i)));
            [grid,conf]=prediction(file_saved,char(files(i)));
            message = [ message sprintf('%s :\n grid - %s\nconfidence: %.2f%%\n',char(files(i)),grid,conf) ];
        end
        
        %msgbox(message);
    else
        file_number = 1;
        file_saved = extract_enf_feature_from_practice(char(files));
        [grid,conf]=prediction(file_saved,char(files));
        message = [ message sprintf('%s :\n grid - %s\nconfidence: %.2f%%\n',char(files),grid,conf) ];
        %msgbox(message);
    end
    
else
    dirname = uigetdir();
    if isequal(dirname,0)
        disp('user canceled');
        return;
    end
    
    file_struct = dir(sprintf('%s/*.wav',dirname));
    len = length(file_struct);
    file_number = len;
    
    message = '';
    
    for i = 1:len
       
        filename = char(fullfile(dirname,file_struct(i).name));
        file_saved = extract_enf_feature_from_practice(filename);  
        
        [grid,conf]=prediction(file_saved,filename);
        message = [ message sprintf('%s :\n grid - %s\nconfidence: %.2f%%\n',filename,grid,conf) ];
    end
end
    %disp(message);
    if file_number <=10
        msgbox(message);
    else
    
        msg = sprintf('too many grid to show...\nPlease see result.txt file to get the result');
        f = fopen('result.txt','w');
        fprintf(f,'%s',message);
        fclose(f);
        msgbox(msg);
    end
        


% --- Executes on button press in train_btn.
function train_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% feature_extract_power_prev;
% our_power_audio_feature;
% rbf_practice;
% 
% msgbox('training complete......');

% --- Executes on button press in add_grid_btn.
function add_grid_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_grid_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function new_grid_label_Callback(hObject, eventdata, handles)
% hObject    handle to new_grid_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_grid_label as text
%        str2double(get(hObject,'String')) returns contents of new_grid_label as a double

global new_grid_name;
new_grid_name = get(handles.new_grid_label,'String');
new_grid_name = strtrim(new_grid_name);
if isempty(new_grid_name)
    disp('empty new grid.....');
    return
end


%set(handles.new_grid_label,'String','');

load('grid_details/present_grids.mat');
if isempty(find(grid_number==upper(new_grid_name))) && ~isequal(new_grid_name,0) 
    grid_number = [grid_number new_grid_name];
    save('grid_details/present_grids.mat','grid_number','-append');
else
    msgbox('grid already exist...');
end


% --- Executes during object creation, after setting all properties.
function new_grid_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_grid_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in power_folder_btn.
function power_folder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to power_folder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global new_grid_name;

if isequal(new_grid_name,0) 
    disp('please insert grid number');
    return;
end

dirname = uigetdir();
if isequal(dirname,0)
    disp('user canceled');
    return;
end

file_struct = dir(sprintf('%s/*.wav',dirname));
len = length(file_struct);

names = {};

Xt = [];Yt = [];

for i = 1:len
    
    filename = fullfile(dirname,file_struct(i).name);
    names{i} = filename;   
    
    [X,Y] = lpc_calc(char(filename),8);
    Xt = [Xt' X']';
    Yt = [Yt' Y']'; 
end

[sig,c] = nominaltypecombined(char(filename));

nn = sprintf('XY%sC',new_grid_name);
eval([ nn,'=[Xt,Yt]' ]);

if  c==50
    save('pole_data/Power_50_pole_data.mat',nn,'-append');
elseif  c==60
    save('pole_data/Power_60_pole_data.mat',nn,'-append');
end

file = sprintf('grid_details/%s_power.mat',new_grid_name);
save(file,'names');

msgbox('power folder added....');


% --- Executes on button press in audio_folder_btn.
function audio_folder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to audio_folder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load('grid_details/present_grids.mat');

new_grid_name = grid_number(end) ;

% if isequal(new_grid_name,0) 
%     disp('please insert grid number');
%     return;
% end

dirname = uigetdir();
if isequal(dirname,0)
    disp('user canceled');
    return;
end

file_struct = dir(sprintf('%s/*.wav',dirname));
len = length(file_struct);

names = {};
Xt = [];Yt = [];
Xt1 = [];Yt1 = [];

filename = fullfile(dirname,file_struct(1).name);
[sig,c] = nominaltypecombined(char(filename));

for i = 1:len
    
    filename = fullfile(dirname,file_struct(i).name);
    names{i} = filename;  
    
    if c==50
    [X,Y] = lpc_calc(char(filename),6);
    Xt = [Xt' X']';
    Yt = [Yt' Y']'; 
    [X,Y] = lpc_calc(char(filename),8);
    Xt1 = [Xt1' X']';
    Yt1 = [Yt1' Y']'; 
    else
    [X,Y] = lpc_calc(char(filename),12);
    Xt1 = [Xt1' X']';
    Yt1 = [Yt1' Y']'; 
    
    [X,Y] = lpc_calc(char(filename),8);
    Xt = [Xt' X']';
    Yt = [Yt' Y']'; 
    
    end
      
end

[sig,c] = nominaltypecombined(char(filename));

nn1 = sprintf('Xt%s',lower(new_grid_name));
nn2 = sprintf('Yt%s',lower(new_grid_name));

eval([nn1,'=Xt']);
eval([nn2,'=Yt']);

nn3 = sprintf('Xt%s',lower(new_grid_name));
nn4 = sprintf('Yt%s',lower(new_grid_name));

eval([nn1,'=Xt1']);
eval([nn2,'=Yt1']);

if  c==50
    save('pole_data/Audio_50Hz_pole_data_order_6.mat',nn1,nn2,'-append');
    save('pole_data/Audio_50Hz_pole_data_order_8.mat',nn3,nn4,'-append');
    
else
    
    save('pole_data/Audio_60Hz_pole_data_order_8.mat',nn1,nn2,'-append');
    save('pole_data/Audio_60Hz_pole_data_order_12.mat',nn3,nn4,'-append');
        
end


file = sprintf('grid_details/%s_audio.mat',new_grid_name);
save(file,'names');

msgbox('audio folder added....');


% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% %% grid details clear
% load('grid_details/present_grids.mat');
% 
% if length(grid_number)==9
%    return; 
% end
% new_grid = grid_number(10);
% 
% delete(sprintf('grid_details/%s_*.mat',new_grid));
% 
% grid60 = 'ACI';
% grid50 = 'BDEFGH';
% grid_number = 'A':'I';
% 
% save('grid_details/present_grids.mat','grid50','grid60','grid_number');
% 
% %% delete power
% delete(sprintf('power_prev/%s*.mat',new_grid));
% 
% %% delete audio
% delete(sprintf('audio_class_train/%s*.mat',new_grid));
% 
% %% delte classifier
% delete('classifier/*.mat');


% --- Executes on button press in show_enf.
function show_enf_Callback(hObject, eventdata, handles)
% hObject    handle to show_enf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename, pathname] = uigetfile( ...
        {'*.wav;*.mat;*.slx;*.mdl',...
        'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)';
        '*.m',  'Code files (*.m)'; ...
        '*.fig','Figures (*.fig)'; ...
        '*.mat','MAT-files (*.mat)'; ...
        '*.mdl;*.slx','Models (*.slx, *.mdl)'; ...
        '*.*',  'All Files (*.*)'});
    
    if isequal(filename,0)
        disp('user canceled');
        return;
    end
    
    message = '';
    
    file = fullfile(pathname,filename);
    
    [enf,~,~] = enf_extract_same(file,5,3);
    len = length(enf)*2;
    x = 0:2:len-1;
    figure;
    
    plot(x,enf);
    grid on;
    grid minor;
    


% --- Executes during object deletion, before destroying properties.
function test_file_select_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to test_file_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
