function createFiringPositionVideo(A, firingTimes, fileName)
    % A is the array with dimensions (2000, 3) where:
    % A(:, 1) - time vector
    % A(:, 2) - x position
    % A(:, 3) - y position
    %
    % firingTimes is a cell array where each cell contains the firing times
    % for a unit.
    %
    % fileName is the name of the output video file.

    % Prepare the video writer
    writerObj = VideoWriter(fileName, 'MPEG-4');
    writerObj.FrameRate = 25;
    open(writerObj);
    
    % Get the 'jet' colormap with as many colors as there are units
    colors = jet(length(firingTimes));

    % Determine the time steps for the simulation based on the length of A and the desired number of points (500)
    timeSteps = linspace(min(A(:, 1)), max(A(:, 1)), 500);

    % Create a figure for the video frames
    fig = figure;
    hold on; % Hold on to plot all units on the same figure

    for t = 1:length(timeSteps)
        % Loop through each unit
        for i = 1:length(firingTimes)
            % Get the firing times for this unit that are less than the current time step
            validTimes = firingTimes{i}(firingTimes{i} <= timeSteps(t));
            
            % Plot the positions for these firing times
            for j = 1:length(validTimes)
                % Find the index of the closest time in A for the current firing time
                [~, idx] = min(abs(A(:, 1) - validTimes(j)));
                figure(fig)
                % Plot the corresponding x and y position
                plot(A(idx, 2), A(idx, 3), '.', 'MarkerSize', 20, 'Color', colors(i, :));
            end
            
        end

        title(sprintf('Time: %.2f', timeSteps(t)));
        xlabel('X position');
        ylabel('Y position');
        
        % Capture the frame
        frame = getframe(fig);
        writeVideo(writerObj, frame);
    end
    
    hold off; % Release the hold
    % Close the video writer
    close(writerObj);
    close(fig); % Close the figure window
end