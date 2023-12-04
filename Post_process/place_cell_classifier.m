function [result_place, result_boarder, speedScores, mean_rate, max_rate] = place_cell_classifier(sum_data,activity_s,pos,positions)

nbins = 1/25;
map = analyses.map(pos,activity_s','smooth',1,'binWidth',nbins,'blanks','off','minTime',0.5);
[fieldsMap, fields] = analyses.placefield(map,'minPeak',0.3,'minBins',9);
result_boarder = analyses.borderScore(map.z, fieldsMap, fields);

if max([fields.area]) > 18
    if max([fields.meanRate]) < 8
        result_place = "True";
    else
        result_place = "False";
    end
elseif result_boarder == -1
    result_place = "False";
else
    result_place = "False";
end

%%classiftying the speed cells
itan_spk = analyses.instantRate(activity_s', positions);
speedScores = analyses.speedScore(sum_data.velocity, itan_spk, 20);
mean_rate = analyses.meanRate(activity_s, positions);
max_rate = map.peakRate;

end
