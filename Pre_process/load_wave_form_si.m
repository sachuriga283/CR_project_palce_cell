function [waveform] = load_wave_form_si(wf,unit_id)

spikes_channel_groups = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_groups.npy']);
spikes_channel_positions = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_positions.npy']);
spikes_channel_map = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_map.npy']);
spikes_cluster_group = dir([folder_recording '\' animalID '_' day_num '*' session_num '*' 'phy' '*' '/cluster_info.tsv']);

spikes_channel_groups = readNPY([spikes_channel_groups(1).folder '/' spikes_channel_groups(1).name]);
spikes_channel_positions = readNPY([spikes_channel_positions(1).folder '/' spikes_channel_positions(1).name]);
spikes_channel_map = readNPY([spikes_channel_map(1).folder '/' spikes_channel_map(1).name]);
spikes_cluster_info = tdfread([spikes_cluster_group(1).folder '/' spikes_cluster_group(1).name]);

waveform=cell(length(unit_id),1);
ch=nan(length(unit_id));
shanks=nan(length(unit_id));

for i=1:length(unit_id)

    temp_wf=wf{i};
    temp_wf1_mean = squeeze(temp_wf.waveFormsMean);
    temp_wf1_raw = squeeze(temp_wf.waveForms);

    % why + 1 matlab counting from 1
    ch(i) = spikes_cluster_info.ch((spikes_cluster_info.cluster_id==unit_id(i))) + 1;
    shanks(i)=spikes_channel_groups(ch(i));
    ch_in_shanks = find(spikes_channel_groups==shanks(i));
    ch_positions_inshank = spikes_channel_positions(ch_in_shanks,:);

    waveform_shank.mean = temp_wf1_mean(ch_in_shanks,:);
    waveform_shank.raw = temp_wf1_raw(:,ch_in_shanks,:);
    waveform_shank.positions = ch_positions_inshank;
    waveform{i}=waveform_shank;

    for j=1:lenth(ch_in_shanks)
    
    
    end


end
end
