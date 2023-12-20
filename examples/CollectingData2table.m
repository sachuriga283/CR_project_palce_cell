clear all
close all

animalID='65165';
day_num = '2023-07-25';
session_num = 'A';

data_ID = string(['#' animalID '%' day_num '%' session_num]);

folder_recording = 'S:\Open_ephys\CR_ca1';
video_folder = 'S:\OpenEphys_video\CR_ca1';
save_path='Q:\sachuriga\Record_archive\Record_examples';
save_plot='True';
nbins = 1/25;

% Load unit id
[unit_id] = load_unitid(animalID,day_num,folder_recording,session_num);
[ch_id] = load_best_ch(animalID,day_num,folder_recording,session_num);

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

close all
sum_data = Load_place_cell(positions, ...
    hd, ...
    spike_train, ...
    unit_id, ...
    ch_id, ...
    'Nbins',1/25,...
    'hdBinWidth', 1, ...
    'smooth',1, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num, ...
    'session',session_num)

dataDir = dir([animalID '_' day_num '*' session_num '*' 'phy' '*']);
% EXAMPLE INPUT
spikes_t =dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_times.npy'])),' ',''));
spikes_id = dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_clusters.npy'])),' ',''));

spike_time = ceil((readNPY([spikes_t(1).folder '/' spikes_t(1).name])));
spike_cluster= int64(readNPY([spikes_id(1).folder '/' spikes_id(1).name]));
clear gwfparams

gwfparams.dataDir = spikes_t(1).folder;    % KiloSort/Phy output folder
gwfparams.fileName = 'recording.dat';         % .dat file containing the raw
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.nCh = 64;                      % Number of channels that were streamed to disk in .dat file
gwfparams.wfWin = [-40 40];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out

for i=1:length(unit_id)
    % for i=60:66
    gwfparams.spikeTimes = spike_time(find(spike_cluster==unit_id(i))); % Vector of cluster spike times (in samples) same length as .spikeClusters
    gwfparams.spikeClusters = spike_cluster(spike_cluster==unit_id(i)); % Vector of cluster IDs (Phy nomenclature)   same length as .spikeTimes
    temp = getWaveForms(gwfparams);
    wf{i} = temp;
    disp([num2str(i*100/length(unit_id)) "%"])
end

varNames = {'data_ID', 'unit_ID', 'ch_ID', 'though2peak','result_place','result_boarder','speedScores', 'mean_rate', 'max_rate' 'information_rate', 'information_content'};
varTypes = {'string', 'double', 'double', 'double' , 'string' , 'string', 'double', 'double', 'double', 'double', 'double'};
% crhip_Table = table('Size', [0, numel(varNames)],'VariableTypes', varTypes, 'VariableNames', varNames);
% writetable(crhip_Table, 'Q:\sachuriga\Record_archive\crhip_Table.csv');

crhip_Table = readtable('Q:\sachuriga\Record_archive\crhip_Table.csv', 'Delimiter', ',','ReadVariableNames', true);

for k = 1:length(unit_id)
    %% Peak to vally durations
    though2peak = waveform_vally2peak(wf,unit_id,ch_id);

    data_ID = string(['#' animalID '%' day_num '%' num2str(unit_id(k)) '&' session_num]);

    %% Place field
    activity_s = spike_train{1,k};
    [pos,~] = pos_filtered_with_speed(positions);
    map = analyses.map(pos,activity_s','smooth',0,'binWidth',nbins,'blanks','off','minTime',0.5);
    [fieldsMap, f] = analyses.placefield(map,'minPeak',1,'minBins',9);
    [result_place, result_boarder, speedScores, mean_rate, max_rate] = place_cell_classifier(sum_data,activity_s,pos,positions);
    clear information
    [information, sparsity, selectivity] = analyses.mapStatsPDF(map);

    empty_Table = table(data_ID,unit_id(k),ch_id(k),though2peak(k),result_place,result_boarder,speedScores(1),mean_rate,max_rate, information.rate,information.rate, 'VariableNames', varNames);

    if isempty(crhip_Table.data_ID)
        crhip_Table = [crhip_Table; empty_Table];
        disp('Tables appended successfully.');
    else
        commonIDs = intersect(empty_Table.data_ID, crhip_Table.data_ID);
        if isempty(commonIDs)
            % Append tables if there are no common data_ID values
            crhip_Table = [crhip_Table; empty_Table];
            disp(['Tables appended successfully.' num2str(k*100/length(unit_id)) '%']);
        else
            disp('Hey, you are reapting');
        end
    end

end

writetable(crhip_Table, 'Q:\sachuriga\Record_archive\crhip_Table.csv' ,'WriteVariableNames', true);
cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze\CR_project_palce_cell\Post_process

clear all
close all