function EEG = zero_artefacts(EEG, Artefacts, ReplacementValue)
arguments
    EEG
    Artefacts
    ReplacementValue = 0;
end

EEG.data(Artefacts==1) = ReplacementValue;
