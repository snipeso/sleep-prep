function Artefacts = disconnected_channels(EEG, CorrelationWindow, CorrelationThreshold, MaxCorrChannels)
arguments
    EEG % should NOT be rereferenced from original recording!
    CorrelationWindow = 30; % seconds
    CorrelationThreshold = .999;
    MaxCorrChannels = 3;
end

Correlations = sprep.utils.correlate_neighbors(EEG, CorrelationWindow, CorrelationThreshold);

Artefacts = Correlations > MaxCorrChannels;