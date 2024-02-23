function [spikes,posi] = Load_nwb(path)
%LOAD_NWB Summary of this function goes here
%   Detailed explanation goes here
schemaVersion = util.getSchemaVersion(path);
generateCore(schemaVersion);


nwb = nwbRead(path);
spikes = nwb.units.toTable;

position = nwb.processing.get('behavior').loadAll().nwbdatainterface.get('Position').loadAll().spatialseries.get('SpatialSeries').data.load;
addpath('C:\Program Files\MATLAB\R2023a\toolbox\matlab\datafun\', '-begin');
addpath('C:\Program Files\MATLAB\R2022a\toolbox\matlab\datafun\', '-begin');
position(1,:) = normalize(position(1,:) ,'range');
position(2,:) = normalize(position(2,:) ,'range');
posi = double(position);

time = nwb.processing.get('behavior').loadAll().nwbdatainterface.get('Position').loadAll().spatialseries.get('SpatialSeries').timestamps.load;
posi = [time posi'];

end
