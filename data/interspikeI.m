
% Compute number of spikes in interspike interval.
%
%   USAGE
%       ref = interspikeI(spikes, <PLOT>)
%       spikes      vector of spike times
%       PLOT        optional. 1 will plot the results, 0 will not (default)
%
%   OUTPUT
%       ref         percentage of refractory spikes (2 msec)
%
%   SEE ALSO
%       calc.crossCorr
%
% Written by BRK 2017 modified by Sachuriga

function ref = interspikeI(spikes,PLOT,varargin)

%% check if we're plotting
if ~exist('PLOT','var')
    PLOT = 0;
end

%% parameters
epsilon = 1e-100;
nBins = 500;
maxLogISI = 3;
minLogISI = -3;
binsUsed = nan; H = nan;
ISI = diff(spikes) + epsilon;

%% compute
binsUsed = logspace(minLogISI,maxLogISI,nBins);
H = histcounts(ISI+eps,binsUsed);
ref = sum(ISI<0.002) / numel(ISI);

%% plot
if PLOT
    ar = area(binsUsed(1:end-1),H,varargin{:});
    ar.LineStyle = 'None';
    ar.FaceColor = 'Black';
    hold on
    plot([0.001 0.001],get(gca,'yLim'),'k-', ...
        [0.002 0.002],get(gca,'yLim'),'r-')
    xlabel('ISI (sec)');
    set(gca,'XScale','log','XLim',[10^minLogISI 10^maxLogISI]);

    %     t = text(max(get(gca,'xLim')),max(get(gca,'yLim')), ...
    %         sprintf('Ref: %1.1f%%',(sum(ISI<0.002)/numel(spikes))*100), ...
    %         'VerticalAlignment','top','HorizontalAlignment','right','fontweight','bold','edgecolor','none');
    %     if (sum(ISI<0.002)/numel(spikes))*100 > 2
    %         set(t,'color','red')
    %     end
    set(gca,'YTick',max(H));
end



