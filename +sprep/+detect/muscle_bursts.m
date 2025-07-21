function Artefacts = muscle_bursts(EEG, RangeMuscle, MedianMultiplierThresholds, SmoothWindow)
arguments
    EEG
    RangeMuscle = [20 50];
    MedianMultiplierThresholds = [20 100];
    SmoothWindow = 0.2; % seconds
end

disp('Detecting muscle artifacts')

EEG = pop_reref(EEG, []);

% get data into bands
MuscleEEG = sprep.eeg.timeband(EEG, RangeMuscle);

SmoothData = sprep.eeg.smooth(MuscleEEG, SmoothWindow, 'mean');

Thresholds = MedianMultiplierThresholds.*median(SmoothData.data, 'all');

Artefacts = sprep.utils.double_threshold(SmoothData.data, Thresholds(1), Thresholds(2));

% Possibly: exclude any time its low complexity
% EEG = pop_eegfiltnew(EEG, HighPassFilt, []);
% max 2 s window
% 
% for ChIdx = 1:123
% 
% LZ(ChIdx) = sprep.external.calc_lz_complexity(EEGf.data(ChIdx, (Start*EEG.srate):((Start+2)*EEG.srate))>0, 'primitive', true);
% 
% end

% LZ > 2