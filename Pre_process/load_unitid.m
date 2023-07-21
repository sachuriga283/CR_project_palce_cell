
function [unit_id] = load_unitid(animalID,day_num,folder_recording)

%UNTITLED2 Summary of this function goes here
unit_id_temp = dir([folder_recording '/' animalID '_' '*' day_num '*/cluster_group.tsv']);

temp = readtable([unit_id_temp.folder '\' unit_id_temp.name],"FileType","delimitedtext");
temp1=find(string(temp.group)=="good");
temp2=temp.cluster_id;
unit_id=double(temp2(temp1));

end