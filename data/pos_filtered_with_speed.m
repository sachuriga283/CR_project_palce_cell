function [pos,ind] = pos_filtered_with_speed(positions)
%POS_FILTERED_WITH_SPEED Summary of this function goes here
%   Detailed explanation goes here

v = general.speed(positions);
ind=find(v>0.05);
pos=positions(ind,:);

end

