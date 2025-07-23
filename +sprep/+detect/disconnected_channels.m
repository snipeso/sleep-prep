function Artefacts = disconnected_channels(EEG, CorrelationWindow, CorrelationThreshold, MinCorrChannels)
arguments
    EEG % should NOT be rereferenced from original recording!
    CorrelationWindow = 30; % seconds
    CorrelationThreshold = .999;
    MinCorrChannels = 5;
end

disp('Detecting disconnected channels')

[nChannels, nPoints]= size(EEG.data);
Artefacts = false(nChannels, nPoints);

% correlate in windows
[Starts, Ends] = sprep.utils.epoch_edges(CorrelationWindow, EEG.srate, nPoints);

for WindowIdx = 1:numel(Starts)

    % correlate channel with all other channels
    Window = EEG.data(:, Starts(WindowIdx):Ends(WindowIdx));
    R = corr(Window');

    % exclude diagonal
    R(1:1+size(R,1):end) = nan;

    for ChannelIdx = 1:nChannels

        % sum number of channels correlated with reference channel above
        % threshold value
        if sum(abs(R(ChannelIdx, :))>CorrelationThreshold) >= MinCorrChannels
            Artefacts(ChannelIdx, Starts(WindowIdx):Ends(WindowIdx)) = true;
        end
    end
end

% it has to actually apply to at least N channels (this is important,
% because otherwise there's always some mini segment in N3 that manages to
% be super correlated with neighbors
Artefacts(:, sum(Artefacts, 1)<MinCorrChannels) = false;