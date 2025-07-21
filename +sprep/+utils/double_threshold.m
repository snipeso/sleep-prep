function Artefacts = double_threshold(Data, LowerThreshold, UpperThreshold)
% finds all values that are above an upper threshold, but extends the edges
% of these segments down to the lower threshold. Does not work when the
% lower threshold is the mean/median like for amplitudes, but works for
% muscle burst detection

disp('Finding double threshold crossings')

if LowerThreshold >= UpperThreshold
    error('Lower threshold is larger than upper threshold')
end

Artefacts = Data > UpperThreshold;

PossibleArtefacts = Data > LowerThreshold;

for ChannelIdx = 1:size(Data, 1)
    [ArtiStarts, ArtiEnds] = sprep.utils.data2windows(Artefacts(ChannelIdx, :));
    [PossiArtiStarts, PossiArtiEnds] = sprep.utils.data2windows(PossibleArtefacts(ChannelIdx, :));

    if numel(PossiArtiStarts)< numel(ArtiStarts) % in case there's a lot of little spikes at the high threshold, and the lower threshold bunches them together
        ArtiEdges = [ArtiStarts, ArtiEnds];

        for StartIdx = 1:numel(PossiArtiStarts)
            if any(ArtiEdges>=PossiArtiStarts(StartIdx) & ArtiEdges<=PossiArtiEnds(StartIdx))
                Artefacts(ChannelIdx, PossiArtiStarts(StartIdx):PossiArtiEnds(StartIdx)) = true;
            end
        end

    % if there are a lot more spikes at the lower threshold that don't have
    % any corresponding big spikes
    else
        for StartIdx = 1:numel(ArtiStarts)
            NewStart = PossiArtiStarts(PossiArtiStarts<=ArtiStarts(StartIdx) & PossiArtiEnds>=ArtiStarts(StartIdx));
            NewEnd = PossiArtiEnds(PossiArtiEnds>=ArtiEnds(StartIdx) & PossiArtiStarts<=ArtiEnds(StartIdx));
            Artefacts(ChannelIdx, NewStart:NewEnd) = true;
        end
    end
end
