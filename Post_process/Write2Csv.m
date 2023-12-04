a= readNPY('S:\Open_ephys\CR_ca1\65283_2023-10-13_12-18-33_A_phy_k\template_ind.npy')

for k=1:11
    figure
    plot((squeeze(a(1,:,k))))
end

function [continuous] = load_LFP(animalID,day_num,folder_recording,session_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

lfp_temp = dir(strrep(fullfile(join([folder_recording '/' animalID '_' '*' day_num '*' session_num])),' ',''));
directory = [lfp_temp(1).folder '\' lfp_temp(1).name];
session = Session(directory);
node = session.recordNodes{1};
recording = node.recordings{1,1};
streamNames = recording.continuous.keys();
streamName = streamNames{1};
disp(streamName)
continuous = recording.continuous(streamName);

end
