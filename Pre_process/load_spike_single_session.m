

function [spike_train,hd,positions] = load_spike_single_session(time_f_t, spike, dlc_m,unit_id)

% spike_train is a 4 x n cell arry, where spike_train{1,n} is the raw spike 
% of unit n. spike_train{2,n} is the corresponding order of spike in position 
% vector from unit n. spike_train{3,n} is the cordination of spike from
% unit n. spike_train{4,k} is the head direction of spike from unit n.

spikes_v = find(spike.spikes_t>time_f_t(1));
Spike = spike.spikes_t(spikes_v);
spike_id = spike.spike_id(spikes_v);
Amplitude = spike.spike_amplitude(spikes_v);

% calculate spike position and spike hd
spike_train=cell(4,length(unit_id));
time_frame = time_f_t(1:length(dlc_m));
% time_frame = time_f_t(1:length(dlc_m));

[hd, positions] = load_positions(time_frame,dlc_m(:,2),dlc_m(:,3),dlc_m(:,14),dlc_m(:,15),dlc_m(:,8),dlc_m(:,9));

%Cordination of central brain

cx_n=positions(:,2);
cy_n=positions(:,3);
spike_train{5,1}=unit_id;

% spikes and spike_id with TTL
for k=1:1:length(unit_id)

    clear id
    clear spike_train_t
    unit_id_0=unit_id(k);
    id=spike_id==unit_id_0;
    spike_train_t=Spike(id);
    spike_train{1,k}=spike_train_t';

    clear position_s
    for k1=1:1:length(spike_train_t)
        [~,position_s(k1)]= min (abs(time_frame-spike_train_t(k1)));
    end
    spike_train{2,k}=position_s;
    clear activity
    activity.x = cx_n(position_s);
    activity.y = cy_n(position_s);
    spike_train{3,k} = activity;
    spike_train{4,k} = hd(position_s);
    spike_train{6,k} = Amplitude(id);
    
end


end
