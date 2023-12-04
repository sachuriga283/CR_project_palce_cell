clear all
close all

animalID='65409';
day_num = '2023-11-30';
session_num = 'A';

folder_recording = 'S:/Ephys_Recording/CR_CA1';
video_folder = 'S:/Ephys_Vedio/CR_CA1';
save_path='Q:/sachuriga/Record_archive/Record_examples';
save_plot='True';

% save_path = '/Volumes/ntnu/mh-kin/quattrocolo/sachuriga/Sachuriga_Matlab/Sorting_analyze/CR_project_palce_cell/examples'
% folder_recording = '/Volumes/ntnu/mh-kin/quattrocolo/sachuriga/OpenEphys';
% video_folder = '/Volumes/ntnu/mh-kin/quattrocolo/sachuriga/OpenEphys_video';
%% Load data

% Load unit id
[unit_id] = load_unitid(animalID,day_num,folder_recording,session_num);
[ch_id] = load_best_ch(animalID,day_num,folder_recording,session_num);

% Load LFP
[continuous] = load_LFP(animalID,day_num,folder_recording,session_num);

% Load spike and dlc tracking data
[time_f_t, spike, dlc_m] = load_data(animalID, ...
    day_num, ...
    session_num, ...
    folder_recording, ...
    video_folder);

% Load spike train
[spike_train,hd,positions] = load_spike(time_f_t, ...
    spike, ...
    dlc_m, ...
    unit_id, ...
    session_num);

% Calculate plot size
[size_colum,size_raw] = plot_size(unit_id);
% 
%% plot
% Screening place cells
plot_screening(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    'binWidth',1/25,...
    'hdBinWidth', 12, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num, ...
    'session',session_num)

% plot single unit's activity
plot_single_cell(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    ch_id, ...
    continuous, ...
    'Nbins',1/25,...
    'hdBinWidth', 1, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num, ...
    'session',session_num)

close all 
Load_place_cell(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    ch_id, ...
    continuous, ...
    'Nbins',1/25,...
    'hdBinWidth', 1, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num, ...
    'session',session_num)

plot_speedCells(save_path, ...
    animalID, ...
    day_num, ...
    session_num)

cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze
close all 
clear
