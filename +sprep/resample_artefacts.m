function ArtifactsCell = resample_artefacts(ArtifactsCell, SampleRate, EpochLength, MaxOldPoints, MaxNewPoints)


for ArtifactIdx = 1:numel(ArtifactsCell)
    ArtifactsCell{ArtifactIdx} = sprep.resample_matrix(ArtifactsCell{ArtifactIdx}, ...
        1/SampleRate, EpochLength, SampleRate, MaxOldPoints, MaxNewPoints); 
end