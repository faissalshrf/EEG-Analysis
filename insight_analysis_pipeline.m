%% Load subject data
%Set current folder to data directory
cd 'C:\Users\Faiss\Google Drive\Software\MATLAB\Data\Insight_RS_EEG\';

%Define subject you want to analyze
subjectdata.subjectdir       = 'P021'; %Name of folder within data directory
subjectdata.datadir           = 'VCW_1_RS_1_raw.edf'; %Name of EDF file
subjectdata.subjectcode       = 'VCW';

%save file
cd(subjectdata.subjectdir);
subjectdata.filename = [subjectdata.subjectdir '_subjectdata'];
save(subjectdata.filename,'subjectdata');
%% Define dataset based on 'subjectdata', 'filesep' means \ 
cfg = [];
cfg.dataset    = [subjectdata.subjectdir filesep subjectdata.datadir];
cfg.continuous = 'yes';
cfg.channel    = 'all';
data = ft_preprocessing(cfg)

%% To save analysis step in subject dir
filename = [subjectdata.subjectdir '_preprocessed'];
save([subjectdata.subjectdir filesep filename],'data');
clear filename;

%% Visual Inspection
cfg = [];
cfg.continuous = 'yes';
cfg.layout    = 'EEG1020.lay';
cfg.viewmode = 'vertical'; %defines visualization mode
cfg = ft_databrowser(cfg, data) %visualizes data
%By pressing 'q' , cfg is returned with extra field containing start/end for every selected segment
%cfg.artfctdef.visual.artifact

%% Reject artifacts
cfg.artfctdef.reject = 'partial';
cfg.artfctdef.value ='0'
data = ft_rejectartifact(cfg,data)

%To save analysis step in subject dir
filename = [subjectdata.subjectdir '_cleaned'];
save([subjectdata.subjectdir filesep filename],'data');
clear filename;

%% Inspect EEG data withouth artifacts
cfg = ft_databrowser(cfg, data)