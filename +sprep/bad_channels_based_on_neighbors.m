function [AllArtefacts, CorrelationArtefacts, DifferenceArtefacts] = ...
    bad_channels_based_on_neighbors(EEG, CorrelationThreshold, DifferenceThreshold, ...
    HighPassFilter, LowPassFilter, CorrWindow, STDWindow)
arguments
    EEG
    CorrelationThreshold = .4; % theoretically from [-1 1]; recommended between 0-.5
    DifferenceThreshold = 5; % how many times more than the standard deviation of the neighboring channel is still acceptable
    HighPassFilter = 0.5; % ignore drifts and sweating artefacts
    LowPassFilter = 6; % probably good from 4- 15 Hz; higher frequency activity doesn't correlate so much between neighbors
    CorrWindow = 4; % in seconds. The longer the window, the less difference there is between bad channels and actually good channels
    STDWindow = 60*5; % to calculate moving standard deviation; uses a long window so less affected by occasional artefacts % TODO: check if movmad works better
end
% this function looks at how correlated channels are to their neighbors,
% and how much their differ from their most correlated neighbor.

% get moving correlations and difference values. Correlations are Pearson's
% R, difference values are the ratio: Ch-ChCorrelatedest /
% std(ChCorrelatedest), such that a value of 2 means that the difference
% between the supposedly most correlated channels is 2 times the standard
% deviation of the other channel. 
[Correlations, Differences, MostCorrCh] = sprep.utils.correlate_and_differentiate_neighbors(...
    EEG,  HighPassFilter, LowPassFilter, CorrWindow, STDWindow);

% set thresholds for defining something an artefact
CorrelationArtefacts = Correlations < CorrelationThreshold | Correlations == 1;
    
DifferenceArtefacts = Differences>DifferenceThreshold;

% if a segment wasn't marked as an artefact because its values were not
% outside the standard deviation of the most correlateed neighboring
% channel, but that neighboring channel is an artefact, then odds are good
% that this segment is also an artefact
DifferenceArtefacts = sprep.utils.timepoints_correlated_with_artefacts(...
    DifferenceArtefacts, MostCorrCh);

AllArtefacts = CorrelationArtefacts | DifferenceArtefacts;
