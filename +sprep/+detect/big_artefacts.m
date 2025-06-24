function Artefacts = big_artefacts(EEG, VoltageThreshold, DiffVoltageThreshold, Padding)
arguments
    EEG
    VoltageThreshold = 1000; % maximum acceptable voltage
    DiffVoltageThreshold = 100; % maximum acceptable difference from one point to the next
    Padding = 1; % seconds; how much to pad artefacts; important when dealing with sharp edges, which when filtered can create little ripples around it
end

nChannels = size(EEG.data, 1);
fs = EEG.srate;

Artefacts = nan(size(EEG.data));

disp('Detecting large artefacts in EEG')

for ChannelIdx = 1:nChannels
    Artefacts(ChannelIdx, :)  = sprep.monoch.detect_big_artefacts(EEG.data(ChannelIdx, :), ...
        VoltageThreshold, DiffVoltageThreshold, Padding*fs);
end


