function plot_single_cell(positions,hd,spike_train,unit_id,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

arguments
    positions double
    hd double
    spike_train cell
    options.Nbins (1,1)  {mustBeNumeric} = 100
    options.hdBinWidth (1,1)  {mustBeNumeric} = 10
    options.smooth (1,1)  {mustBeNumeric} = 10
    options.save_plot (1,1)  string = 'True'
    options.save_path (1,1)  string = 'Q:\sachuriga\Record_archive\Record_examples'
    options.animalID (1,1)  string = '65165'
    options.day_num (1,1)  string = '2023-07-01'
end

nbin = options.binWidth;
time_frame=positions(:,1);
cx=positions(:,2);
cy=positions(:,3);
cx_n=normalize(cx,"range");
cy_n=normalize(cy,"range");

velocity = general.speed(positions);
time_speed = positions(:,1);

unit_id=spike_train{5,1};

for k3=1:length(unit_id)

    f=figure(k3);
    clear acitivity
    clear activity_s
    clear spikehd
    clear tc
    clear hist_spike

    activity = spike_train{3,k3};
    spikehd = spike_train{4,k3};
    spike_t = spike_train{1,k3};

    % plot

    %plot raw activity
    subplot(4,8,[5 6 13 14])
    plot(cx_n,cy_n,'-','Color',[119,136,153]/255, ...
        'LineWidth',0.005)
    hold on
    plot(activity.x,activity.y,'r.', ...
        MarkerSize=5)
    ax1 = gca; % 获取当前图形的坐标轴对象
    ax1.YDir = 'reverse'; % 设置Y轴反向
    ax1.Color="none";
    ax1.XAxis.Color="none";
    ax1.YAxis.Color="none";
    xticks([0 1])
    yticks([0 1])
    hold on
    axis square
    hold off

    % plot place cell
    subplot(4,8,[7 8 15 16])
    activity_s=spike_train{1,k3};

    map = analyses.map([time_frame cx_n cy_n],activity_s','smooth',options.smooth,'binWidth',nbin);
    plot.colorMap(map.z,map.time,'bar','off')
    hold on
    [fieldsMap, fields] = analyses.placefield(map,'minPeak',0.1);
    plot.fields(fields)


    ax2 = gca; % 获取当前图形的坐标轴对象
    ax2.YDir = 'reverse'; % 设置Y轴反向
    xticks([1 (length(map.x)-1)])
    yticks([1 (length(map.y)-1)])
    xticklabels({'0' '1'})
    yticklabels({'0' '1'})
    axis square
    c1 = colorbar;
    c1.Location = 'south';
    c1.Position = [0.73675595238095,0.518930826487577,0.072098214285716,0.024163669877945];
    c1.AxisLocation ='out';

    % plot correlegram
    subplot(4,8,[21 22 29 30])
    rxx = analyses.autocorrelation(map.z);
    plot.colorMap(rxx,'bar','off');
    axis square

    xticks([1 (length(rxx)-1)])
    yticks([1 (length(rxx)-1)])
    xticklabels({' ' ' '})
    yticklabels({' ' ' '})
    c2 = colorbar;
    c2.Location = 'south';
    c2.Position = [0.531026785714283,0.084870598034825,0.072098214285716,0.024163669877945];
    c2.AxisLocation ='out';

    % hd plot
    subplot(4,8,[23 24 31 32])
    tc = analyses.turningCurve(spikehd, hd, 1/25,'binWidth',options.hdBinWidth);
    temp_s = tc(:,2);
    plot.circularTurning(temp_s)
    axis square
    ax = gca; % 获取当前图形的坐标轴对象
    ax.YDir = 'reverse'; % 设置Y轴反向
    ax.Color="none";

    %plot si imformation
    subplot(4,8,[1 2 9 10])
    plot(1)
    boader_score = analyses.borderScore(map.z, fieldsMap, fields);
    [grid_score, ~] = analyses.gridnessScore(rxx);

    [hist_spike,~] =  histcounts(activity_s,time_speed);
    speed=velocity(2:end)';
    firingRate=hist_spike/0.4;
    span=20;
    speed_scores = analyses.speedScore(speed', firingRate', span);

    ax3 = gca;
    ax3.Box = 'off'
    ax3.Color="none";
    ax3.XAxis.Color="none";
    ax3.YAxis.Color="none";
    axis square

    text(0,1.4,['Animal id : ' options.animalID])
    text(0,1.3,['Experiment day : ' options.day_num])
    text(0,1.2,['Boarder score : ' num2str(boader_score)])
    text(0,1.1,['Grid score : ' num2str(grid_score)])
    text(0,1,['Speed score : ' num2str(speed_scores(2))])

    subplot(4,8,[3 4])
    calc.ISI(activity_s,1)
    [counts,centers,thetaInd] = calc.thetaIndex(activity_s');

    subplot(4,8,[11 12])
    bar(centers,counts)
    title(['theta index' ' ' num2str(thetaInd)])


end

end