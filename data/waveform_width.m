function [i1] = waveform_width(width)
%WAVEFORM_WIDTH Summary of this function goes here
%   Detailed explanation goes here
[m,i] = min(width);
[m1,i1] = max(width(i:end));

end

