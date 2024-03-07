
function [unit_id] = load_unitid(animalID,day_num,folder_recording,session_num)

%UNTITLED2 Summary of this function goes here
path = [folder_recording '/' animalID '_' day_num '*' '_' session_num '_phy_k_manual']
unit_id_temp = dir(strrep(fullfile(join ...
    ([path '/cluster_info.tsv'])) ...
    ,' ',''));

temp = readtable([unit_id_temp(1).folder '/' unit_id_temp(1).name],"FileType","delimitedtext");
temp1=string(temp.group)=="good";
temp2=temp.cluster_id;
% temp2=temp.Var1;
unit_id=double(temp2(temp1));

end