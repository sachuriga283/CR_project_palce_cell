
function [hd, positions] = load_positions(time_frame,sx,sy,nx,ny,rx,ry)
%This function is for creating an postions matrixz which is Nx3 arry, 
% N1 is time stemps, N2 is xcordinate of central head, 
% N3 is ycordinate of central head.

%  USAGE
%    [hd,positions] =load_position(time_frame,sx,sy,lx,ly,rx,ry)
%
%    positions          Animal's position data, Nx3. Position data should
%                       contain timestamps (1 column), X/Y coordinates of
%                       first LED (2 and 3 columns correspondingly), X/Y
%                       coordinates of the second LED (4 and 5 columns
%                       correspondingly).
%                       it is assumed that positions(:, 2:3) correspond to
%                       snout, and positions(:, 4:5) to the central 
%                       position of head.
%                       The resulting hd is the directon from back LED to
%                       the front LED.
%    hd                 Vector of head directions in degrees.


% Animals position
% for k2 = 1:1:length(lx)
%     cx(k2)=(lx(k2)+rx(k2))/2;
%     cy(k2)=(ly(k2)+ry(k2))/2;
% end



temp_positions(:,1) = time_frame;
temp_positions(:,2) = nx;
temp_positions(:,3) = ny;
temp_positions(:,2) = normalize(nx,"range");
temp_positions(:,3) = normalize(ny,"range");



pos_N(:,1) = time_frame;
pos_N(:,2) = sx;
pos_N(:,3) = sy;
pos_N(:,4) = nx;
pos_N(:,5) = ny;


positions = temp_positions;
hd = cal_HD(pos_N);

end

