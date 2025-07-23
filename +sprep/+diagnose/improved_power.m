function improved_power(Power, Frequencies, Scoring, ScoringLabels, ScoringIndexes, ArtefactsCell, ArtefactLabels)


AllArtefacts = sprep.merge_artefacts(ArtefactsCell);

% spectra

% remove all artefacts
PowerWithout = sprep.remove_artefacts(Power, AllArtefacts);

for ArtefactIdx = 1:numel(ArtefactLabels)

    % remove epochs with artefacts
    PowerWith = sprep.remove_artefacts(Power, AllArtefacts & not(ArtefactsCell{ArtefactIdx}));


    figure('Units','centimeters', 'Position',[0 0 60, 10])
    for ScoringIdx = 1:numel(ScoringIndexes)

        PowerWithStage = PowerWith(:, Scoring==ScoringIndexes(ScoringIdx), :);
        PowerWithoutStage = PowerWithout(:, Scoring==ScoringIndexes(ScoringIdx), :);

        PowerWithStage = squeeze(mean(PowerWithStage, 2, 'omitnan'));
        PowerWithoutStage = squeeze(mean(PowerWithoutStage, 2, 'omitnan'));

        subplot(1, numel(ScoringIndexes), ScoringIdx)
        hold on
        plot(Frequencies, PowerWithStage, 'Color',[1 0 0 .1], 'LineWidth',.5)
        plot(Frequencies, PowerWithoutStage, 'Color',[0 0 1 .1], 'LineWidth',.5)
        set(gca,'yscale', 'log')
        title([ScoringLabels{ScoringIdx}, ' ', ArtefactLabels{ArtefactIdx}])
        axis tight
        xlim([0 46])
    end
end

%%% plot just power of artifacts

for ArtefactIdx = 1:numel(ArtefactLabels)

    % remove epochs with artefacts
    PowerWith = sprep.remove_artefacts(Power, not(ArtefactsCell{ArtefactIdx}));


    figure('Units','centimeters', 'Position',[0 0 60, 10])
    for ScoringIdx = 1:numel(ScoringIndexes)

        PowerWithStage = PowerWith(:, Scoring==ScoringIndexes(ScoringIdx), :);

        PowerWithStage = squeeze(mean(PowerWithStage, 2, 'omitnan'));

        subplot(1, numel(ScoringIndexes), ScoringIdx)
        hold on
        plot(Frequencies, PowerWithStage, 'Color',[1 0 0 .1], 'LineWidth',.5)
        set(gca,'yscale', 'log')
        title([ScoringLabels{ScoringIdx}, ' ', ArtefactLabels{ArtefactIdx}])
        axis tight
        xlim([0 46])
    end
end


% topographies


