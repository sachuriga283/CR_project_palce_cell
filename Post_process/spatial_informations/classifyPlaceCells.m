function [placeCell, si] = classifyPlaceCells(D, varargin)
%CLASSIFYPLACECELLS 

%% Parse Inputs
inp = inputParser();
inp.addParameter("min_rate", 0.1);
inp.addParameter("max_rate", 10);
inp.addParameter("thresh_si", 0.67); % this you can change
inp.addParameter("field_thresh", 2);
inp.addParameter("envSize", 150);
inp.addParameter("stable", []);
inp.parse(varargin{:});
P = inp.Results;

%% Setup
nunits = numel(D.units);

placeCell = zeros(1,nunits);
si = ones(1,nunits).*NaN;

%% Classify
for u = 1:nunits

    % mean rate (from spatial ratemap)
    meanrate(u) = D.units(u).meanRate;

    if ~isempty(D.units(u).tc)
         % spatial information
        si(u) = D.units(u).tc.pos.si;

        % *place cell classification*
        [~, fields] = analyses.placefield(D.units(u).tc.posFine, 'minBins', 18);
        num_fields(u) = length(fields);

        % bin size (in the ratemap)
        [rr,~] = size(D.units(u).tc.posFine.z);
        map_binsize = P.envSize/rr;

        if (num_fields(u) > 0) & (num_fields(u) < P.field_thresh)
            % criteria: fields
            for ff = 1:num_fields(u)
                fields_area(ff) = fields(ff).area.*map_binsize; % (cm)
                fields_peak(ff) = fields(ff).peak;
                fieldCriteria(ff) = fields_area(ff) > 200 & fields_peak(ff) > 1;
            end
            % criteria: does any field pass the criteria?
            fieldCriteriaPooled = any(fieldCriteria == 1);
            % criteria: mean rate
            rateCriteria = meanrate(u) > P.min_rate & meanrate(u) < P.max_rate;
            % criteria: spatial info
            infoCriteria = si(u) > P.thresh_si;
            % final decision (place cell or not)
            placeCell(u) = all([fieldCriteriaPooled rateCriteria infoCriteria]);
            clear fields_area fields_peak fieldCriteria
            else
                placeCell(u) = 0;
        end     
        
    else
        si(u) = nan;
    end
end

end

