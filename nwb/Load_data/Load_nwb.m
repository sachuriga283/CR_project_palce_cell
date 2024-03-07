function [spikes,posi,posi_raw] = Load_nwb(path)
%LOAD_NWB Summary of this function goes here
%   Detailed explanation goes here
schemaVersion = util.getSchemaVersion(path);
generateCore(schemaVersion);
nwb = nwbRead(path);
spikes = nwb.units.toTable;

positions = nwb.processing.get('Behavioral data').loadAll().nwbdatainterface.get('Position in pixel').loadAll().spatialseries.get('SpatialSeries').data.load;
% addpath('C:\Program Files\MATLAB\R2023b\toolbox\matlab\datafun\', '-begin');
 addpath('C:\Program Files\MATLAB\R2023a\toolbox\matlab\datafun\', '-begin');
addpath('C:\Program Files\MATLAB\R2022a\toolbox\matlab\datafun\', '-begin');
position(1,:) = normalize(positions(1,:) ,'range');
position(2,:) = normalize(positions(2,:) ,'range');
posi = double(position);

pos_raw(1,:) = positions(1,:);
pos_raw(2,:) = positions(2,:);

posraw=double(pos_raw);
time = nwb.processing.get('Behavioral data').loadAll().nwbdatainterface.get('Position in pixel').loadAll().spatialseries.get('SpatialSeries').timestamps.load;
posi = [time posi'];
posi_raw = [time posraw'];
end
