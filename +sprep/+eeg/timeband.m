function EEGBand = timeband(EEG, Range)

EEGBand = EEG;

% filter
FiltEEG = pop_eegfiltnew(EEG, Range(1), []);
FiltEEG = pop_eegfiltnew(FiltEEG, [], Range(2));


% hilbert
for ChannelIdx = 1:size(EEG.data, 1)
    EEGBand.data(ChannelIdx, :) = abs(hilbert(FiltEEG.data(ChannelIdx, :))).^2;
end