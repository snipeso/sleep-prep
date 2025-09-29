function Array = smooth_flickers(Array, MovingWindowPoints, ThresholdProportion)
% this function smoothes out the flickering of an artefact array,
% penalizing changes from artefact to no artefact, and weighing artefacts
% (1s) more than clean periods. 

Diff = diff(Array);
Diff(Array(1:end-1)==1) = ThresholdProportion;

Flickers = movsum(Diff, MovingWindowPoints);

% since this is a Diff array, need one first point
Flickers = cat(2, Flickers(1), Flickers);

FlickeringPeriods = Flickers >= MovingWindowPoints*ThresholdProportion;
Array = Array | FlickeringPeriods;