function Artefacts = detect_flatishlines(EEG, adjustEdges, BaselineQuantile, MaxEdgeWindow, MovSDWindow, SDThreshold)
arguments
    EEG
    adjustEdges = true;
    BaselineQuantile = .5;  % return signal to within this quantile of the signal
    MaxEdgeWindow = 30; % seconds; how much to spread the window before giving up
    MovSDWindow = 10; % in seconds; does a moving standard deviation, and sees if it's below SD threshold. NB: the higher this is, the higher SD threshold can be without capturing EEG from channels close to the reference
    SDThreshold = .1;
end
% this does a moving standard deviation to find patches where the signal
% hardly fluctuates at all. Unlike like detect_flatlines, it allows for a
% little bit of jitter typical of missing electrodes and just real signals.

nChannels = size(EEG.data, 1);
fs = EEG.srate;

Artefacts = zeros(size(EEG.data));

disp('Detecting flatlines')

for ChannelIdx = 1:nChannels
    Signal = EEG.data(ChannelIdx, :);

    Flatlines = sprep.monoch.detect_flatishlines(Signal, MovSDWindow*fs, SDThreshold);

    if adjustEdges
        Flatlines = sprep.monoch.adjust_all_cuts_edges_to_baseline(Signal, Flatlines, BaselineQuantile, fs*MaxEdgeWindow);
        % disp(['Finished ', num2str(ChannelIdx), '/', num2str(nChannels)])
        fprintf('\rFinished %d/%d', ChannelIdx, nChannels);
    end

    Artefacts(ChannelIdx, :) = Flatlines;
end



