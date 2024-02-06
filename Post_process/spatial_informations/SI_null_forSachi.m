%% Set parameters
disp('Setting parameters...');
minshift = 20; maxshift = 60; % seconds
n_iters = 1000; % size of null
n_units = 75; % number of units

[pos,~] = pos_filtered_with_speed(positions);
%% Data Info
t = pos(:,1) % your timestamps;
tpf = mode(diff(t)); % time per frame (0.01 seconds) t(2)-t(1)
sessionLength = t(end); % seconds
maxshift = floor(sessionLength) - maxshift;

%% Iterate over units (shifting)
% grab position data for the session youre looking at
n_units = length(spike.spike_t)
disp('(A) Calculating null spike trains...');
for n = 1:n_iters
    tic;
    disp(['Iteration # ', num2str(n)]);

    for u = 1:n_units
        % pull out the spikeCounts for unit 'u' (0,1,2)
        %unit = D.units(u);
        %spikeCounts = unit.spikeCounts;
        spikeTimes = spike.spike_t{u};% grab original units spiketimes
        [spkPos, spkInd, rejected] = data.getSpikePositions(spikeTimes,pos);
        spikeTimes=pos(spkInd,1);
        firingRate = analyses.instantRate(spikeTimes, pos);
        spikecounts =  int64(firingRate);

        % calculate spatial ratemap
        map = analyses.map(pos, firingRate,'smooth',1,'binWidth',1/15); % set additional parameters; we use 15x15 bins; smoothing = 1 or 2
        
        % calculate spatial info and other stats of the map
        [information, sparsity, selectivity] = analyses.mapStatsPDF(map);
        
        % grab information content
        test_stat_si(u) = information.content;

        shift_val = floor(minshift/tpf + (maxshift/tpf-minshift/tpf).*rand(1)); % Calculate shift in bins
        spikeCounts_shift = circshift(spikecounts, shift_val); % circularly shift spikes, wrap to start
        [spikeTimes_shift, spikeInds_shift] = convert_train_to_times(full(spikeCounts_shift), t);

        units_null(u).spikeCounts = spikeCounts_shift;
        units_null(u).spikeTimes= spikeTimes_shift';
        units_null(u).spikeInds= spikeInds_shift';
        
    end

    U{n} = units_null; clear units_null;
    toc;
end

%% Calculate Null Scores
disp('(B) Calculate null tuning curves...')
for n = 1:n_iters
    tic
%     Dnull = D;
%     Dnull.units = D.units;

    Dnull = struct;
    
    disp(['Iteration # ', num2str(n)]);

    %for u = 1:n_units
        Dnull.units(u).spikeCounts = U{n}(u).spikeCounts;
        Dnull.units(u).spikeTimes = U{n}(u).spikeTimes;
        Dnull.units(u).spikeInds = U{n}(u).spikeInds;
        fr=Dnull.units(u).spikeTimes;
        % calculate spatial ratemap (null)
        map = analyses.map(pos, fr','smooth',1,'binWidth',1/15); % set additional parameters; we use 15x15 bins; smoothing = 1 or 2
        
        % calculate spatial info and other stats of the map
        [information, sparsity, selectivity] = analyses.mapStatsPDF(map);
        
        % grab information content
        null_stat_si(n,u) = information.content;
        
  %  end
end

%% Test if the SI exceeds the null distribution
for u = 1:n_units
    percentile = 99;
    null_dist = null_stat_si(:,u);
    test_stat = test_stat_si(u);
    reject_h0(u) = h0_test_nonparametric(test_stat, null_dist', percentile); 
end


%% Functions
function reject_h0 = h0_test_nonparametric(test_stat, null_dist, percentile)
% H0_TEST_NONPARAMETRIC Performs a nonparametric hypothesis test to determine whether to reject the null hypothesis.
%
% This function tests if a given test statistic significantly exceeds a specified percentile 
% of a null distribution. It is used for hypothesis testing in cases where standard parametric 
% tests are not suitable. The function sorts the combined array of the test statistic and the 
% null distribution, then determines if the test statistic is beyond the specified percentile 
% threshold of the null distribution.
%
% Usage:
%   reject_h0 = h0_test(test_stat, null_dist, percentile, simIter)
%
% Inputs:
%   test_stat - The test statistic to be compared against the null distribution.
%   null_dist - An array representing the null distribution against which the test statistic is compared.
%   percentile - The percentile (expressed as a value between 0 and 1) against which the test 
%                statistic is compared (e.g., 0.95 for the 95th percentile).
%
% Output:
%   reject_h0 - A logical value (true or false) indicating whether to reject the null hypothesis.
%               True indicates rejection of the null hypothesis. In case of an error (e.g., 
%               test_stat not found in the sorted array), NaN is returned.
%
% Example:
%   testStat = 2.5;
%   nullDistribution = normrnd(0, 1, [1000, 1]);
%   percentile = 0.95;
%   simIter = 1;
%   shouldReject = h0_test(testStat, nullDistribution, percentile, simIter);

% Sort the combined array of test statistic and null distribution in ascending order
sorted = sort([test_stat, null_dist], 'ascend');

% Get the number of elements in the null distribution
size_null = numel(null_dist);

% Check if the test statistic exceeds the specified percentile of the null distribution

% Determine if the position of the test statistic is greater than the Nth percentile
try
    reject_h0 = find(sorted == test_stat, 1) > ceil(size_null * percentile);
    if isempty(reject_h0)
        reject_h0 = NaN;
    end
catch
    % In case of an error (e.g., test_stat not found in sorted array), return NaN
    reject_h0 = NaN;
end

end
    

function [spikeTimes, spikeInds] = convert_train_to_times(spike_train, t)
    % CONVERT_TRAIN_TO_TIMES Converts a spike train back to spike times.
    % This function takes a spike train represented as a binary array and a 
    % time vector, and converts the spike train back into the actual spike times.
    %
    % The function iterates over the spike train array. For each bin that 
    % indicates a spike (value of 1), it records the corresponding time from 
    % the time vector 't'. The result is a list of spike times indicating 
    % when each spike occurred.
    %
    % Parameters
    % ----------
    % spike_train : array
    %     Binary array representing the spike train (1 for a spike, 0 otherwise).
    %     Each element corresponds to a time bin in 't'.
    %
    % t : array
    %     Time vector representing each timestamp in the recording, in seconds.
    %
    % Returns
    % -------
    % spikeTimes : array
    %     Array of times at which spikes occurred, in seconds. Each spike time
    %     is repeated according to the number of spikes in that time bin.
    
    % Find indices where spike_train is non-zero (i.e., where there are spikes)
    nonZeroInds = find(spike_train > 0);
    
    % Create an array of the corresponding times, repeated according to spike count
    spikeTimes = repelem(t(nonZeroInds), spike_train(nonZeroInds));
    
    % Create an array of indices, repeated according to spike count
    spikeInds = repelem(nonZeroInds, spike_train(nonZeroInds));
end

