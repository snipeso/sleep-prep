function diagnostic_log(AllArtefacts, AllArtefactsLabels, DestinationFolder, FilenameCore, ProcessingTime)
arguments
    AllArtefacts
    AllArtefactsLabels
    DestinationFolder = cd;
    FilenameCore = 'unknown';
    ProcessingTime = nan;
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

% identify how many points were removed unique to each type of artefact
UniquePoints = nan(2, nArtefacts);

for ArtefactIdx = 1:nArtefacts
    UniquePoints(1, ArtefactIdx) = nnz(AllArtefacts{ArtefactIdx} & MergedArtefacts==1); % unique
    UniquePoints(2, ArtefactIdx) =  nnz(AllArtefacts{ArtefactIdx}) - UniquePoints(1, ArtefactIdx); % not unique
end

% save
save(fullfile(DestinationFolder, [FilenameCore, '.mat']), 'AllArtefacts', ...
    'UniquePoints', 'MergedArtefacts', 'ProcessingTime', 'TotArtefactPoints')

%%% plot
figure('Units','centimeters', 'position', [0 0 20 10])

subplot(1, 2, 1)
imagesc(UniquePoints)
colorbar
title('Points marked as artefacts')

subplot(1, 2, 2)
bar(UniquePoints, 'stacked')
xticks(1:nArtefacts)
xticklabels(AllArtefactsLabels)
legend({'Unique', 'Tot'})
title('N points removed by artefact')
saveas(gcf, fullfile(DestinationFolder, [FilenameCore, '.jpg']))

clc

disp(FilenameCore)
disp(['Total time: ', num2str(round(EndTime/60)), ' min'])
