function artefacts(EEG, Artefacts, EpochLength)

if any(size(Artefacts) ~= size(EEG.data))
    Artefacts = sprep.resample_matrix(Artefacts, EpochLength, [], EEG.srate, size(EEG.data, 2));
end

ArtefactsData = EEG.data;   
ArtefactsData(Artefacts==0) = nan;
sprep.plot.eeglab_scroll(EEG, ArtefactsData)