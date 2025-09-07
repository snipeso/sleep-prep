function EEG = select(EEG, KeepVector)
% recreate pop_select, but faster

Data = EEG.data;
EEG.data = [];

Data(:, ~KeepVector) = [];

EEG.data = Data;
EEG.time = EEG.time(KeepVector);
EEG.event = struct();
EEG = eeg_checkset(EEG);


