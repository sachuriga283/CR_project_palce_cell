function plotFiringPositions(A, firingTimes)
    % A is the array with dimensions (2000, 3) where:
    % A(:, 1) - time vector
    % A(:, 2) - x position
    % A(:, 3) - y position
    %
    % firingTimes is a cell array where each cell contains the firing times
    % for a unit. For example, firingTimes{1} contains the firing times for unit 1.

    % Initialize the figure
    figure;
    hold on; % Hold on to plot all units on the same figure

    % Get the 'jet' colormap with as many colors as there are units
    colors = jet(length(firingTimes));

    % Loop through each unit
    for i = 1:length(firingTimes)
        % For each firing time of the unit, find the closest time in A and plot
        for j = 1:length(firingTimes{i})
            % Find the index of the closest time in A for the current firing time
            [~, idx] = min(abs(A(:, 1) - firingTimes{i}(j)));

            % Plot the corresponding x and y position
            plot(A(idx, 2), A(idx, 3), '.', 'MarkerSize', 20, 'Color', colors(i, :));
        end
    end

    hold off; % Release the hold
    xlabel('X position');
    ylabel('Y position');
    title('Firing Positions for Each Unit');
end