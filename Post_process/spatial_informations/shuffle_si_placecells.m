%% Set parameters
disp('Setting parameters...');
binWidth = 1/25;
smoothBin = 1;

minshift = 20; maxshift = 60; % seconds
n_iters = 1000; % size of null
n_units = 75; % number of units

save_path = 'Q:/sachuriga/Record_archive/Record_examples';
animalID = '65410';
day_num = '2023-12-05';
session_num = 'A';

[pos,~] = pos_filtered_with_speed(positions);
%% Data Info
t = pos(:,1); % your timestamps;
tpf = mode(diff(t)); % time per frame (0.01 seconds) t(2)-t(1)
sessionLength = t(end); % seconds
maxshift = floor(sessionLength) - maxshift;

%% Iterate over units (shifting)
% grab position data for the session youre looking at
n_units = length(spike.spike_t);
disp('(A) Calculating null spike trains...');


for u = 1:n_units
    % pull out the spikeCounts for unit 'u' (0,1,2)
    %unit = D.units(u);
    %spikeCounts = unit.spikeCounts;
    spikeTimes = spike.spike_t{u};% grab original units spiketimes
    [spkPos, spkInd, rejected] = data.getSpikePositions(spikeTimes,pos);
    spikeT=pos(spkInd,1);
    firingRate = analyses.instantRate(spikeT, pos);
    spikecounts =  int64(firingRate);

    % calculate spatial ratemap
    map = analyses.map(pos, [pos(:,1), firingRate],'smooth',smoothBin,'binWidth',binWidth,'minTime',0.1); % set additional parameters; we use 15x15 bins; smoothing = 1 or 2
    figure;
    plot.colorMap(map.z,map.time,'bar','on')

    % calculate spatial info and other stats of the map
    [information, sparsity, selectivity] = analyses.mapStatsPDF(map);

    % grab information content
    test_stat_si(u) = information.content;

    parfor n = 1:n_iters
        tic;
        disp(['Iteration # ', num2str(n), '  ;#', num2str(u),'  of the neurons']);

        shift_val = floor(minshift/tpf + (maxshift/tpf-minshift/tpf).*rand(1)); % Calculate shift in bins
        spikeCounts_shift = circshift(spikecounts, shift_val); % circularly shift spikes, wrap to start
        [spikeTimes_shift, spikeInds_shift] = convert_train_to_times(full(spikeCounts_shift), t);
        firingRate = analyses.instantRate(spikeTimes_shift, pos);

        map = analyses.map(pos, [t firingRate],'smooth',smoothBin,'binWidth',binWidth,'minTime',0.1); % set additional parameters; we use 15x15 bins; smoothing = 1 or 2

        % calculate spatial info and other stats of the map
        [information, sparsity, selectivity] = analyses.mapStatsPDF(map);

        % grab information content
        null_stat_si(n,u) = information.content;
        %U{n} = units_null;
        % clear units_null;
        toc;
    end

end

%% Test if the SI exceeds the null distribution

for u = 1:n_units
    percentile = 0.95;
    null_dist = null_stat_si(:,u);
    test_stat = test_stat_si(u);
    reject_h0(u) = h0_test_nonparametric(test_stat, null_dist, percentile)
end


[size_colum,size_raw] = plot_size(unit_id);
f_pc=figure;
    gaf=f_pc;
    set(gaf, 'Color', 'black');
colormap('jet')

for k3=1:1:length(unit_id)

    clear spikehd
    clear temp_s
    clear map
    clear fieldsMap
    clear fields
    clear score
    spikeTimes = spike.spike_t{k3};% grab original units spiketimes
    [spkPos, spkInd, rejected] = data.getSpikePositions(spikeTimes,pos);
    spikeT=pos(spkInd,1);
    firingRate = analyses.instantRate(spikeT, pos);
    spikecounts =  int64(firingRate);
    figure(f_pc)
    subplot(size_colum,size_raw,k3)

    %     map = FiringMap([time_frame cx_n cy_n],[activity_s'],'smooth',options.smooth,'nBins',[nbin nbin]);

    map = analyses.map(pos,[pos(:,1), firingRate],'smooth',smoothBin,'binWidth',binWidth,'minTime',0.1);
    fp = plot.colorMap(map.z,map.time,'bar','off');
    [fieldsMap, fields] = analyses.placefield(map);
    score = analyses.borderScore(map.z, fieldsMap, fields);

    hold on
    ax = subplot(size_colum,size_raw,k3); % 获取当前图形的坐标轴对象
    ax.YDir = 'reverse'; % 设置Y轴反向

    ax.Color='black';
    ax.XColor = 'white';
    ax.YColor = 'white';

    title(['Hz' ' ' num2str(max(map.z,[],'all'))],'FontSize',5,'Color','white')
    xticks([1 (length(map.x)-1)])
    yticks([1 (length(map.y)-1)])
    xticklabels({'0' '1'})
    yticklabels({'0' '1'})
    axis square
    % Draw a rectangle around the subplot
    ax.Box = 'off';
    if reject_h0(k3) == 1
        if test_stat_si(k3) >= 0.67
            if isempty(fields)==0
                if mean(firingRate)>0.1 && mean(analyses.instantRate(spikeT, positions)) <= 10
                    ax.LineWidth = 2 ;
                    ax.Box = 'on';
                    ax.Color='r';
                    ax.XColor = 'red';
                    ax.YColor = 'red';
                    set(ax, 'Visible', 'off');
                    set(fp, 'Visible', 'off');
                    sp_cell(k3)=1;
                else
                     disp([num2str(unit_id(k3)) 'FR out of range'])
                end
            end

        else
            disp([num2str(unit_id(k3)) 'too low si'])
            continue
        end
    else
        disp([num2str(unit_id(k3)) 'Not passing the shuffle'])
        continue
    end

    hold off

end

lotSpeedCellWithCellType(save_path,animalID,day_num, session_num, sp_cell)





