function [hdCell,hd_mvl] = classifyHDCells(D,varargin)
%CLASSIFYHDCELLS

%% Parse Inputs
inp = inputParser();
inp.addParameter("min_rate", 0.1);
inp.addParameter("max_rate", 10);
inp.addParameter("thresh_mvl", 0.60);
inp.parse(varargin{:});
P = inp.Results;

%% Setup
nunits = numel(D.units);


%% Classify
hdCell = zeros(1,nunits);
hd_mvl = ones(1,nunits).*NaN;

for u = 1:nunits
    if ~isempty(D.units(u).gridStats)
        % mvl of head direction tuning curve
        hd_mvl(u) = D.units(u).tc.hd.mvl;
        
        % mean firing rate
        meanRate = D.units(u).meanRate;

        % does the cell pass thresholds?
        if hd_mvl(u) > P.thresh_mvl & meanRate > P.min_rate & meanRate < P.max_rate
            hdCell(u) = 1;
        end
    end
end
