function Artefacts = muscle_bursts(EEG, RangeMuscle, MedianMultiplierThresholds, SmoothWindow)
arguments
    EEG
    RangeMuscle = [20 50];
    MedianMultiplierThresholds = [20 100]; % x times the median for a burst threshold
    SmoothWindow = 0.2; % seconds
end

disp('Detecting muscle artifacts')

EEG = pop_reref(EEG, []);

% get data into bands
MuscleEEG = sprep.eeg.timeband(EEG, RangeMuscle);

SmoothData = sprep.eeg.smooth(MuscleEEG, SmoothWindow, 'mean');

Thresholds = MedianMultiplierThresholds.*median(SmoothData.data, 'all');

Artefacts = sprep.utils.double_threshold(SmoothData.data, Thresholds(1), Thresholds(2));