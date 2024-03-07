path = 'S:\Sachuriga\nwb/65409_2023-12-02_15-07-29_A_phy_k_manual.nwb'
[spikes,posi] = Load_nwb(path)


merge_spk=spikes;
unitid = find(merge_spk.presence_ratio>0.9& ...
    merge_spk.isi_violations_ratio<0.2& ...
    merge_spk.amplitude_median>40);
% unitid = id{2};
[size_colum,size_raw] = plot_size(unitid);
all_unit=figure;
s=figure;
for k=1:length(unitid)
    pos=posi;
%     v = general.speed(pos);
%     ind=find(v>0.05);
%     pos=pos(ind,:);

    [pos1,~] = pos_filtered_with_speed(pos);
    map = analyses.map(pos1, merge_spk.spike_times{k}, ...
        'smooth',1, ...
        'binWidth',1/25, ...
        'blanks','off', ...
        'minTime',0.1);

    figure(s)
    p = plot.colorMap(map.z,map.time,'bar','on');
    data = p.CData;

    dataNormalized = (data - min(data(:))) / (max(data(:)) - min(data(:)));
    % Now, you can directly display the normalized data with 'imshow' using the 'jet' colormap

    figure(all_unit)
    subplottight(size_colum,size_raw,k)
    imshow(dataNormalized, ...
        'Colormap', jet,  ...
        'border', 'tight');

    ax = gca;
    axis square
    hold off
end