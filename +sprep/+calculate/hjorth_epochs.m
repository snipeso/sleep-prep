function HjorthParameters = hjorth_epochs(EEG, WindowLength)
arguments
EEG
WindowLength = 4;
end

[nChannels, nPoints] = size(EEG.data);
SampleRate = EEG.srate;

[Starts, Ends] = sprep.utils.epoch_edges(WindowLength, SampleRate, nPoints);

for ChannelIdx = 1:size(EEG.data, 1)
    for 
    end
end