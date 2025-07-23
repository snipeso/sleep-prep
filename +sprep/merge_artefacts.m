function AllArtefacts = merge_artefacts(ArtefactsCell)

AllArtefacts = false(size(ArtefactsCell{1}));
for ArtefactIdx = 1:numel(ArtefactsCell)
    AllArtefacts = AllArtefacts | ArtefactsCell{ArtefactIdx};
end