function [continuous] = load_LFP(animalID,day_num,folder_recording,session_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

lfp_temp = dir([folder_recording '/' animalID '_' '*' day_num '*' session_num])
directory = [lfp_temp.folder '\' lfp_temp.name];
session = Session(directory);
node = session.recordNodes{1};
recording = node.recordings{1,1};
streamNames = recording.continuous.keys();
streamName = streamNames{1};
disp(streamName)
continuous = recording.continuous(streamName);

end
