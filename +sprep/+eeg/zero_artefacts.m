function EEG = zero_artefacts(EEG, Artefacts, ReplacementValue, EpochLength)
arguments
    EEG
    Artefacts
    ReplacementValue = 0;
    EpochLength = floor(size(EEG.data, 2)/size(Artefacts, 2));
end

if any(size(Artefacts) ~= size(EEG.data))
    Artefacts = sprep.resample_matrix(Artefacts, EpochLength, [], EEG.srate, size(EEG.data, 2));
end

EEG.data(Artefacts==1) = ReplacementValue;