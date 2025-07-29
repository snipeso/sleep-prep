function ArtefactCells = ignore_tonic_muscle(ArtefactCells, MuscleIdx, MaxBadChannels)
arguments
    ArtefactCells
    MuscleIdx % index of which item in the cell is the muscle
    MaxBadChannels = 10;
end
% ArtefactCells = ignore_tonic_muscle(ArtefactCells, MuscleIdx, MaxBadChannels)
%
% This function ignores all the segments marked as bad because of muscle
% activity, when they only occur in a few channels (can be fixed with ICA).

% this is going to keep the epochs where multiple channels are marked as
% bad
MergedArtefacts = sprep.merge_artefacts(ArtefactCells);
TotBadChannels = sum(MergedArtefacts, 1);
ReallyBadEpochs = TotBadChannels>MaxBadChannels;
BadMuscle = ArtefactCells{MuscleIdx};
BadMuscle = BadMuscle(:, ReallyBadEpochs);

% set all muscle artefacts to blank
ArtefactsMuscle = false(size(ArtefactCells{MuscleIdx}));

% restore the bad ones
ArtefactsMuscle(:, ReallyBadEpochs) = BadMuscle;

ArtefactCells{MuscleIdx} = ArtefactsMuscle;


