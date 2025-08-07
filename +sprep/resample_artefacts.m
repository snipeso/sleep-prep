function ArtefactsCell = resample_artefacts(ArtefactsCell, SampleRate, EpochLength, MaxOldPoints, MaxNewPoints)


for ArtefactIdx = 1:numel(ArtefactsCell)
    ArtefactsCell{ArtefactIdx} = sprep.resample_matrix(ArtefactsCell{ArtefactIdx}, ...
        1/SampleRate, EpochLength, SampleRate, MaxOldPoints, MaxNewPoints); 
end