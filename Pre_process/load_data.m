
function [time_f_t,spike,dlc_m] = load_data(animalID,day_num,session_num,folder_recording,video_folder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

animalID = animalID;
day_num = day_num;
session_num = session_num;

% folder_recording = 'Q:\sachuriga\OpenEphys\';
folder_recording=folder_recording;
video_folder=video_folder;

cd(folder_recording)
TTL_name = dir([animalID '_' day_num '*' session_num '/**/TTL/timestamps.npy']);

cd(TTL_name(1).folder)
time_s = readNPY (TTL_name(1).name);

cd(folder_recording)
TTL_state = dir([animalID '_' day_num '*' session_num '/**/TTL/states.npy']);
cd(TTL_state(1).folder)
states_s = readNPY (TTL_state(1).name);

% generate TTL time stemps
time_f_t = time_s(states_s==-6);

cd(folder_recording)
spikes_t = dir([animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_times.npy']);
spikes_id = dir([animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_clusters.npy']);
spikes_amplitude = dir([animalID '_' day_num '*' session_num '*' 'phy' '*' '/amplitudes.npy']);


spike.spikes_t = double(readNPY([spikes_t(1).folder '/' spikes_t(1).name]))/30000;
spike.spike_id = double(readNPY([spikes_id(1).folder '/' spikes_id(1).name]));
spike.spike_amplitude  = double(readNPY([spikes_amplitude(1).folder '/' spikes_amplitude(1).name]));


% Load dlc tracking file
cd(video_folder)
v_name = dir([animalID '*' session_num '*' day_num '*.csv']);
dlc_m = readmatrix(v_name(1).name);

end