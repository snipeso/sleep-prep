function Artefacts = adjust_artefact_edges(EEG, Artefacts, MinGapSize, MinArtefactSize, BaselineQuantile, MaxEdgeWindow)
arguments
    EEG
    Artefacts
    MinGapSize = 10; % seconds; min gap between artefacts, otherwise they get merged
    MinArtefactSize = 1; % seconds;
    BaselineQuantile = .5; % return signal to within this quantile of the signal
    MaxEdgeWindow = 30; % seconds; how much to spread the window before giving up
end
% Advice: this can be a bit slow, so only use this if you really need high
% temporal resolution for calculating power; if just on the epoch level,
% just toss the whole epoch and don't look back.

nChannels = size(EEG.data, 1);
fs = EEG.srate;

disp('Adjusting artefact edges')

for ChannelIdx = 1:nChannels

    % merge artefacts when they're close, and remove the really tiny ones
    % that didn't get merged anywhere
    Cuts = sprep.monoch.close_gaps(Artefacts(ChannelIdx, :), MinGapSize*fs, MinArtefactSize*fs);

    % make sure the edges of the artefacts fall within a normal range of
    % values for that channel
    Cuts = sprep.monoch.adjust_all_cuts_edges_to_baseline(...
        EEG.data(ChannelIdx, :), Cuts, ...
        BaselineQuantile, fs*MaxEdgeWindow);

    % once again remove gaps too small, in case any came up after extending
    % the window edges. This doesn't risk producing sharp edges, because
    % the remaining edges will have already been vetted.
    Cuts = sprep.monoch.close_gaps(Cuts, MinGapSize*fs);

    Artefacts(ChannelIdx, :) = Cuts;

    disp(['Finished merging gaps for ', num2str(ChannelIdx), '/', num2str(nChannels)])
end