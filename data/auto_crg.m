
% Compute theta index from single cell autocorrelation.
%
%   USAGE
%       [counts,centers,thetaInd] = auto_crg(spikes)
%       spikes          vector of spike timestamps

%
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'numBins'     101  % 10 msec
%     'range'       500  % +/- 500 msec
%    =========================================================================
%   OUTPUT
%       counts          bin counts from histogram of autocorrelation
%       centers         bin centers from histogram of autocorrelation
%       thetaInd        ratio of theta-band (5-11 Hz) power to broadband (0-50 Hz) power
%
%   NOTES
%       Will not work well for small number of spikes (i.e. < 100).
%
%   SEE ALSO
%       calc.thetaIndexLFP
%
% Written by BRK 2016

function [counts,centers,thetaInd] = auto_crg(spikes,varargin)

%% binning
% numBins = 101; % 10 msec
numBins = 81 ; % 10 msec
% range = 500;   % +/- 500 msec
range = 20;   % +/- 500 msec

for i = 1:2:length(varargin),

    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+1) ' is not a property ']);
    end

    switch(lower(varargin{i})),
        case 'numbins',
            numBins = varargin{i+1};
        case 'range',
            range = varargin{i+1};
        otherwise,
            error(['Unknown property ''' num2str(varargin{i})]);
    end

end

%% normalize spike times (start at 0, and sec to msec)
normSpikes = ((spikes - min(spikes))*1000)';
if length(normSpikes) > 4000
    normSpikes = normSpikes(1:4000);
end
numSpikes = length(normSpikes);

%% find spike times within desired range
triMat = ones(numSpikes,1)*normSpikes - normSpikes'*ones(1,numSpikes);                                  % make triangular matrix
triMatSqueeze = triMat(:);                                                                              % collapse into single column
withinRange = triMatSqueeze(triMatSqueeze >= -range & triMatSqueeze <= range & triMatSqueeze ~= 0);     % find values within range that aren't zero

%% histogram
[counts centers] = hist(withinRange,numBins);
% set zero-lag to max
% zeroLag = round(numBins/2);
% counts(zeroLag) = nanmax(counts([1:zeroLag-1,zeroLag+1:end]));

%% FFT
rsrate = 500;
resampled = resample(counts,rsrate,numBins);
data = detrend(resampled);
nData = 500000;
nHz = floor(nData/2)+1;
sineX = fft(data,nData)/nData;
hz = linspace(0.1,rsrate/2,nHz);
tb = dsearchn(hz',[5 11]');
bb = dsearchn(hz',[0 50]');
% db = dsearchn(hz',[1 4]');
Power = 2*abs(sineX(1:length(hz)));
peakTheta = nanmax(Power(tb(1):tb(2)));
[~,peakThetaInd] = min(abs(Power-peakTheta));
length1Hz = round(nHz/(rsrate/2));
thetaPower = nanmean(Power(peakThetaInd-length1Hz:peakThetaInd+length1Hz));
bbPower = nanmean(Power(bb(1):bb(2)));
thetaInd = thetaPower/bbPower;

end
