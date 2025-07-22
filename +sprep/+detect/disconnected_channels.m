function Artefacts = disconnected_channels(EEG, CorrelationWindow, CorrelationThreshold, MinCorrChannels)
arguments
    EEG % should NOT be rereferenced from original recording!
    CorrelationWindow = 30; % seconds
    CorrelationThreshold = .999;
    MinCorrChannels = 5;
end

disp('Detecting disconnected channels')

% how many channels are highly correlated with each other
NCorrelations = sprep.utils.correlate_neighbors(EEG, CorrelationWindow, 'count', CorrelationThreshold);

% propose as artefacts any channel highly correlated with at least a
% certain number of channels
Artefacts = NCorrelations >= MinCorrChannels;

% it has to actually apply to at least three channels (this is important,
% because otherwise there's always some mini segment in N3 that manages to
% be super correlated with neighbors
Artefacts(:, sum(Artefacts, 1)<MinCorrChannels) = false;