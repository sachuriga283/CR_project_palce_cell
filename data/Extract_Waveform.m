function [outputArg1,outputArg2] = Extract_Waveform(data_path,unit_id,ch)
%EXTRACT_WAVEFORM Summary of this function goes here
%   Detailed explanation goes here

sp = loadKSdir(data_path);
[sp.spikeAmps, sp.spikeDepths, sp.templateDepwhichths, sp.templateXpos, sp.tempAmps, sp.tempsUnW, sp.templateDuration, sp.waveforms] = ...
    templatePositionsAmplitudes(sp.temps, sp.winv, sp.ycoords, sp.xcoords, sp.spikeTemplates, sp.tempScalingAmps); %from the spikes toolbox
sp1 = RemoveNoiseAmplitudeBased(sp);

spike_time = int64(sp1.ss);
spike_cluster = int64(sp1.clu);

gwfparams.dataDir = data_path;    % KiloSort/Phy output folder
gwfparams.fileName = 'recording_hf.bin';         % .dat file containing the raw
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.nCh = 64;                      % Number of channels that were streamed to disk in .dat file
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 500;                    % Number of waveforms per unit to pull out

for i = 1:length(unit_id)

    gwfparams.spikeTimes = spike_time(spike_cluster==unit_id(i)); % Vector of cluster spike times (in samples) same length as .spikeClusters
    gwfparams.spikeClusters = spike_cluster(spike_cluster==unit_id(i));
    temp = getWaveForms(gwfparams);
    max_ch{i} = ch(i)+1;
    wf_max{i} = temp.waveFormsMean(1,max_ch,:)
    unit_id{i} = unit_id{i};
end

end

