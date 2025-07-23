function ArtefactCount = count_artefacts(ArtefactCells)


ArtefactCount = zeros(size(ArtefactCells{1}));

for ArtefactIdx = 1:numel(ArtefactCells)
    ArtefactCount = ArtefactCount + ArtefactCells{ArtefactIdx};
end
