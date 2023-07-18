

function [spike_train,hd,positions] = load_spike_multi_session(ttl_segments, spike, dlc_m,unit_id,session_num)

% spike_train is a 4 x n cell arry, where spike_train{1,n} is the raw spike
% of unit n. spike_train{2,n} is the corresponding order of spike in position
% vector from unit n. spike_train{3,n} is the cordination of spike from
% unit n. spike_train{4,k} is the head direction of spike from unit n.

hd=cell(length(session_num),1);
positions=struct;
spike_train=struct;
spike_train.unit_id=unit_id;

for k=1:length(session_num)

    clear time_frame
    clear dlc_temp
    %     spikes_v = find(spike.spikes_t>ttl_segments(1));
    %     Spike = spike.spikes_t(spikes_v);
    %     spike_id = spike.spike_id(spikes_v);

    % calculate spike position and spike hd

    %    time_frame = ttl_segments(2:length(dlc_temp)+1);
    dlc_temp = dlc_m.matrix{k};
    time_frame_temp = ttl_segments.session_ttl{k};
    time_frame = time_frame_temp(2:length(dlc_temp)+1);

    spikes_v = find(spike.spikes_t>time_frame_temp(1) & spike.spikes_t<time_frame_temp(end));
    Spike = spike.spikes_t(spikes_v);
    spike_id = spike.spike_id(spikes_v);


    [hd_temp, positions_temp] = load_positions(time_frame,dlc_temp(:,2),dlc_temp(:,3),dlc_temp(:,5),dlc_temp(:,6),dlc_temp(:,8),dlc_temp(:,9));

    %Cordination of central brain
    cx=positions_temp(:,2);
    cy=positions_temp(:,3);
    cx_n=normalize(cx,"range");
    cy_n=normalize(cy,"range");

    positions.x{k}=cx_n;
    positions.y{k}=cy_n;
    hd{k}=hd_temp;
    positions.time{k}=time_frame;

    % spikes and spike_id with TTL
    for k1=1:1:length(unit_id)

        clear id
        clear spike_train_t
        unit_id_0=unit_id(k1);
        id=spike_id==unit_id_0;
        spike_train_t=Spike(id);

        spike_train(k).time_spike{k1}=spike_train_t';

        clear position_s
        if isempty(spike_train_t)==1

            spike_train(k).time_spike{k1}=nan;
            spike_train(k).spike_cor{k1} = nan;
            spike_train(k).spike_hd{k1} = nan;
            spike_train(k).positions{k1}=nan;

        else

            for k2=1:1:length(spike_train_t)
                [~,position_s(k2)]= min (abs(time_frame-spike_train_t(k2)));
            end

            spike_train(k).time_spike{k1}=spike_train_t';
            spike_train(k).positions{k1}=position_s;
            clear activity
            activity.x = cx_n(position_s);
            activity.y = cy_n(position_s);
            spike_train(k).spike_cor{k1} = activity;
            spike_train(k).spike_hd{k1} = hd_temp(position_s);

        end

    end

end

end
