
function  plot_screening_SingleSession(positions,hd,spike_train,options)
% Input position should be a N x 3 arry which contains the time stemp, x
% and Y cordination, hd is the corresponding head direction.spike_train
% which contains the 4 x N (N = number of neuron) of data. Columen1 is the
% raw spikes, Column2 is the spikes sitting to nearest TTL signal postion.
% Colume three is the cordination of each spike. Colume4 is the spikes in
% head directions.

% This will plotting a screening plot for place cells and head direction.
arguments
    positions double
    hd double
    spike_train cell
    options.PlotSize (1,:)  {mustBeNumeric} = [4 4]
    options.binWidth (1,1)  {mustBeNumeric} = 1/28
    options.hdBinWidth (1,1)  {mustBeNumeric} = 10
    options.smooth (1,1)  {mustBeNumeric} = 0
    options.save_plot (1,1)  string = 'True'
    options.save_path (1,1)  string = 'Q:\sachuriga\Record_archive\Record_examples'
    options.animalID (1,1)  string = '65165'
    options.day_num (1,1)  string = '2023-07-01'
end

s1=options.PlotSize(1);
s2=options.PlotSize(2);
nbin = options.binWidth;
[~,n] = size(spike_train);

f_raw=figure;
f_pc=figure;
f_hd=figure;
f_hdp=figure;

time_frame=positions(:,1);
cx=positions(:,2);
cy=positions(:,3);
cx_n=normalize(cx,"range");
cy_n=normalize(cy,"range");
unit_id=spike_train{5,1};


for k3=1:1:n

    clear acitivity
    clear activity_s
    clear spikehd
    clear tc

    activity = spike_train{3,k3};
    spikehd = spike_train{4,k3};
    spike_t = spike_train{1,k3};

    figure(f_raw)
    subplot(s1,s2,k3)
    plot(cx_n,cy_n,'Color',[119,136,153]/255, ...
        'LineWidth',0.01)
    hold on
    plot(activity.x,activity.y,'r.', ...
        MarkerSize=1)
    title(['unit' ' ' num2str(unit_id(k3))])
    ax = gca; % 获取当前图形的坐标轴对象
    ax.YDir = 'reverse'; % 设置Y轴反向
    xticks([0 1])
    yticks([0 1])
    hold on
    axis square
    if k3==1
        ylabel("spikes/s");
        hold off
        continue
    else
        hold off
        continue
    end
end

for k3=1:1:n

    clear spikehd
    clear temp_s
    clear map 
    clear fieldsMap
    clear fields
    clear score

    spikehd = spike_train{4,k3};
    figure(f_pc)
    subplot(s1,s2,k3)
    activity_s=spike_train{1,k3};

    %     map = FiringMap([time_frame cx_n cy_n],[activity_s'],'smooth',options.smooth,'nBins',[nbin nbin]);
    map = analyses.map([time_frame cx_n cy_n],activity_s','smooth',options.smooth,'binWidth',nbin);
    plot.colorMap(map.z,map.time,'bar','on')

    [fieldsMap, fields] = analyses.placefield(map,'minPeak',0.1);
    score = analyses.borderScore(map.z, fieldsMap, fields);

    hold on
    ax = gca; % 获取当前图形的坐标轴对象
    ax.YDir = 'reverse'; % 设置Y轴反向
    title(['Hz' ' ' num2str(max(map.z,[],'all'))],['boarder score' ':' num2str(score)],'FontSize',5)
    xticks([1 (length(map.x)-1)])
    yticks([1 (length(map.y)-1)])
    xticklabels({'0' '1'})
    yticklabels({'0' '1'})
    axis square
    hold off

    tc = analyses.turningCurve(spikehd, hd, 1/25,'binWidth',options.hdBinWidth);
    temp_s = tc(:,2);
    figure(f_hdp)
    subplot(s1,s2,k3)
    plot.circularTurning(temp_s)
    axis square
    ax = gca; % 获取当前图形的坐标轴对象
    ax.YDir = 'reverse'; % 设置Y轴反向

    title(['unit' ' ' num2str(unit_id(k3))])
    figure(f_hd)
    subplot(s1,s2,k3)
    plot((tc(:,1)),(tc(:,2)))
    title(['Hz' ' ' num2str(max(temp_s,[],'all'))])
    axis square
    xlim([0 360])
    ylim([0 inf])
    hold on

    if k3==1
        ylabel("spikes/s");
        hold off
        continue
    elseif k3==length(nbin)
        figure(f_hd)
        subplot(s1,s2,k3)
        xlabel("degree");
        hold off
        continue
    else
        hold off
        continue
    end
    hold off
end

sub=[options.animalID '_' options.day_num];

if options.save_plot=='True'
    cd(options.save_path)
    cd(options.animalID)
    mkdir(options.day_num)
    cd(options.day_num)
    figure(f_raw)
    f1=gcf;
    %     exportgraphics(f1,'f_raw.png','Resolution',300)
    gaf=figure(f1);
    scrsz=get(0,'ScreenSize');
    set(gaf,'Position',scrsz);
    saveas(gca,'f_raw.jpg');

    figure(f_pc)
    f2=gcf;
    gaf=figure(f2);
    set(gaf,'Position',scrsz);
    saveas(gca,'f_pc.jpg');

    figure(f_hd)
    f3=gcf;
    gaf=figure(f3);
    set(gaf,'Position',scrsz);
    saveas(gca,'f_hd.jpg');

    figure(f_hdp)
    f4=gcf;
    gaf=figure(f4);
    set(gaf,'Position',scrsz);
    saveas(gca,'f_hdp.jpg');

else
    disp('Not saved')
end


end
