function Load_place_cell(positions,hd,spike_train,unit_id,ch_id,continuous,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

arguments
    positions double
    hd double
    spike_train cell
    unit_id double
    ch_id double
    continuous struct

    options.Nbins (1,1)  {mustBeNumeric} = 100
    options.hdBinWidth (1,1)  {mustBeNumeric} = 10
    options.smooth (1,1)  {mustBeNumeric} = 10
    options.save_plot (1,1)  string = 'True'
    options.save_path (1,1)  string = 'Q:\sachuriga\Record_archive\Record_examples'
    options.animalID (1,1)  string = '65165'
    options.day_num (1,1)  string = '2023-07-01'
    options.session (1,1)  string = 'A'
end

path = [options.save_path '\' options.animalID '\' options.day_num '\' options.session '\' 'data'];
mk_path=fullfile(join(path));
export_path=strrep(mk_path,' ','');
mkdir(export_path)

nbin = options.Nbins;
cx_n=positions(:,2);
cy_n=positions(:,3);
time_speed = positions(:,1);
[~,~] = pos_filtered_with_speed(positions);
velocity = general.speed(positions);
unit_id=spike_train{5,1};
[~,~] = pos_filtered_with_speed(positions);

position_name=[export_path '\' 'positions' '.mat'];
position_path=fullfile(join(position_name));
position_export_path=strrep(position_path,' ','');
save(position_export_path,"positions");

velocity_name=[export_path '\' 'velocity' '.mat'];
velocity_path=fullfile(join(velocity_name));
velocity_export_path=strrep(velocity_path,' ','');
save(velocity_export_path,"velocity");

hd_name=[export_path '\' 'hd' '.mat'];
hd_path=fullfile(join(hd_name));
hd_export_path=strrep(hd_path,' ','');
save(hd_export_path,"hd");

unitid_name=[export_path '\' 'unitid' '.mat'];
unitid_path=fullfile(join(unitid_name));
unitid_export_path=strrep(unitid_path,' ','');
save(unitid_export_path,"unit_id");

for k3=1:length(unit_id)

    spike.activity{k3} = spike_train{3,k3};
    spike.spikehd{k3} = spike_train{4,k3};
    spike.spike_t{k3} = spike_train{1,k3};
    spike.amplitude{k3} = spike_train{6,k3};
    spike.activity_s{k3} = spike_train{1,k3};
    ch_i = ch_id(k3);
    pre_lfp=continuous.samples(ch_i+1,:);
    temp_lfp=double(pre_lfp)*0.1949999928474426;

    temp_time = continuous.timestamps;
    decimate_rate=150;
    clear lfp
    lfp(:,1) =  decimate(temp_time,decimate_rate);
    lfp(:,2) = decimate(temp_lfp,decimate_rate);
    spike.lfp{k3} = lfp;
end

spike_name=[export_path '\' 'spike' '.mat'];
spike_path=fullfile(join(spike_name));
spike_export_path=strrep(spike_path,' ','');
save(spike_export_path,"spike");

end