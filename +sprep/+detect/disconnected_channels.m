function Artefacts = disconnected_channels(EEG, CorrelationWindow, CorrelationThreshold, MinCorrChannels)
arguments
    EEG % should NOT be rereferenced from original recording!
    CorrelationWindow = 30; % seconds
    CorrelationThreshold = .999;
    MinCorrChannels = 3;
end

disp('Detecting disconnected channels')

NCorrelations = sprep.utils.correlate_neighbors(EEG, CorrelationWindow, 'count', CorrelationThreshold);

Artefacts = NCorrelations >= MinCorrChannels;

Artefacts(:, sum(Artefacts, 1)<MinCorrChannels) = false;