function EEG = select(EEG, KeepVector)
% recreate pop_select, but faster

Data = EEG.data;
EEG.data = [];

Data(:, ~KeepVector) = [];

EEG.data = Data;
EEG.times = EEG.times(KeepVector);
EEG.xmax = EEG.times(end);
EEG.pnts = numel(EEG.times);
EEG.event = struct();
% EEG = eeg_checkset(EEG);


