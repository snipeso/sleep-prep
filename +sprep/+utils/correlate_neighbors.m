function R = correlate_neighbors(EEG, Window, Transformation, Threshold)
arguments
    EEG
    Window = 4; % in seconds
    Transformation = 'max'; % 'max' -> outputs for each channel the highest R value with neighbors; 'median' -> median R value; 'count' -> number of neighbors correlated above threshold
    Threshold = nan; % needed for 'count'
end

nChannels = size(EEG.data, 1);
nPoints = size(EEG.data, 2);
SampleRate = EEG.srate;

Window = Window*SampleRate;

ChannelIndexes = 1:nChannels;

Neighbors = sprep.utils.find_neighbors(EEG.chanlocs);

R = single(nan(nChannels, nPoints));

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
        case 'count'
              R(ChannelIdx, :) = sum(R_neighbors>Threshold, 1);
        otherwise
            error('incorrect transformation for correlate neighbors')
    end
    disp(['Finished correlating channel ', num2str(ChannelIdx)])
end
