function [waveform] = load_wave_form_si(wf,unit_id,options)

arguments
    wf
    unit_id
    options.folder_recording (1,1)  string = 'Q:\sachuriga\OpenEphys'
    options.save_path (1,1)  string = 'Q:\sachuriga\Record_archive\Record_examples'
    options.animalID (1,1)  string = '65165'
    options.day_num (1,1)  string = '2023-07-01'
    options.session (1,1)  string = 'A'
end


folder_recording = options.folder_recording;
animalID = options.animalID;
day_num = options.day_num;
session_num = options.session;

% befor and after 0.4 ms

time_window=82;
spikes_channel_groups = dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_groups.npy'])),' ',''));
spikes_channel_positions = dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_positions.npy'])),' ',''));
spikes_channel_map = dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/channel_map.npy'])),' ',''));
spikes_cluster_group = dir(strrep(fullfile(join([folder_recording '/' animalID '_' day_num '*' session_num '*' 'phy' '*' '/cluster_info.tsv'])),' ',''));

spikes_channel_groups = readNPY([spikes_channel_groups(1).folder '/' spikes_channel_groups(1).name]);
spikes_channel_positions = readNPY([spikes_channel_positions(1).folder '/' spikes_channel_positions(1).name]);
spikes_channel_map = readNPY([spikes_channel_map(1).folder '/' spikes_channel_map(1).name]);
spikes_cluster_info = tdfread([spikes_cluster_group(1).folder '/' spikes_cluster_group(1).name]);

waveform=cell(length(unit_id),1);
ch=nan(length(unit_id));
shanks=nan(length(unit_id));

for i=1:length(unit_id)

    temp_wf=wf{i};
    nonNanCount = sum(~isnan(temp_wf.spikeTimeKeeps));

    temp_wf1_mean = squeeze(temp_wf.waveFormsMean);
    temp_wf1_raw = squeeze(temp_wf.waveForms);
    M = abs(max(temp_wf1_mean,[],"all"));
    M1 = abs(min(temp_wf1_mean,[],"all"));
    M2 = ceil(max([M M1])/(80));
    % why + 1 matlab counting from 1
    ch(i) = spikes_cluster_info.ch((spikes_cluster_info.cluster_id==unit_id(i))) + 1;
    shanks(i)=spikes_channel_groups(ch(i));
    ch_in_shanks = find(spikes_channel_groups==shanks(i));
    ch_positions_inshank = spikes_channel_positions(ch_in_shanks,:);

    ch_positions_inshank(:,2) = ch_positions_inshank(:,2)*M2;
    waveform_shank.mean = temp_wf1_mean(ch_in_shanks,:);
    %         waveform_shank.raw = temp_wf1_raw(:,ch_in_shanks,:);
    temp_raw = temp_wf1_raw(:,ch_in_shanks,:);
    waveform_shank.positions = ch_positions_inshank;
    waveform{i}=waveform_shank;

    clear temp_xcor

    temp_waveform_sem = nan(length(ch_in_shanks),time_window);

            f2= figure;
    for j=1:length(ch_in_shanks)

        temp_xcor (j,:) = ch_positions_inshank(j,1)-8.25 : 16.5/81 : ch_positions_inshank(j,1)+8.25;

        %transform to Micro-scale
        waveform_shank.mean(j,:) = temp_wf1_mean(ch_in_shanks(j),:)*0.195 + ch_positions_inshank(j,2);
        temp_raw11 (:,j,:) = temp_raw (:,j,:).*0.195 + ch_positions_inshank(j,2);
%         figure(f1)
%         plot(temp_xcor (j,:),waveform_shank.mean(j,:))
        hold on
        % for calculating the sem
        temp_raw1 = squeeze(temp_raw11 (1:nonNanCount,j,:));
        temp_sem=nan(1,time_window);
%         for k1=1:nonNanCount
%             hold on
%             plot(temp_xcor (j,:),temp_raw1(k1,:),'k-')
%         end

        for k=1:length(temp_xcor)
            % temp_sem(k) = std(temp_raw1(1:min([nonNanCount length(temp_wf.spikeTimeKeeps)]),k))/sqrt(min([nonNanCount length(temp_wf.spikeTimeKeeps)]));
            temp_sem(k) = std(temp_raw1(1:min([nonNanCount length(temp_wf.spikeTimeKeeps)]),k));
        end
        
        figure(f2)
        temp_waveform_sem (j,:) = temp_sem;
        plot(temp_xcor (j,:),waveform_shank.mean(j,:), ...
            'w-', ...
            'LineWidth',2)

        hold on
        H = plotSEM(temp_xcor (j,:), waveform_shank.mean(j,:), temp_sem*2, temp_sem*2);

    end

    waveform_shank.xcor = temp_xcor;
    waveform_shank.sem = temp_waveform_sem;
    waveform_shank.raw = temp_raw11;
    waveform{i}=waveform_shank;

end

path = [options.save_path '/' options.animalID '/' options.day_num '/' options.session '/' 'wave_form'];
mk_path=fullfile(join(path));
export_path=strrep(mk_path,' ','');
mkdir(export_path)

image_name=[export_path '/' 'waveform' '.mat'];
image_path=fullfile(join(image_name));
image_export_path=strrep(image_path,' ','');
save(image_export_path,"waveform");

end
