clear all
close all

animalID='65165';
day_num = '2023-07-03';
session_num = 'A';
folder_recording = 'Q:\sachuriga\OpenEphys';
video_folder = 'Q:\sachuriga\OpenEphys_video';
save_plot='True';
save_path='Q:\sachuriga\Record_archive\Record_examples';

%% Load data
% Load unit id
[unit_id] = load_unitid(animalID,day_num,folder_recording);

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

%% plot
% Screening place cells
plot_screening(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    'binWidth',1/20,...
    'hdBinWidth', 1, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num)

% plot single unit's activity


cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze

