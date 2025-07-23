function Artefacts = hjorth_outliers(EEG, Scoring, EpochLength, HjorthEpochLength, ZscoreThreshold, RunTimes)
arguments
    EEG
    Scoring
    EpochLength
    HjorthEpochLength = 4;
    ZscoreThreshold = 2.5;
    RunTimes = 2;
end

HjorthParameters = sprep.calculate.hjorth_epochs(EEG);
nHjorthEpochs = size(HjorthParameters, 2);

% resample scoring to new Hjorth windows
ScoringIndexes = unique(Scoring);
Scoring = sprep.utils.resample_array(Scoring, EpochLength, HjorthEpochLength, EEG.srate, size(EEG.data, 2), 'mode', nHjorthEpochs);

Artefacts = false(size(HjorthParameters));
EpochIndexes = 1:nHjorthEpochs;

for RT = 1:RunTimes % loop multiple times to get both big and small artefacts
    for HPIdx = 1:3 % loop through all three parameters
        for StageIdx = 1:numel(ScoringIndexes) % apply thresholding seperately by stage

            % select relevant values
            SubsetHP = HjorthParameters(:, Scoring==ScoringIndexes(StageIdx), HPIdx);
            Epochs = EpochIndexes(Scoring==ScoringIndexes(StageIdx));

            % zscore them
            zHP = abs((SubsetHP-mean(SubsetHP, 2, 'omitnan'))./std(SubsetHP, 0, 2, 'omitnan'));

            for ChannelIdx = 1:size(HjorthParameters, 1) % may be better way to do this, but I'm running out of steam atm

                % threshold values to determine artefacts
                BadEpochs = Epochs(zHP(ChannelIdx, :)>ZscoreThreshold);
                Artefacts(ChannelIdx, BadEpochs) = true;

                % set to nan all values that were excluded, so at subsequent rounds, these don't contribute to the zscore
                HjorthParameters(ChannelIdx, BadEpochs, HPIdx) = nan;
            end
        end
    end
end
