clear all
close all

animalID='65091';
day_num = '2023-07-19';
session_num = ['A' 'B' 'C'];
folder_recording = 'Q:/sachuriga/OpenEphys/';
video_folder = 'Q:\sachuriga\OpenEphys_video';
save_plot='True';
save_path='Q:\sachuriga\Record_archive\Record_examples';

%% Load data
% Load unit id
[unit_id] = load_unitid(animalID,day_num,folder_recording);

% Load spike and dlc tracking data
[ttl_segments,spike,dlc_m] = load_MultiSegment_time(animalID, ...
    day_num, ...
    session_num, ...
    folder_recording, ...
    video_folder);

% Load spike train
[spike_train,hd,positions] = load_spike(ttl_segments, ...
    spike, ...
    dlc_m, ...
    unit_id, ...
    session_num);

% Screening place cells
plot_screening(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    'binWidth',1/25,...
    'hdBinWidth', 3, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num)

% plot single unit's activity
cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze