function diagnostic_log(AllArtefacts, AllArtefactsLabels, DestinationFolder, FilenameCore, EndTime)
arguments
    AllArtefacts
    AllArtefactsLabels
    DestinationFolder = cd;
    FilenameCore = 'unknown';
    EndTime = nan;
end

if numel(AllArtefacts) ~= numel(AllArtefactsLabels)
    error('mismatch labels and artefacts')
else
    nArtefacts = numel(AllArtefactsLabels);
end

% merge all artefacts
MergedArtefacts = false(size(AllArtefacts{1}));
for ArtefactIdx = 1:nArtefacts
    MergedArtefacts = MergedArtefacts + AllArtefacts{ArtefactIdx};
end

TotArtefactPoints = nnz(MergedArtefacts);
TotPoints = numel(MergedArtefacts);

% identify how many points were removed unique to each type of artefact
UniquePoints = nan(2, nArtefacts);

for ArtefactIdx = 1:nArtefacts
    UniquePoints(1, ArtefactIdx) = nnz(AllArtefacts{ArtefactIdx} & MergedArtefacts==1); % unique
    UniquePoints(2, ArtefactIdx) =  nnz(AllArtefacts{ArtefactIdx}) - UniquePoints(1, ArtefactIdx); % not unique
end

% save
MaxArtefacts = max(MergedArtefacts(:));
if MaxArtefacts < 255
MergedArtefacts = uint8(MergedArtefacts);
else
MergedArtefacts = uint16(MergedArtefacts);
end

% save(fullfile(DestinationFolder, [FilenameCore, '.mat']), ...
%     'UniquePoints', 'MergedArtefacts', 'EndTime', 'TotArtefactPoints', 'TotPoints')

%%% plot
figure('Units','centimeters', 'position', [0 0 20 10])

subplot(1, 3, 1:2)
imagesc(MergedArtefacts)
colorbar
colormap(parula(1+MaxArtefacts))
clim([-.5 MaxArtefacts+.5])
title(['Points marked as artefacts (', num2str(round(100*TotArtefactPoints/TotPoints)), '% of data)'])

subplot(1, 3, 3)
bar(100*UniquePoints'./TotPoints', 'stacked', 'EdgeColor','none')
xticks(1:nArtefacts)
xticklabels(AllArtefactsLabels)
legend({'Unique', 'Tot'})
title('N points removed by artefact')
ylabel('% of data')
saveas(gcf, fullfile(DestinationFolder, [FilenameCore, '.jpg']))

clc

disp(FilenameCore)
disp(['Total time: ', num2str(round(EndTime/60)), ' min'])
