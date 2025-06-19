function R = correlate_neighbors(EEG, Window, Transformation)
arguments
    EEG
    Window = 4; % in seconds
    Transformation = 'max';
end
% to save space, this produces a weirdly shaped R matrix, and the channel
% indices involved in the pairs are specified in ChannelPairs. Increases
% complexity, but uses a lot less RAM.

nChannels = size(EEG.data, 1);
nPoints = size(EEG.data, 2);
SampleRate = EEG.srate;

Window = Window*SampleRate;

ChannelIndexes = 1:nChannels;

Neighbors = sprep.utils.find_neighbors(EEG.chanlocs);
% Neighbors = triu(Neighbors); % only take one diagonal to avoid repeating

% nPairs = nnz(Neighbors(:));
% R = nan(nPairs, nPoints);
% [Row, Col] = find(Neighbors);
% ChannelPairs = [Row, Col];

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


% % parfor PairIdx = 1:100 %numel(Row)
% for PairIdx = 1:100
% RC = ChannelPairs(PairIdx, :);
%     Data= EEG.data;
%
%     R(PairIdx, :) = sprep.external.movcorr(Data(RC(1), :)', Data(RC(2), :)', Window);
%
% end

% for Ch1Idx = 1:nChannels
%     for Ch2Idx = 1:nChannels
%
%         % skip non neighbors, to go fast
%         if Neighbors(Ch1Idx, Ch2Idx)==0
%             continue
%         end
%
%         r = sprep.external.movcorr(EEG.data(Ch1Idx, :)', EEG.data(Ch2Idx, :)', Window);
%
%         R = cat(1, R, r');
%         ChannelPairs = cat(1, ChannelPairs, [Ch1Idx, Ch2Idx]);
%
%         Idx = Idx+1;
%     end
% end