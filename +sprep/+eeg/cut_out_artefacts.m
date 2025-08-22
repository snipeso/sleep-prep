function EEG = cut_out_artefacts(EEG, RemoveEpochs, EpochLength)

Artefacts = repmat(RemoveEpochs, size(EEG.data, 1), 1);
EEG = sprep.eeg.zero_artefacts(EEG, Artefacts, nan, EpochLength);
EEG.data(:, all(isnan(EEG.data))) = [];
EEG = eeg_checkset(EEG);
