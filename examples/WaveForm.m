clear all
close all

animalID = '65091';
day_num = '2023-08-08';
session_num = 'C';
folder_recording = 'Q:\sachuriga\OpenEphys';
video_folder = 'Q:\sachuriga\OpenEphys_video';
save_plot='True';
save_path='Q:\sachuriga\Record_archive\Record_examples';
[unit_id] = load_unitid(animalID,day_num,folder_recording,session_num);

dataDir = dir([animalID '_' day_num '*' session_num '*' 'phy' '*']);

% EXAMPLE INPUT
spikes_t = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_times.npy']);
spikes_id = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/spike_clusters.npy']);

spike_time = ceil((readNPY([spikes_t(1).folder '/' spikes_t(1).name])));
spike_cluster= int64(readNPY([spikes_id(1).folder '/' spikes_id(1).name]));

clear gwfparams

gwfparams.dataDir = spikes_t(1).folder;    % KiloSort/Phy output folder
gwfparams.fileName = 'recording.dat';         % .dat file containing the raw 
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.nCh = 64;                      % Number of channels that were streamed to disk in .dat file
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out

for i=1:length(unit_id)
gwfparams.spikeTimes = spike_time(find(spike_cluster==unit_id(i))); % Vector of cluster spike times (in samples) same length as .spikeClusters
gwfparams.spikeClusters = spike_cluster(spike_cluster==unit_id(i)); % Vector of cluster IDs (Phy nomenclature)   same length as .spikeTimes
temp=getWaveForms(gwfparams);
wf{i} = temp;
end

%Extract the waveform from raw data
[waveform] = load_wave_form_si(wf,unit_id, ...
    'folder_recording',folder_recording, ...
    'save_path',save_path, ...
    'animalID',animalID, ...
    'day_num',day_num, ...
    'session',session_num)

figure; 
imagesc(squeeze(wf.waveFormsMean))
set(gca, 'YDir', 'normal'); xlabel('time (samples)'); ylabel('channel number'); 
colormap(colormap_BlueWhiteRed); caxis([-1 1]*max(abs(caxis()))/2); box off;

squeeze(wf.waveFormsMean)