cd Q:\sachuriga\Sachuriga_Matlab\Sorting_analyze\CR_project_palce_cell\Main_plots

folderPath="S:\Sachuriga\nwb";
[merge_spk,positions] = readrrwbs2mat(folderPath);

% unit_ids = nwb.units.id.data.load(); % array of unit ids represented within this
% Initialize trials & times Map containers indexed by unit_ids

unitid = find(merge_spk.presence_ratio>0.9& ...
    merge_spk.isi_violations_ratio<0.2& ...
    merge_spk.amplitude_median>40);
unitid = id{2};
merge_spk=spikes;
[size_colum,size_raw] = plot_size(unitid);
all_unit=figure;
s=figure;
for k=1:length(unitid)
    pos=positions.(merge_spk.UIfile(unitid(k)));
    v = general.speed(pos);
    ind=find(v>0.05);
    pos=pos(ind,:);

    [pos1,~] = pos_filtered_with_speed(pos);
    map = analyses.map(pos1, merge_spk.spike_times{unitid(k)},'smooth',1,'binWidth',1/25,'blanks','off','minTime',0.1);
    figure(s)
    p = plot.colorMap(map.z,map.time,'bar','on')
    data = p.CData;

    dataNormalized = (data - min(data(:))) / (max(data(:)) - min(data(:)));
    % Now, you can directly display the normalized data with 'imshow' using the 'jet' colormap

    figure(all_unit)
    subplottight(10,11,k)
    imshow(dataNormalized, 'Colormap', jet,  'border', 'tight');
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
scatter3(X,Z,Y,'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
ax = gca;
axis square
hold off
ylim([0 40])
xlabel('Horizontal distance (µm)')
zlabel('Depth (µm)')
ylabel('Orthognal distance to the probe plane (µm)')

x1=[]
x2=[]
y1=[]
y2=[]
z1=[]
z2=[]
py2int = figure
for k=1:length(unitid)
    X=merge_spk.half_width(unitid(k))*10000;
    Y=merge_spk.peak_to_valley(unitid(k))*10000;
    Z=merge_spk.firing_range(unitid(k));
    if merge_spk.peak_to_valley(unitid(k))>0.000475
        x1 = [x1 X];
        y1 = [y1 Y];
        z1 = [z1 Z];
    else
        x2 = [x2 X];
        y2 = [y2 Y];
        z2 = [z2 Z];
    end
end
figure(py2int)
scatter3(x1,y1,z1,'MarkerEdgeColor','w',...
    'MarkerFaceColor','b')
hold on
scatter3(x2,y2,z2,'MarkerEdgeColor','w',...
    'MarkerFaceColor','magenta')
h1 = gca;
axis square
zlim([0 25])
ylim([2 inf])
set(h1, 'Ydir', 'reverse')

save("SumData4test20240222_withSPI.mat","spikes","positions")

% select placel cells
UI_as = {'65409A','65410A'}
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
        color='r'
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

x=nan(104,2)
ttest2(SPI{1},SPI{2})
[h,p,ci,stats] = ttest2(SPI{1},SPI{2})
[h,p,ks2stat] = kstest2(SPI{1},SPI{2})