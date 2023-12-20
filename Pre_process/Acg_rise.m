% This tutorial shows how to add custom ACGs to CellExplorer using the built-on functions.
% In this case we will limit the ACG to manipulation intervals
function [rise] = Acg_rise(path)

spikes = loadSpikes('basepath',path);

% Generating a new spike struct, to limit the spikes to a defined interval
spikes2 = spikes;
stimIntervals = [0 100;200 4000]; % your manipulation intervals

% Limiting the spike times to the stimulation intervals
spikes_indices = cellfun(@(X) ~ce_InIntervals(X,double(stimIntervals)),spikes2.times,'UniformOutput',false);
spikes2.times = cellfun(@(X,Y) X(Y),spikes2.times,spikes_indices,'UniformOutput',false);
spikes2.total = cell2mat(cellfun(@(X,Y) length(X),spikes2.times,'UniformOutput',false)); % Updating total spike count
spikes2.spindices = generateSpinDices(spikes2.times); % Adding spike indices

% Calculating the ACGs
acg_metrics = calc_ACG_metrics(spikes2,spikes2.sr,'showFigures',false);
ACG_matrix = fit_ACG(acg_metrics.acg_narrow);
rise = ACG_matrix.acg_tau_rise;

end


