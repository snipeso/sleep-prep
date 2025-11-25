function Artefacts = muscle_bursts(EEG, RangeMuscle, MedianMultiplierThresholds, SmoothWindow)
arguments
    EEG
    RangeMuscle = [20 45];
    MedianMultiplierThresholds = [20 100]; % x times the median for a burst threshold
    SmoothWindow = 0.2; % seconds
end
% Best if the data is rereferenced to average.

disp('Detecting muscle artefacts')

% get data into bands
MuscleEEG = sprep.eeg.timeband(EEG, RangeMuscle);

% smooth signal
SmoothData = sprep.eeg.smooth(MuscleEEG, SmoothWindow, 'mean');

% identify thresholds. Uses median of whole signal with the assumption that
% most of it will not have high muscle tone
Thresholds = MedianMultiplierThresholds.*median(SmoothData.data, 'all');

% identify peaks above stricter threshold, and define windows around the
% peak based on second threshold.
Artefacts = sprep.utils.double_threshold(SmoothData.data, Thresholds(1), Thresholds(2));