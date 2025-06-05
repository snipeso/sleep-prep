function Artefacts = detect_big_artefacts(EEG, VoltageThreshold, DiffVoltageThreshold, MinGap, BaselineQuantile, MaxEdgeWindow)
arguments
    EEG
    VoltageThreshold = 1000; % maximum acceptable voltage
    DiffVoltageThreshold = 50; % maximum acceptable difference from one point to the next
    MinGap = 20; % seconds; min gap between artefacts, otherwise they get merged
    BaselineQuantile = .5; % return signal to within this quantile of the signal
    MaxEdgeWindow = 30; % seconds; how much to spread the window before giving up
end

nChannels = size(EEG.data, 1);
fs = EEG.srate;

Artefacts = nan(size(EEG.data));

disp('Detecting artefacts in EEG')

for ChannelIdx = 1:nChannels
    Signal = EEG.data(ChannelIdx, :);

    Cuts = sprep.monoch.detect_big_artefacts(Signal, VoltageThreshold, DiffVoltageThreshold, MinGap*fs);

    BetterCuts = sprep.monoch.adjust_all_cuts_edges_to_baseline(Signal, Cuts, BaselineQuantile, fs*MaxEdgeWindow);

    Artefacts(ChannelIdx, :) = BetterCuts;
    disp(['Finished ', num2str(ChannelIdx), '/', num2str(nChannels)])
end


