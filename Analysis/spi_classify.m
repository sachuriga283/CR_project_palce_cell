function [spikes] = spi_classify(spikes,positions)

%% Set parameters
disp('Setting parameters...');
binWidth = 1/25;
smoothBin = 1;

minshift = 20; maxshift = 60; % seconds
n_iters = 1000; % size of null

%% Iterate over units (shifting)
% grab position data for the session youre looking at
n_units=height(spikes);
% n_units=3;
disp('(A) Calculating null spike trains...');
for u = 1:n_units
    % pull out the spikeCounts for unit 'u' (0,1,2)
    %unit = D.units(u);
    %spikeCounts = unit.spikeCounts;
    spikeTimes = spikes.spike_times{u};% grab original units spiketimes

    [pos,~] = pos_filtered_with_speed(positions.(spikes.UIfile(u)));
    %% Data Info
    t = pos(:,1); % your timestamps;
    tpf = mode(diff(t)); % time per frame (0.01 seconds) t(2)-t(1)
    sessionLength = t(end); % seconds
    maxshift = floor(sessionLength) - maxshift;

    [spkPos, spkInd, rejected] = data.getSpikePositions(spikeTimes,pos);
    spikeT=pos(spkInd,1);
    firingRate = analyses.instantRate(spikeT, pos);
    spikecounts =  int64(firingRate);

    % calculate spatial ratemap
    map = analyses.map(pos, [pos(:,1), firingRate],'smooth',smoothBin, ...
        'binWidth',binWidth, ...
        'minTime',0.1); % set additional parameters; we use 15x15 bins; smoothing = 1 or 2
    % calculate spatial info and other stats of the map
    [information, sparsity, selectivity] = analyses.mapStatsPDF(map);
    % grab information content
    spikes.test_stat_si(u) = information.content;

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
        % U{n} = units_null;
        % clear units_null;
        toc;
    end
    spikes.null_stat_si{u} = null_stat_si(:,u);
end

%% Test if the SI exceeds the null distribution
for u = 1:n_units
    percentile = 0.95;
    null_dist = null_stat_si(:,u);
%     null_dist = spikes.null_stat_si{u}
    test_stat = spikes.test_stat_si(u);
    spikes.reject_h0(u) = h0_test_nonparametric(test_stat, null_dist, percentile);
end
end
