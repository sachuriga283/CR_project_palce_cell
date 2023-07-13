function [size_colum,size_raw] = plot_size(unit_id)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if round(sqrt(length(unit_id)))-sqrt(length(unit_id)) >=0
size_colum=round(sqrt(length(unit_id)));
size_raw=round(sqrt(length(unit_id)));
else
size_colum=round(sqrt(length(unit_id)))+1;
size_raw=round(sqrt(length(unit_id)));
end


end