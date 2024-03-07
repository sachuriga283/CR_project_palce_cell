
function CreatePlaceCellVedio(vedio_name,pos,spikes)% Specify the coordinates for the dot (example coordinates here)
animal='65588';
rootf = 'S:\Sachuriga\';
Recor = [rootf '\Ephys_Recording\CR_CA1\' animal];
nwb = [rootf '\nwb\CR_CA1' animal];

filename='S:\Sachuriga\Ephys_Vedio\CR_CA1\65588_Open_Field_50Hz_A2024-03-06T15_46_00.avi';
info = mmfileinfo(filename);
v = VideoReader(filename);
video = read(v);

% Specify the frames on which you want to plot the dots
frames_to_plot = [10, 20];
x = 100;
y = 200;

% Initialize a figure
figure;

% Loop through the specified frames
for i = 1:length(frames_to_plot)
    % Extract the specific frame
    frame = video(:, :, :, frames_to_plot(i));
    
    % Display the frame
    imshow(frame);
    hold on; % Hold on to plot the dot on top of the frame
    
    % Plot the dot
    plot(x, y, 'r.', 'MarkerSize', 20); % 'r.' specifies a red dot
    
    % Add title to the plot
    title(sprintf('Frame %d with Dot', frames_to_plot(i)));
    
    hold off; % Release the hold to allow new frames to be plotted
    
    % Pause to display the frame before moving to the next one
    pause(1);
end
end
