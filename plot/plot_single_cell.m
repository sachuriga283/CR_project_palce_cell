function plot_single_cell(positions,hd,spike_train,unit_id,ch_id,continuous,options)
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

path = [options.save_path '\' options.animalID '\' options.day_num '\' options.session '\' 'single_unit'];
mk_path=fullfile(join(path));
export_path=strrep(mk_path,' ','');
mkdir(export_path)

nbin = options.Nbins;
cx_n=positions(:,2);
cy_n=positions(:,3);
time_speed = positions(:,1);
[~,ind] = pos_filtered_with_speed(positions);
velocity = general.speed(positions);
unit_id=spike_train{5,1};
[pos,ind] = pos_filtered_with_speed(positions)


for k3=1:length(unit_id)

    gaf=figure(k3+4);
    scrsz=get(0,'ScreenSize');
    set(gaf,'Position',scrsz);
    clear acitivity
    clear activity_s
    clear spikehd
    clear tc
    clear hist_spike

    activity = spike_train{3,k3};
    spikehd = spike_train{4,k3};
    spike_t = spike_train{1,k3};
    amplitude = spike_train{6,k3};

    % plot amplitude
    subplot(4,8,[17 18])
    scatter(spike_t,amplitude,3,'filled','k')
    ax4 = gca;
    ax4.Box = 'off';
    ax4.Color="none";

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
    map = analyses.map(positions,activity_s','smooth',options.smooth,'binWidth',nbin);
    plot.colorMap(map.z,map.time,'bar','off')
    hold on
    [fieldsMap, fields] = analyses.placefield(map,'minPeak',0.1);
    %     plot.fields(fields)

    ax2 = gca; % 获取当前图形的坐标轴对象
    ax2.YDir = 'reverse'; % 设置Y轴反向
    xticks([1 (length(map.x)-1)])
    yticks([1 (length(map.y)-1)])
    xticklabels({'0' '1'})
    yticklabels({'0' '1'})
    axis square
    colormap jet
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

    %plot spike imformation
    subplot(4,8,[1 2 9 10])
    plot(1)
    boader_score = analyses.borderScore(map.z, fieldsMap, fields);

    [grid_score, ~] = analyses.gridnessScore(rxx);
    hist_spike=zeros(1,length(time_speed));
    [hist_spike(2:end),~] =  histcounts(activity_s,time_speed);

    speed=velocity;
    firingRate=hist_spike/0.4;
    span=20;
    firingRate_s=firingRate(ind);

    speed_s=speed(ind);
    speed_st = speed_s;
    speed_scores = analyses.speedScore(speed_st, firingRate_s', span);

    ax3 = gca;
    ax3.Box = 'off';
    ax3.Color="none";
    ax3.XAxis.Color="none";
    ax3.YAxis.Color="none";
    axis square

    text(0,1.4,['Animal id : ' options.animalID])
    text(0,1.3,['Experiment day : ' options.day_num])
    text(0,1.2,['Boarder score : ' num2str(boader_score)])
    text(0,1.1,['Grid score : ' num2str(grid_score)])
    text(0,1,['Speed score : ' num2str(speed_scores(2))])

    % plot theta index
    subplot(4,8,[3 4])

    if length(activity_s) > 100
        interspikeI(activity_s,1)
        [counts,centers,thetaInd] = auto_crg(activity_s','numbins',101,'range',500);
        ax1 = gca;
        ax1.Box = 'off';
        ax1.Color="none";
        subplot(4,8,[11 12]);
        b = bar(centers,counts);
        b.EdgeColor='None';
        b.FaceColor='black';
        b.BarWidth=0.9;
        title(['theta index' ' ' num2str(thetaInd)])
    
        ax2 = gca;
        ax2.Box = 'off';
        ax2.Color="none";
        hold on
        smoothed = general.smoothGauss(counts,0.5);
        p = plot(centers,smoothed);
        p.Color='red';
        p.LineWidth=2;

    else
        disp("no spike")
        plot(1)

    end


    subplot(4,8,[19 20]);
    if length(activity_s) > 100
        [counts1,centers1,~] = auto_crg(activity_s','numbins',81,'range',40);
        b1 = bar(centers1,counts1);
        b1.EdgeColor='None';
        b1.FaceColor='black';
        b1.BarWidth=1;
    else
        disp('spikes smaller than 100')
        plot(1)
    end

    subplot(4,8,[27 28])
    %LFP spectral
    clear lfp
%     ch_i = ch_id(k3);
%     pre_lfp=continuous.samples(ch_i+1,:);
%     temp_lfp=double(pre_lfp)*0.1949999928474426;
% 
%     temp_time = continuous.timestamps;
%     decimate_rate=150;
%     clear lfp
%     lfp(:,1) =  decimate(temp_time,decimate_rate);
%     lfp(:,2) = decimate(temp_lfp,decimate_rate);
%     [~,~,~,~] = MTSpectrogram(lfp,'show','on','range',[1 120],'cutoffs',[0 8],'tapers',[3 5],'window',5);
%     colorbar

    clear image_name
    image_name=[export_path '\' 'unit_id_' num2str(unit_id(k3)) '.jpg'];
    image_path=fullfile(join(image_name));
    image_export_path=strrep(image_path,' ','');

    saveas(gca,image_export_path);
    %     h = heatmap(logTransformed)
    %     h.GridVisible='off'
    %     colormap jet

    %     bands = SpectrogramBands(spectrogram,f);
    %     csd = CSD(f_lfp);
    %     PlotCSD(csd,'lfp')
    %
    %     plot(t,bands.delta)
    %
    %     plot(lfp(:,1),double(continuous.samples(ch_i,:)));
    %     pspectrum(double(continuous.samples(ch_i,:)),lfp(:,1),'FrequencyLimits',[0 30]);
    %     % plot(hz,Power)
    %     % xlim([0 20])
end

end