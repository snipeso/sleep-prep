function D = differentiate_neighbors(EEG, Window, Transformation)
arguments
    EEG
    Window = 30; % in seconds
    Transformation = 'min';
end
% For each channel, the difference with its neighbors is calculated, and
% divided by the moving standard deviation of the neighbor; the smallest
% value is then provided

nChannels = size(EEG.data, 1);
nPoints = size(EEG.data, 2);
SampleRate = EEG.srate;

Window = Window*SampleRate;

ChannelIndexes = 1:nChannels;

Neighbors = sprep.utils.find_neighbors(EEG.chanlocs);

STD = movstd(EEG.data', 30*EEG.srate)';

D = nan(nChannels, nPoints);

for ChannelIdx = 1:nChannels
    NeighborChannels = unique(ChannelIndexes(Neighbors(ChannelIdx, :)));

    D_neighbors = nan(numel(NeighborChannels), nPoints);
    for Idx = 1:numel(NeighborChannels)
        NeighborIdx = NeighborChannels(Idx);
        Diff = abs(EEG.data(ChannelIdx, :)-EEG.data(NeighborIdx, :));
        D_neighbors(Idx, :) = Diff./STD(NeighborIdx, :);
    end

    switch Transformation
        case 'median'
            D(ChannelIdx, :) = median(D_neighbors, 1);
        case 'max'
            D(ChannelIdx, :) = max(D_neighbors);
        case 'min'
            D(ChannelIdx, :) = min(D_neighbors);
        otherwise
            error('incorrect transformation for correlate neighbors')
    end
    disp(['Finished differentiating channel ', num2str(ChannelIdx)])
end
