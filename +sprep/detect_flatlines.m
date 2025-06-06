function Artefacts = detect_flatlines(EEG, MaxContiguous, adjustEdges, MinGap, BaselineQuantile, MaxEdgeWindow)
arguments
    EEG
    MaxContiguous = 2;
    adjustEdges = true;
        MinGap = 20; % seconds; min gap between artefacts, otherwise they get merged
    BaselineQuantile = .5;  % return signal to within this quantile of the signal
    MaxEdgeWindow = 30; % seconds; how much to spread the window before giving up
end

nChannels = size(EEG.data, 1);
fs = EEG.srate;

Artefacts = zeros(size(EEG.data));

disp('Detecting flatlines')

for ChannelIdx = 1:nChannels
    Signal = EEG.data(ChannelIdx, :);
    Flatlines = sprep.monoch.detect_flatlines(Signal, MaxContiguous, MinGap*fs);

    if adjustEdges
        Flatlines = sprep.monoch.adjust_all_cuts_edges_to_baseline(Signal, Flatlines, BaselineQuantile, fs*MaxEdgeWindow);
        disp(['Finished ', num2str(ChannelIdx), '/', num2str(nChannels)])

    end

    Artefacts(ChannelIdx, :) = Flatlines;
end



