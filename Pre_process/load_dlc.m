function  [dlc_m] = load_dlc(animalID,day_num,session_num,video_folder)
%LOAD_DLC Summary of this function goes here
%   Detailed explanation goes here
v_name = dir(strrep(fullfile(join([video_folder '/' animalID '*' session_num '*' day_num '*_filtered.csv'])),' ',''));
% v_name = dir(strrep(fullfile(join([animalID '*' day_num '_' session_num '*_filtered.csv'])),' ',''));
dlc_m = readmatrix([v_name(1).folder '/' v_name(1).name]);
end

