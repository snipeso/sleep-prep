function Artefacts = close_channel_gaps(Artefacts, GapSizePoints)
% this closes all gaps in artefacts that are smaller than a certain size.
% Best done before removing all epochs so as not to remove too much clean
% data.

AllBadIndexes = all(Artefacts, 1);

ShortArtefacts = Artefacts;
ShortArtefacts(:, AllBadIndexes) = [];

for ChIdx = 1:size(ShortArtefacts, 1)
    ShortArtefacts(ChIdx, :) = sprep.monoch.close_gaps(ShortArtefacts(ChIdx, :), GapSizePoints);
end

Artefacts(:, ~AllBadIndexes) = ShortArtefacts;