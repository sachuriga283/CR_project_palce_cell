clear all
close all

animalID='65091';
day_num = '2023-07-03';
session_num = 'A';
folder_recording = 'Q:\sachuriga\OpenEphys';
video_folder = 'Q:\sachuriga\OpenEphys_video';
save_plot='True';
save_path='Q:\sachuriga\Record_archive\Record_examples';

[unit_id] = load_unitid(animalID,day_num,session_num,folder_recording);
% Load spike and dlc tracking data
[time_f_t, spike, dlc_m] = load_data(animalID, ...
    day_num, ...
    session_num, ...
    folder_recording, ...
    video_folder);

% % spikes and spike_id with TTL
% spikes_v = find(spike.spikes_t>time_f_t(1));
% Spike = spike.spikes_t(spikes_v);
% spike_id = spike.spike_id(spikes_v);
% 
% % calculate spike position and spike hd
% spike_train=cell(4,length(unit_id));
% time_frame = time_f_t(2:length(dlc_m)+1);
% 
% [hd, positions] = load_positions(time_frame,dlc_m(:,2),dlc_m(:,3),dlc_m(:,5),dlc_m(:,6),dlc_m(:,8),dlc_m(:,9));
% 
% %Cordination of central brain
% cx=positions(:,2);
% cy=positions(:,3);
% cx_n=normalize(cx,"range");
% cy_n=normalize(cy,"range");
% spike_train{5,1}=unit_id;
% 
% % spikes and spike_id with TTL
% for k=1:1:length(unit_id)
% 
%     clear id
%     clear spike_train_t
%     unit_id_0=unit_id(k);
%     id=find(spike_id==unit_id_0);
%     spike_train_t=Spike(id);
%     spike_train{1,k}=spike_train_t';
% 
%     clear position_s
%     for k1=1:1:length(spike_train_t)
%         [~,position_s(k1)]= min (abs(time_frame-spike_train_t(k1)));
%     end
%     spike_train{2,k}=position_s;
%     clear activity
%     activity.x = cx_n(position_s);
%     activity.y = cy_n(position_s);
%     spike_train{3,k} = activity;
%     spike_train{4,k} = hd(position_s);
% 
% end

[spike_train,hd,positions] = load_spike(time_f_t, spike, dlc_m,unit_id);

%% Calculate plot size
[size_colum,size_raw] = plot_size(unit_id);

%% Screening place cells
plot_screening_PC_HDcells(positions, ...
    hd, ...
    spike_train, ...
    "PlotSize",[size_colum size_raw], ...
    'binWidth',1/28,...
    'hdBinWidth', 5, ...
    'smooth',2, ...
    'save_plot',save_plot,...
    'save_path',save_path,...
    'animalID',animalID,...
    'day_num',day_num)


% for k3=1:1:length(unit_id)
%
%     clear acitivity
%     clear positions
%     clear activity_s
%     clear spikehd
%     clear tc
%     activity = spike_train{3,k3};
%     spikehd = spike_train{4,k3};
%     spike_t = spike_train{1,k3};
%     subplot(3,2,k3)
%     plot(cx_n,cy_n,'k')
%     hold on
%     plot(activity.x,activity.y,'r.')
%     title(['unit' ' ' num2str(unit_id(k3))])
%     ax = gca; % 获取当前图形的坐标轴对象
%     ax.YDir = 'reverse'; % 设置Y轴反向
%     xticks([0 1])
%     yticks([0 1])
%
%     subplot(3,2,k3+2)
%     activity_s=spike_train{1,k3};
%
%     map = FiringMap([time_frame cx_n cy_n],activity_s','smooth',10,'nBins',[100 100]);
%     PlotColorMap(map.rate,map.time)
%     ax = gca; % 获取当前图形的坐标轴对象
%     ax.YDir = 'reverse'; % 设置Y轴反向
%     title(['Hz' ' ' num2str(max(map.rate,[],'all'))])
%     xticks([1 50])
%     yticks([1 50])
%     xticklabels({'0' '1'})
%     yticklabels({'0' '1'})
%     colorbar
%
%     subplot(3,2,k3+4)
%
%     tc = analyses.turningCurve(spikehd, hd, 1/50);
%     plot((tc(:,1)),(tc(:,2)))
%     xlim([0 360])
%     %hold on
%     %polarhistogram(tc(:,2),10)
%
% end
cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze

