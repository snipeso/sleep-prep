function Artefacts = detect_flatlines(EEG, adjustEdges, MaxContiguous, MinGap, BaselineQuantile, MaxEdgeWindow, MovSDWindow, SDThreshold)
arguments
    EEG
    adjustEdges = true;
    MaxContiguous = 2;
    MinGap = 20; % seconds; min gap between artefacts, otherwise they get merged
    BaselineQuantile = .5;  % return signal to within this quantile of the signal
    MaxEdgeWindow = 30; % seconds; how much to spread the window before giving up
    MovSDWindow = 10; % in seconds; does a moving standard deviation, and sees if it's below SD threshold. NB: the higher this is, the higher SD threshold can be without capturing EEG from channels close to the reference
    SDThreshold = .1;
end

nChannels = size(EEG.data, 1);
fs = EEG.srate;

Artefacts = zeros(size(EEG.data));

disp('Detecting flatlines')

for ChannelIdx = 1:nChannels
    Signal = EEG.data(ChannelIdx, :);

    % all moments that the signal doesn't deviate hardly at all
    Flatlines = sprep.monoch.detect_flatlines(Signal, MaxContiguous, MinGap*fs);

    % moments where it deviates, but a minuscule amount
    if ~isempty(MovSDWindow)
        Flatlines = Flatlines | sprep.monoch.detect_flatishlines(Signal, MovSDWindow*fs, SDThreshold);
    end

    if adjustEdges
        Flatlines = sprep.monoch.adjust_all_cuts_edges_to_baseline(Signal, Flatlines, BaselineQuantile, fs*MaxEdgeWindow);
        disp(['Finished ', num2str(ChannelIdx), '/', num2str(nChannels)])
    end

    Artefacts(ChannelIdx, :) = Flatlines;
end



