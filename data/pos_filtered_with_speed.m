function [pos,ind] = pos_filtered_with_speed(position)
%POS_FILTERED_WITH_SPEED Summary of this function goes here
%   Detailed explanation goes here

v = general.speed(position);
ind=find(v>0.05);
pos=position(ind,:);

end

