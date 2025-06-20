function R = correlate_neighbors(EEG, Window, Transformation)
arguments
    EEG
    Window = 4; % in seconds
    Transformation = 'max';
end

nChannels = size(EEG.data, 1);
nPoints = size(EEG.data, 2);
SampleRate = EEG.srate;

Window = Window*SampleRate;

ChannelIndexes = 1:nChannels;

Neighbors = sprep.utils.find_neighbors(EEG.chanlocs);

R = nan(nChannels, nPoints);

for ChannelIdx = 1:nChannels
    NeighborChannels = unique(ChannelIndexes(Neighbors(ChannelIdx, :)));

    R_neighbors = nan(numel(NeighborChannels), nPoints);
    for NeighborIdx = 1:numel(NeighborChannels)
        R_neighbors(NeighborIdx, :) = sprep.external.movcorr(EEG.data(ChannelIdx, :)', ...
            EEG.data(NeighborChannels(NeighborIdx), :)', Window);
    end

    switch Transformation
        case 'median'
            R(ChannelIdx, :) = median(R_neighbors, 1);
        case 'max'
            R(ChannelIdx, :) = max(R_neighbors);
        otherwise
            error('incorrect transformation for correlate neighbors')
    end
    disp(['Finished correlating channel ', num2str(ChannelIdx)])
end
