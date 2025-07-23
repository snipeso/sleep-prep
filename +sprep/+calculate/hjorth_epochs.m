function HjorthParameters = hjorth_epochs(EEG, WindowLength)
arguments
    EEG
    WindowLength = 4;
end
% outputs a channel x epoch x 3 matrix, with the three parameters
% (Activity, Mobility, Complexity)

disp('Calculating hjorth values')

[nChannels, nPoints] = size(EEG.data);
SampleRate = EEG.srate;

[Starts, Ends] = sprep.utils.epoch_edges(WindowLength, SampleRate, nPoints);

HjorthParameters = nan(nChannels, numel(Starts), 3);

for ChannelIdx = 1:size(EEG.data, 1)
    for WindowIdx = 1:numel(Starts)
        Snippet = EEG.data(ChannelIdx, Starts(WindowIdx):Ends(WindowIdx));
        [HjorthParameters(ChannelIdx, WindowIdx, 1), ... % activity
            HjorthParameters(ChannelIdx, WindowIdx, 2), ... % mobility
            HjorthParameters(ChannelIdx, WindowIdx, 3), ... % complexity
            ] = sprep.external.hjorth(Snippet');
    end
end