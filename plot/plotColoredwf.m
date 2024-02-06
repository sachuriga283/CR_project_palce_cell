function plotColoredwf(tempmf,unit_id,cell_type)

switch cell_type

    case "narrow_int"
        cmap = colormap('spring');
        title(['narrow_int_unitID' num2str(unit_id)],'Color','white');
    case "wide_int"
        title(['wide_int_unitID' num2str(unit_id)],'Color','white');
        cmap = colormap('autumn');
    case "py"
        title(['py_unitID' num2str(unit_id)],'Color','white');
        cmap = colormap('cool');
end




% Assuming tempmf is your 64x82 array
[nRows, nCols] = size(tempmf);

% Determine the maximum value of each row
maxValues = abs(min(tempmf, [], 2));

% Find the indices of the rows with the top 10 maximum values
[~, sortedIndices] = sort(maxValues, 'descend');
top10Indices = sortedIndices(1:min(10, length(sortedIndices)));

% Get the 'cool' colormap
numColorsInCmap = size(cmap, 1);

% Select colors for the top 10 rows from the 'cool' colormap
selectedColors = cmap(round(linspace(1, numColorsInCmap, 10)), :);

% Create a custom colormap for plotting
cmp = [selectedColors; repmat([0, 0, 0], nRows - 10, 1)]; % Black for others

% Assign colors to rows based on their rank
rowColors = ones(nRows, 1) * size(cmp, 1); % Initialize all rows to black
for i = 1:length(top10Indices)
    rowColors(top10Indices(i)) = i; % Assign 'cool' colormap index to top 10 rows
end

% Plot each row with its assigned color and line width

hold on;
for i = 1:nRows
    lineWidth = ismember(i, top10Indices) * 1.5 + 0.1; % 2 for top 10, 1 for others
  
    plot(tempmf(i, :), 'Color', cmp(rowColors(i), :), 'LineWidth', lineWidth);
end
hold off;

% Customize the plot
xlabel('0.333ms/unit');
ylabel('amplitude');

end
