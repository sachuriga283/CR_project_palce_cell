% cd('S:\Ephys_Recording\CR_CA1\65283_2023-10-09_11-06-26_A_phy_k')
% ch_map = readNPY('channel_map.npy');
% ch_group = readNPY('channel_groups.npy');
% ch_postion = readNPY('channel_positions.npy');
% ch_map=ch_map+1;
% ch_group=ch_group+1;

% for i=1:6
%     temp= ch_map(find(ch_group==i));
%     [B I] = sort(ch_postion(ch_group==i,2));
%     electros{i} =  temp(I);
% end
function data4unittrack = chMerging(data4unittrack,electros)
[~,spikes_info] = get_clusterinfo_Fprobe({'S:\Ephys_Recording\CR_CA1\65410_2023-12-04_13-38-02_A_phy_k'})

% save("Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze\CR_project_palce_cell\test\probes_Cor.mat","ch_map","ch_group","ch_postion","electros")
% load("Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze\CR_project_palce_cell\test\probes_Cor.mat")
% scatter(ch_postion(:,1),ch_postion(:,2))
% hold on
% 
% for i = 1:length(ch_map)
%     text(ch_postion(i,1),ch_postion(i,2),['ch' num2str(ch_map(i))],'Color','red')
%     text(ch_postion(i,1),ch_postion(i,2)-5,['shank' num2str(ch_group(i))],'Color','blue')
% end

for o=1:length(data4unittrack.ch)

    ch = data4unittrack.ch{o};
    shank = data4unittrack.shank{o};
    unit_id = data4unittrack.unit_id{o};
    spkt = data4unittrack.spikeTimes{o};
    wfm =  data4unittrack.wf_max{o};
    shanks = zeros(1,length(ch));

    uid = [];
    spt = {};
    uch = [];
    wf_new = {};

    for p=1:length(ch)
        temp = electros{shank(p)};
        if ch(p)==temp(1) || ch(p)==temp(end)

            if ch(p)==temp(1)
                temp_ch = [find(ch==temp(1)) find(ch==temp(2))];
            else
                temp_ch = [find(ch==temp(end)) find(ch==temp(end-1))];
            end
            spt = [spt {spkt{temp_ch}}];
            wf_new = [wf_new {wfm{temp_ch}}];
            uch=[uch repelem(ch(p),length(temp_ch))];
            uid=[uid unit_id(temp_ch)];
        else
            I=find(temp==ch(p));
            temp_ch = [find(ch==temp(I-1)) find(ch==temp(I)) find(ch==temp(I+1))];
            spt = [spt {spkt{temp_ch}}];
            wf_new = [wf_new {wfm{temp_ch}}];
            uch=[uch repelem(ch(p),length(temp_ch))];
            uid=[uid unit_id(temp_ch)];
        end
    end

    data4unittrack.grouped_spkt{o,1} = spt;
    data4unittrack.grouped_wf_new{o,1} = wf_new;
    data4unittrack.grouped_uch{o,1} = uch;
    data4unittrack.grouped_uid{o,1} = uid;
end
end
