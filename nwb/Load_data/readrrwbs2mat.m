function [merge_spk,positions] = readrrwbs2mat(folderPath)
%READRRWBS2MAT Summary of this function goes here
% Specify the folder path
% List all files in the folder
files = dir(fullfile(folderPath, '*.nwb')); % Adjust '*.*' to something like '*.txt' for specific file types

merge_spk=table;
positions=struct;
fprintf('Starting process...\n');
for k = 1:length(files)
     percentage = k / length(files);
    
    % Create the progress bar with 20 segments
    progressBarLength = 20; % You can adjust the length of the progress bar
    numBars = floor(percentage * progressBarLength); % Calculate the number of '=' to display
    progressBar = [repmat('=', 1, numBars), repmat(' ', 1, progressBarLength - numBars)];
    
    % Use \r to return to the start of the line, and \033[K to clear from the cursor to the end of the line
    fprintf('\rProcessing %d of %d', k, length(files));
    fprintf('\r[%s] %d%%', progressBar, floor(percentage * 100));
    % Your processing code here
    pause(0.1); % Example pause to simulate a task

    path=fullfile([files(k).folder '\' files(k).name]);
    parts = split(files(k).name,'_');

    [spk,position,~] = Load_nwb(path); 
    spk.animal=repmat(parts{1}, height(spk), 1);
    spk.day=repmat(parts{2}, height(spk), 1);
    spk.session=repmat(parts{4}, height(spk), 1);

    fname = split(files(k).name,'.');
    fname_sanitized = strrep(fname{1}, '-', '_');
    fname_sanitized = string(strrep(fname_sanitized, '_', ''));
    fname_new = matlab.lang.makeValidName(['X', fname_sanitized]);
    positions.(fname_new(2)) = position;

    spk.UIfile=repmat(fname_new(2), height(spk), 1);
    spk.UIanimal_day=repmat([parts{1} strrep(parts{2}, '_', '')], height(spk), 1);
    spk.UIanimal_session=repmat([parts{1} parts{4}], height(spk), 1);
    [spk] = spi_classify(spk,positions);

    merge_spk = [merge_spk;spk];
    clear position fname fname_sanitized fname_new spk parts
end

end

