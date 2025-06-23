function [Artefacts, DifferenceArtefacts] = bad_channels_based_on_neighbors(EEG, CorrelationThreshold, DifferenceThreshold, HighPassFilter, LowPassFilter, CorrWindow, STDWindow)
arguments
    EEG
    CorrelationThreshold = .4;
    DifferenceThreshold = 5;
    HighPassFilter = 0.5;
    LowPassFilter = 6;
    CorrWindow = 4; % in seconds
    STDWindow = 60*5;
end


[Correlations, Differences, MostCorrCh] = sprep.utils.correlate_and_differentiate_neighbors(EEG,  HighPassFilter, LowPassFilter, CorrWindow, STDWindow);

CorrelationArtefacts = Correlations < CorrelationThreshold | ...
    Correlations == 1 | ...
    




DifferenceArtefacts = Differences>DifferenceThreshold;
DifferenceArtefacts = timepoints_correlated_with_artefacts(DifferenceArtefacts, MostCorrCh, maxIterations);

