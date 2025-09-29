function artefacts(EEG, Artefacts, EpochLength)
arguments
    EEG
    Artefacts = [];
    EpochLength = 20;
end


if isempty(Artefacts)
    sprep.plot.eeglab_scroll(EEG)
    return
end

if size(Artefacts, 1) ~= size(EEG.data, 1)
    error('mismatch in dimentions of artefacts and eeg')
end

if size(Artefacts, 2) ~= size(EEG.data, 2)
    Artefacts = sprep.resample_matrix(Artefacts, EpochLength, [], EEG.srate, size(EEG.data, 2));
end

ArtefactsData = EEG.data;   
ArtefactsData(Artefacts==0) = nan;
sprep.plot.eeglab_scroll(EEG, ArtefactsData, EpochLength)