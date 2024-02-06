

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
