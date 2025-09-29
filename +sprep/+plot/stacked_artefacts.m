function stacked_artefacts(ArtefactCells, ArtefactLabels, Time)

ArtefactPlot = zeros(size(ArtefactCells{1}));
AllArtefacts = ArtefactPlot;

nArtefacts = numel(ArtefactLabels);

for ArtefactIdx = 1:nArtefacts
    AllArtefacts = AllArtefacts + ArtefactCells{ArtefactIdx};
end

for ArtefactIdx = 1:nArtefacts
    ArtefactPlot(ArtefactCells{ArtefactIdx}) = ArtefactIdx;
end

ArtefactPlot(AllArtefacts>1) = numel(ArtefactLabels)+1;

imagesc(Time, 1:size(AllArtefacts, 1), ArtefactPlot)

if numel(ArtefactLabels)>1
    colormap(turbo(numel(ArtefactLabels)+3))
    clim([-0.5, numel(ArtefactLabels)+2.5])

    Colorbar = colorbar;

    Labels = ['none', ArtefactLabels, 'multiple'];
    set(Colorbar, 'Ticks', 0:nArtefacts+1, 'TickLabels', Labels);
else

    colormap(turbo(numel(ArtefactLabels)+2))
    clim([-0.5, numel(ArtefactLabels)+1.5])

    Colorbar = colorbar;

    Labels = ['none', ArtefactLabels];
    set(Colorbar, 'Ticks', 0:nArtefacts, 'TickLabels', Labels);
end

set(gca, 'YTick', [])
