
function [ch_id] = load_best_ch(animalID,day_num,folder_recording,session_num)

%UNTITLED2 Summary of this function goes here
unit_ch = dir([folder_recording '/' animalID '_' '*' day_num '*' session_num '*/cluster_info.tsv']);
temp = readtable([unit_ch.folder '\' unit_ch.name],"FileType","delimitedtext");
temp1=find(string(temp.group)=="good");
temp2=temp.ch;
ch_id=double(temp2(temp1));

end