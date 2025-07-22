function artefacts(EEG, Artefacts)

ArtefactsData = EEG.data;   
ArtefactsData(Artefacts==0) = nan;
sprep.plot.eeglab_scroll(EEG, ArtefactsData)