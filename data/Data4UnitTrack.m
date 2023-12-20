function [data4unittrack] = Data4UnitTrack(data_path)
%EXTRACT_WAVEFORM Summary of this function goes here
%   Detailed explanation goes here

for j=1:length(data_path)

    [~,spikes_info] = get_clusterinfo_Fprobe({data_path{j}});
    unit_id = spikes_info.cluster_id(spikes_info.Good_ID==1);
    ch = spikes_info.ch(spikes_info.Good_ID==1);
    shanks = spikes_info.ShankID(spikes_info.Good_ID==1);

    sp = loadKSdir(data_path{j});
    [sp.spikeAmps, sp.spikeDepths, sp.templateDepwhichths, sp.templateXpos, sp.tempAmps, sp.tempsUnW, sp.templateDuration, sp.waveforms] = ...
        templatePositionsAmplitudes(sp.temps, sp.winv, sp.ycoords, sp.xcoords, sp.spikeTemplates, sp.tempScalingAmps); %from the spikes toolbox
    sp1 = RemoveNoiseAmplitudeBased(sp);

    spike_sample = int64(sp1.ss);
    spike_cluster = int64(sp1.clu);
    spiketimes = double(sp1.st);

    gwfparams.dataDir = data_path{j};    % KiloSort/Phy output folder
    gwfparams.fileName = 'recording.bin';         % .dat file containing the raw
    gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
    gwfparams.nCh = 64;                      % Number of channels that were streamed to disk in .dat file
    gwfparams.wfWin = [-15 16];              % Number of samples before and after spiketime to include in waveform
    gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out

    max_ch = nan(1,length(unit_id));
    wf_max = cell(1,length(unit_id));
    unit_idd = nan(1,length(unit_id));
    spikeTimes = cell(1,length(unit_id));
    max_group = nan(1,length(unit_id));
    for i = 1:length(unit_id)
        gwfparams.spikeTimes = spike_sample(spike_cluster==unit_id(i)); % Vector of cluster spike times (in samples) same length as .spikeClusters
        gwfparams.spikeClusters = spike_cluster(spike_cluster==unit_id(i));
        
        temp = getWaveForms(gwfparams);
        max_ch(i) = ch(i)+1;
        max_group(i) = shanks(i)+1;
        tmpwfmax = squeeze(temp.waveFormsMean(1,max_ch(i),:));
        wf_max{i} = tmpwfmax';
        unit_idd(i) = unit_id(i);
        tempspktime = spiketimes(spike_cluster==unit_id(i));
        spikeTimes{i} = tempspktime';
        clear tmpwfmax tempspktime 
    end

    data4unittrack.ch{j,1} = max_ch;
    data4unittrack.wf_max{j,1} = wf_max;
    data4unittrack.unit_id{j,1} = unit_idd;
    data4unittrack.spikeTimes{j,1} = spikeTimes;
    data4unittrack.shanks{j,1} = max_group;

end

end

