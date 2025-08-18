function artefacts(EEG, Artefacts, EpochLength)
arguments
    EEG
    Artefacts = [];
    EpochLength = 20;
end

if isempty(Artefacts)
    sprep.plot.eeglab_scroll(EEG)
    return
elseif any(size(Artefacts) ~= size(EEG.data))
    Artefacts = sprep.resample_matrix(Artefacts, EpochLength, [], EEG.srate, size(EEG.data, 2));
end

ArtefactsData = EEG.data;   
ArtefactsData(Artefacts==0) = nan;
sprep.plot.eeglab_scroll(EEG, ArtefactsData, EpochLength)