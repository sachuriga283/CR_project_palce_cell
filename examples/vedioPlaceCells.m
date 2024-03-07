

filename='S:\Sachuriga\Ephys_Vedio\CR_CA1\65409_Open_Field_50Hz_A2023-11-27T14_36_48.avi';
info = mmfileinfo(filename);
v = VideoReader(filename);
video = read(v);
vr = VideoWriter("Q:\sachuriga\Record_archive\Record_examples/PlaceCellVedio6558820240306.avi");

video_folder = 'S:\Sachuriga\Ephys_Vedio\CR_CA1\';
animalID='65588';
day_num = "2024-03-06";
session_num = "A";
dlc = load_dlc(animalID,day_num,session_num,video_folder);

spikes = find(merge_spk.UIanimal_day)
animalsession='65409A';
animaldays='654092023-11-27';


path='S:\Sachuriga\nwb\CR_CA1/65588_2024-03-06_15-45-53_A_phy_k_manual.nwb';
[spk,position,pos_raw] = Load_nwb(path);

merge_spk=spk;
id = find(merge_spk.presence_ratio>0.9& ...
    merge_spk.isi_violations_ratio<0.2& ...
    merge_spk.amplitude_median>40& ...
    merge_spk.firing_range>0.1& ...
    merge_spk.firing_range<=10& ...
    merge_spk.peak_to_valley>0.000475& ...
    merge_spk.reject_h0==1& ...
    merge_spk.test_stat_si>1.4);

for k=1:length(id)
    spks{k} = merge_spk.spike_times{id(k)};
end

pos= pos_raw;
save('Q:\sachuriga\Record_archive\Record_examples/PlacecellVedio65588_20240306','spk','pos_raw')
filename='C:\Ephys_temp\65588_Open_Field_50Hz_A2024-03-06T15_46_00.avi';
info = mmfileinfo(filename);
v = VideoReader(filename);
vr = VideoWriter("C:\Ephys_temp\PlaceCellVedio6558820240306.avi");
% video = read(v);
open(vr)
% Create a figure for the video frames
fig = figure;
hold on; % Hold on to plot all units on the same figure
pos=pos_raw;
num_points = length(id);
colors = hsv(num_points);

% for tt = 1:length(linear_growth_int)
Xedges = linspace(0,764,50);
Yedges = linspace(0,764,50);

for t = 1:v.NumFrames
    % frame = video(:, :, :, frames_to_plot(t));
    figure(fig)
    v1 = read(v,t);
    imshow(v1)
    ax = gca;
    % Display the frame
    % imshow(frame);
    hold on; % Hold on to plot the dot on top of the frame
    ClearTextFromAxes(ax)
    numspk=0;

    for i = 1:length(id)
        % Get the firing times for this unit that are less than the current time step
        validTimes = spks{i}(spks{i} <= pos(t,1));
        % Plot the positions for these firing times
        for j = 1:length(validTimes)
            % Find the index of the closest time in A for the current firing time
            [~, idx] = min(abs(pos(:, 1) - validTimes(j)));
            % Plot the corresponding x and y position
            plot(pos(idx, 2), pos(idx, 3), ...
                '.', ...
                'LineWidth',2,...
                'MarkerSize',14,...
                'MarkerEdgeColor',[colors(i, :)], ...
                'MarkerFaceColor', [colors(i, :)]);
            hold on
        ax = gca;
        axis square
        ax.Box="off";     
        end
        numspk=numspk+length(validTimes);
    end
    text(100,800,["spikes:" num2str(numspk)])
    text(300,800,["times (sec):" num2str(t)])
    plot(pos(1:t, 2), pos(1:t, 3), ...
        '-', ...
        'LineWidth',1,'Color',[1 1 1 0.2]);
    ax = gca;
    axis square
    ax.Box="off";
    disp([num2str(t) ' frames completed']);
    % Capture the frame
    frame = getframe(fig);
    writeVideo(vr, frame);
end

legend(num2str(id))
hold off; % Release the hold
% Close the video writer
close(vr);
close(fig); % Close the figure window
rootf = 'S:\Sachuriga\';
Recor = [rootf '\Ephys_Recording\CR_CA1\' animal];
nwb = [rootf '\nwb\CR_CA1' animal];

n = 1200;  % 数列中的数的数量
a = 1;    % 起始值
b = length(pos); % 结束值

% 生成线性增长的序列
linear_growth = linspace(a, b, n);
% 对序列中的每个数取整
linear_growth_int = round(linear_growth);
% 显示结果
disp(linear_growth_int);

% Specify the frames o
createFiringPositionVideo(A, firingTimes, 'firingPositionsVideo.mp4');