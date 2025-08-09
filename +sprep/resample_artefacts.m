function ArtefactsCell = resample_artefacts(ArtefactsCell, SampleRate, EpochLength, MaxOldPoints, MaxNewPoints, OldPeriod)
arguments
    ArtefactsCell
    SampleRate
    EpochLength
    MaxOldPoints
    MaxNewPoints
    OldPeriod = 1/SampleRate; % most detectors are for every sample point, but if not, specify what the period was
end


for ArtefactIdx = 1:numel(ArtefactsCell)
    ArtefactsCell{ArtefactIdx} = sprep.resample_matrix(ArtefactsCell{ArtefactIdx}, ...
        OldPeriod, EpochLength, SampleRate, MaxOldPoints, MaxNewPoints); 
end