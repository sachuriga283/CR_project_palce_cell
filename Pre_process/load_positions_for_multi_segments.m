

function [headd,position] = load_positions_for_multi_segments(positions,hd,k)

position(:,1) = positions.time{k};
position(:,2) = positions.x{k};
position(:,3) = positions.y{k};
headd = hd{k};

end