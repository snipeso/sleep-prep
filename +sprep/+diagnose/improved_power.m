function improved_power(Power, Frequencies, Scoring, ScoringLabels, ScoringIndexes, ArtefactsCell, ArtefactLabels)


AllArtefacts = sprep.merge_artefacts(ArtefactsCell);

% spectra

% remove all artefacts
PowerWithout = sprep.remove_artefacts(Power, AllArtefacts);

figure('Units','normalized', 'OuterPosition',[0 0 1 1])
for ArtefactIdx = 1:numel(ArtefactLabels)

    % remove epochs with artefacts
    PowerWith = sprep.remove_artefacts(Power, AllArtefacts & not(ArtefactsCell{ArtefactIdx}));

    for ScoringIdx = 1:numel(ScoringIndexes)

        PowerWithStage = PowerWith(:, Scoring==ScoringIndexes(ScoringIdx), :);
        PowerWithoutStage = PowerWithout(:, Scoring==ScoringIndexes(ScoringIdx), :);

        PowerWithStage = squeeze(mean(PowerWithStage, 2, 'omitnan'));
        PowerWithoutStage = squeeze(mean(PowerWithoutStage, 2, 'omitnan'));

        chART.sub_plot([], [numel(ScoringIndexes) ,numel(ArtefactLabels)], [ScoringIdx, ArtefactIdx]);
        hold on
        plot(Frequencies, PowerWithStage, 'Color',[1 0 0 .1], 'LineWidth',.5)
        plot(Frequencies, PowerWithoutStage, 'Color',[0 0 1 .1], 'LineWidth',.5)
        set(gca,'yscale', 'log')
        title([ScoringLabels{ScoringIdx}, ' ', ArtefactLabels{ArtefactIdx}])
        axis tight
        xlim([0 46])
    end
end

%%% plot just power of artefacts
figure('Units','normalized', 'OuterPosition',[0 0 1 1])

ArtefactCount = sprep.count_artefacts(ArtefactsCell);
for ArtefactIdx = 1:numel(ArtefactLabels)

    % remove epochs with artefacts
    PowerWith = sprep.remove_artefacts(Power, not(ArtefactsCell{ArtefactIdx} & ArtefactCount==1));

    for ScoringIdx = 1:numel(ScoringIndexes)

        PowerWithStage = PowerWith(:, Scoring==ScoringIndexes(ScoringIdx), :);
        PowerWithStage = squeeze(mean(PowerWithStage, 2, 'omitnan'));

        MeanPower = squeeze(mean(mean(PowerWithout(:, Scoring==ScoringIndexes(ScoringIdx), :), 2, 'omitnan'), 1, 'omitnan'));

        chART.sub_plot([], [numel(ScoringIndexes) ,numel(ArtefactLabels)], [ScoringIdx, ArtefactIdx]);
        hold on
        plot(Frequencies, PowerWithStage, 'Color',[1 0 0 .1], 'LineWidth',.5)

        plot(Frequencies, MeanPower, 'Color','k', 'LineWidth',2)
        set(gca,'yscale', 'log')
        title([ScoringLabels{ScoringIdx}, ' ', ArtefactLabels{ArtefactIdx}])
        axis tight
        xlim([0 46])
    end
end


% topographies


