
function  plot_screening_MultiSession(positions,hd,spike_train,options)
% Input position should be a N x 3 arry which contains the time stemp, x
% and Y cordination, hd is the corresponding head direction.spike_train
% which contains the 4 x N (N = number of neuron) of data. Columen1 is the
% raw spikes, Column2 is the spikes sitting to nearest TTL signal postion.
% Colume three is the cordination of each spike. Colume4 is the spikes in
% head directions.

% This will plotting a screening plot for place cells and head direction.
arguments
    positions {mustBeNonmissing}
    hd {mustBeNonmissing}
    spike_train {mustBeNonmissing}
    options.PlotSize (1,:)  {mustBeNumeric} = [4 4]
    options.binWidth (1,1)  {mustBeNumeric} = 1/28
    options.hdBinWidth (1,1)  {mustBeNumeric} = 10
    options.smooth (1,1)  {mustBeNumeric} = 0
    options.save_plot (1,1)  string = 'True'
    options.save_path (1,1)  string = 'Q:\sachuriga\Record_archive\Record_examples'
    options.animalID (1,1)  string = '65165'
    options.day_num (1,1)  string = '2023-07-01'
end


options.save_path
options.animalID
options.day_num


s1=options.PlotSize(1);
s2=options.PlotSize(2);

for k =  1:length(hd)

    mk_path = string([options.save_path '/' options.animalID '/' options.day_num '/' num2str(k)]);
    mk_path=fullfile(join(mk_path));
    mk_path=strrep(mk_path,' ','');


    [headd,position] = load_positions_for_multi_segments(positions,hd,k);

    s1=options.PlotSize(1);
    s2=options.PlotSize(2);
    nbin = options.binWidth;
    [n,~] = size(spike_train(1).unit_id);

    f_raw(k)=figure;
    f_pc(k)=figure;
    f_hd(k)=figure;
    f_hdp(k)=figure;

    time_frame=position(:,1);
    cx_n=position(:,2);
    cy_n=position(:,3);
    unit_id=spike_train(1).unit_id;

    spike_train(k).spike_hd

    for k3=1:1:n

        clear acitivity
        clear activity_s
        clear spikehd
        clear tc

        activity = spike_train(k).spike_cor{k3};
        hdt = spike_train(k).spike_hd{k3};
        figure(f_raw(k))
        subplot(s1,s2,k3)
        plot(cx_n,cy_n,'Color',[119,136,153]/255, ...
            'LineWidth',0.01)
        hold on
        if isnan(hdt) == 1
            disp('No activasty')
        else
            plot(activity.x,activity.y,'r.', ...
                MarkerSize=1)
        end

        title(['unit' ' ' num2str(unit_id(k3))])
        ax = gca; % 获取当前图形的坐标轴对象
        ax.YDir = 'reverse'; % 设置Y轴反向
        xticks([0 1])
        yticks([0 1])
        hold on
        axis square

    end

    for k3=1:1:n

        clear spikehd
        clear temp_s
        clear map
        clear fieldsMap
        clear fields
        clear score
        spikehd = spike_train(k).spike_hd{k3};
        activity_s = spike_train(k).time_spike{k3};

        figure(f_pc(k))
        subplot(s1,s2,k3)

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

        tc = analyses.turningCurve(spikehd, headd, 1/25,'binWidth',options.hdBinWidth);
        temp_s = tc(:,2);
        figure(f_hdp(k))
        subplot(s1,s2,k3)

        if isnan(spikehd)==1

            disp('no activity')
            axis square
        else

            plot.circularTurning(temp_s)
            axis square
            ax = gca; % 获取当前图形的坐标轴对象
            ax.YDir = 'reverse'; % 设置Y轴反向

        end

        title(['unit' ' ' num2str(unit_id(k3))])
        figure(f_hd(k))
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

        elseif k3==n

            xlabel("degree");
            hold off

        end


    end

    if options.save_plot=='True'

        mkdir(mk_path);
        cd(mk_path)

        figure(f_raw(k))
        f1=gcf;
        %     exportgraphics(f1,'f_raw.png','Resolution',300)
        gaf=figure(f1);
        scrsz=get(0,'ScreenSize');
        set(gaf,'Position',scrsz);
        saveas(gca,'f_raw.jpg');

        figure(f_pc(k))
        f2=gcf;
        gaf=figure(f2);
        set(gaf,'Position',scrsz);
        saveas(gca,'f_pc.jpg');

        figure(f_hd(k))
        f3=gcf;
        gaf=figure(f3);
        set(gaf,'Position',scrsz);
        saveas(gca,'f_hd.jpg');

        figure(f_hdp(k))
        f4=gcf;
        gaf=figure(f4);
        set(gaf,'Position',scrsz);
        saveas(gca,'f_hdp.jpg');

    else
        disp('Not saved')
    end

end


end
