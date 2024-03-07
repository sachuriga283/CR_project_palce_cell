cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze\CR_project_palce_cell\Main_plots

folderPath="S:\Sachuriga\nwb\CR_CA1";
[merge_spk,positions] = readrrwbs2mat(folderPath);

% unit_ids = nwb.units.id.data.load(); % array of unit ids represented within this
% Initialize trials & times Map containers indexed by unit_ids
path='S:\Sachuriga\nwb\CR_CA1/65588_2024-03-06_15-45-53_A_phy_k_manual.nwb'
[spk,position,possss] = Load_nwb(path); 
merge_spk=spk;
unitid = find(merge_spk.presence_ratio>0.9& ...
    merge_spk.isi_violations_ratio<0.2& ...
    merge_spk.amplitude_median>40);
% unitid = id{2};

ID=id{1};
unitid=(ID);
[B,I]=sort(merge_spk.test_stat_si(unitid));
[size_colum,size_raw] = plot_size(unitid);
size_colum=10;
size_raw=11;
all_unit=figure;
s=figure;

for kk=1:length(unitid)
    % pos=position;
    k1=I(kk);
    k=unitid(k1);
    pos=positions.(merge_spk.UIfile(k));
    v = general.speed(pos);
    ind=find(v>0.02);
    pos=pos(ind,:);
    disp(merge_spk.test_stat_si(k))
    [pos1,~] = pos_filtered_with_speed(pos);
    map = analyses.map(pos1, merge_spk.spike_times{k}, ...
        'smooth',5, ...
        'binWidth',1/100, ...
        'blanks','off', ...
        'minTime',0.0001);

    figure(s)
    p = plot.colorMap(map.z,map.time,'nanColor',0.00001);
    colormap('hot')
    data = p.CData;

    dataNormalized = (data - min(data(:))) / (max(data(:)) - min(data(:)));
    % Now, you can directly display the normalized data with 'imshow' using the 'jet' colormap
    
    figure(all_unit)
    subplottight(size_colum,size_raw,kk)
    imshow(dataNormalized, ...
        'Colormap', hot,  ...
        'border', 'tight');
    t = text(20,15,[num2str(merge_spk.firing_range(k)) ' Hz']);
    t(1).Color = 'white';
    t(1).FontWeight='bold';
    t(1).FontName='Times New Roman';
    ax = gca;
    axis square
    hold off
end

% plot unit location
unitlocation = figure;
for k=1:length(unitid)
    X(k)=merge_spk.x(unitid(k));
    Y(k)=merge_spk.y(unitid(k));
    Z(k)=merge_spk.z(unitid(k));
end
figure(unitlocation)
scatter3(X,Z,Y, ...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
ax = gca;
axis square
hold off
ylim([0 40])
xlabel('Horizontal distance (µm)')
zlabel('Depth (µm)')
ylabel('Orthognal distance to the probe plane (µm)')
save("SumData4test20240222_withSPI.mat","spikes","positions")

% select placel cells
UI_as = {'65409A','65410A'};
for k=1:length(UI_as)
    [id{k}] = filter_place_cell(spikes,UI_as{k});
end

% SPI comparson
for k=1:2
    subplot(1,2,1)
    unitid = id{k};
    if k==1
        color='k'
    else
        color='r';
    end

    spi = merge_spk.test_stat_si(unitid);
    histogram(spi,'BinWidth',0.3, ...
        'Normalization','probability', ...
        'DisplayStyle','stairs', ...
        'EdgeColor',color, ...
        'LineWidth',2)
    ax = gca;
    axis square
    ax.Color='none';
    ax.Box="off";
    xlabel('Spatial information content (bits/spike)')
    ylabel('Probability')

    hold on
    subplot(1,2,2)
    spi = merge_spk.test_stat_si(unitid);
    histogram(spi,'BinWidth',0.1, ...
        'Normalization','cdf', ...
        'DisplayStyle','stairs', ...
        'EdgeColor',color, ...
        'LineWidth',2)
    ax = gca;
    axis square 
    ax.Color='none';
    ax.Box="off";
    xlabel('Spatial information content (bits/spike)')
    ylabel('Cumulative distribution')
    hold on

    SPI{k} = merge_spk.test_stat_si(unitid);

end

subplot(1,3,3)
if length(SPI{1})>length(SPI{2})

    spit =    nan(length(SPI{1}),2);
else
    spit =    nan(length(SPI{2}),2);
end
spit(1:length(SPI{1}),1)=SPI{1};
spit(1:length(SPI{2}),2)=SPI{2};
boxplot(spit)
ax = gca;
axis square
xlabel('Spatial information content (bits/spike)')
ylabel('Cumulative distribution')
hold on


boxplot(SPI{1},SPI{2})

x=nan(104,2);
ttest2(SPI{1},SPI{2})
[~,~,ci,stats] = ttest2(SPI{1},SPI{2});
[h,p,ks2stat] = kstest2(SPI{1},SPI{2});