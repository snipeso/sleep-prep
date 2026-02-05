function Holes = find_holes(Artefacts, Chanlocs, MinNeighbors)
% identifies any time there's artefacts in adjacent channels too far apart
% for good interpolation
arguments
    Artefacts % is a channel x time matrix, with 1 indicating an artefact
    Chanlocs
    MinNeighbors = 2;
end

if numel(Chanlocs) ~= size(Artefacts, 1)
    error('mismatch in artefacts and chanlocs')
end

Neighbors = sprep.utils.find_neighbors(Chanlocs);
EdgeChannels = find(sum(Neighbors)<=5);

Holes = zeros(size(Artefacts));

for ChannelIdx = 1:numel(Chanlocs)
    if ismember(ChannelIdx, EdgeChannels) % its ok if outer edge channels are poorly interpolated
        continue
    end

    ChNeighbors = Neighbors(ChannelIdx, :);
    nGoodNeighbors = sum(Artefacts(ChNeighbors, :)==0);

    Holes(ChannelIdx, :) = nGoodNeighbors < MinNeighbors;
end