function Power = remove_artefacts(Power, Artefacts)
for ChannelIdx = 1:size(Artefacts, 1)
    Power(ChannelIdx, Artefacts(ChannelIdx, :), :) = nan;
end
end