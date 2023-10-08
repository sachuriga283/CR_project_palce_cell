function plot_SpeedCells(save_path,animalID,day_num, session_num)

%     save_path = 'Q:\sachuriga\Record_archive\Record_examples';
%     animalID='65283';
%     day_num = '2023-10-07';
%     session_num = 'A';
    
    path = [save_path '\' animalID '\' day_num '\' session_num '\'];
    mk_path=fullfile(join(path));
    export_path=strrep(mk_path,' ','');
    mkdir(export_path)
    
    % Path = 'Q:\sachuriga\Record_archive\Record_examples\65165\2023-07-01\A\data/';
    Path = [save_path '/' animalID '/' day_num '/' session_num '/' 'data' '/' ];
    
    File = dir(strrep(fullfile(join([Path '*.mat'])),' ',''));
    FileNames = {File.name}';
    Length_Names = size(FileNames,1);
    
    for i=1:Length_Names
        filename=strcat(Path, FileNames(i));
        load(filename{1,1})
    end
    
    % larger than 30cm/s equal to 30cm/s
    velocity(velocity>0.6)=0.6;
    bin_point = 0:0.04:0.6;
    window = 0.04*1.5;
    id=unit_id(:);
    [s1,s2] = plot_size(id);
    
    f1=figure;
    
    for i=1:length(id)
    
    %     id=unit_id(i);
        spk=spike.spike_t{i};
        itan_spk = analyses.instantRate(spk', positions);
        smooth_spk = general.smoothGauss(itan_spk, 20);
    
        clear p25
        clear p50
        clear p75
        clear qt_spike
    
        for j = 1:length(bin_point)
    
            sliding_window = velocity >= bin_point(j)-window & velocity <= bin_point(j) + window;
            qt_spike =  smooth_spk(sliding_window);
            q_values = quantile(qt_spike, [0.25 0.5 0.75]);
            p25(j) = q_values(1);
            p50(j) = q_values(2);
            p75(j) = q_values(3);
    
        end
    
        ten_point = randi([1 length(velocity)],1,ceil(length(velocity)*0.1));
        subplot(s1,s2,i)
    
        s = scatter(velocity(ten_point),smooth_spk(ten_point),4);
        s.Marker = "o";
        s.MarkerEdgeColor="white";
        s.MarkerFaceColor=[211/255 211/255 211/255];
        s.LineWidth = 0.01;
        speedScores(i,:) = analyses.speedScore(velocity, itan_spk, 20);
        title(['unit_id' num2str(unit_id(i)) 'speedscore=' num2str(speedScores(i,1))]);
        hold on
        p = plot(bin_point,p50,'k.');
        p.MarkerSize=10;
        p255 = plot(bin_point,p25,'k-');
        p755 = plot(bin_point,p75,'k-');
    
    end
        
        speedcells = speedScores(:,1)>=0.3;
        speed_id = id(speedcells);
        
        save([Path 'speed_cellss' '.mat'],'speed_id');
    
        gaf=figure(f1);
        scrsz=get(0,'ScreenSize');
        set(gaf,'Position',scrsz);
        saveas(gca,[path 'speed_cell.jpg']);
        close all
        clear
        
end
