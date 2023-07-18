function [ttl_segments,spike,dlc_m] = load_MultiSegment_time(animalID,day_num,session_num,folder_recording,video_folder)


Sessions=struct;
dlc_m=struct;
ttl_segments=struct;

for k=1:length(session_num)

    %     Find ttl time series
    clear sessions
    sessions = session_num(k)
    ttl_time_struc = dir([folder_recording animalID '_' day_num '*' sessions '/**/TTL/timestamps.npy']);
    ttl_time = readNPY([ttl_time_struc.folder '/' ttl_time_struc.name]);

    ttl_state_struc = dir([folder_recording animalID '_' day_num '*' sessions '/**/TTL/states.npy']);
    ttl_state = readNPY([ttl_state_struc.folder '/' ttl_state_struc.name]);

    frame_time = ttl_time(ttl_state==-6);

    %     Find recording time and
    recording_time_struc = dir([folder_recording animalID '_' day_num '*' sessions '/**/continuous/**/timestamps.npy']);
    recording_time = readNPY([recording_time_struc.folder '/' recording_time_struc.name]);

    Sessions(k).Start = recording_time(1);
    Sessions(k).Stop = recording_time(end);
    Sessions(k).ttl = frame_time;

    ttl_segments.session_name{k} = sessions;
end

ttl_segments.timepoint(1) = Sessions(1).Start;
ttl_segments.timepoint(2) = Sessions(1).Stop;
ttl_segments.session_ttl{1} = Sessions(1).ttl-Sessions(1).Start;

for k1=2:length(session_num)

    ttl_segments.timepoint(k1+1) = ttl_segments.timepoint(k1) + (Sessions(k1).Stop-Sessions(k1).Start);
    ttl_segments.session_ttl{k1} = Sessions(k1).ttl + ttl_segments.timepoint(k1) - Sessions(k1).Start;
    
end

ttl_segments.murge_ttl = vertcat(ttl_segments.session_ttl{:});

spikes_t = dir([folder_recording '/' animalID '_' day_num '*' 'phy' '*' '/spike_times.npy']);
spikes_id = dir([folder_recording '/' animalID '_' day_num '*' 'phy' '*' '/spike_clusters.npy']);
spike.spikes_t = double(readNPY([spikes_t.folder '/' spikes_t.name]))/30000;
spike.spike_id = double(readNPY([spikes_id.folder '/' spikes_id.name]));

for k2=1:length(session_num)
    sessions = session_num(k2)
    v_name = dir([video_folder '/' animalID '_' '*' sessions '*' day_num '*.csv']);
    dlc_m.folder{k2} = v_name.name;
    dlc_m.matrix{k2} = readmatrix([v_name.folder '/' v_name.name]);
    dlc_m.session_name{k2} = session_num(k2);
end

end
