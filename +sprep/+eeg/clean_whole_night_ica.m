function [EEG, EpochsNoICA] = clean_whole_night_ica(EEG, Scoring, EpochLength, ...
    Artefacts, ICAMinutes, ArtefactTypes, MaxBadChannels, MinTimeCycleDetection, HighpassFilter, Stopband)
arguments
    EEG
    Scoring
    EpochLength
    Artefacts = false(size(EEG.data, 1), numel(Scoring));
    ICAMinutes = [5 15]; % in minutes, min and max
    ArtefactTypes = {'Eye', 'Heart', 'Muscle'};
    MaxBadChannels = 10;
    MinTimeCycleDetection = 10; % minutes
    HighpassFilter = 2;
    Stopband = 1;
end
% Data should have at least been notch filtered and average referenced.

disp('Cleaning whole night with ICA; takes a while')

% nBadChannels = sum(Artefacts | Interpolated, 1);
nBadChannels = sum(Artefacts, 1);

% identify sleep cycles (going to run ICA seperately on each stage of each
% cycle)
[StartCycles, EndCycles] = sprep.scoring.detect_sleep_cycles(Scoring, EpochLength, MinTimeCycleDetection);
EpochIndexes = 1:numel(Scoring);

% simplify scoring
Scoring = sprep.scoring.reassign_n1(Scoring, -1); % assign N1 to whatever came first
Scoring(Scoring<0) = -1; % group NREM together (TODO: check that this is ok)

UniqueScores = unique(Scoring);
UniqueScores(isnan(UniqueScores)) = [];


% filter just for ICA detection
EEGfiltered = sprep.highpass_eeg(EEG, HighpassFilter, Stopband);

EpochsNoICA = false(1, numel(Scoring));

%%%%%%%%%%%%%
%%% Run


for CycleIdx = 1:numel(StartCycles)

    for StageIdx = 1:numel(UniqueScores)

        disp(['Running ICA for cycle ', num2str(CycleIdx),'/',num2str(numel(StartCycles)), ', stage ', num2str(UniqueScores(StageIdx)) ])

        % select clean enough epochs of given cycle of given stage
        Epochs = Scoring==UniqueScores(StageIdx) & ...
            EpochIndexes>=StartCycles(CycleIdx) & EpochIndexes<=EndCycles(CycleIdx);

        CleanEpochs = Epochs & nBadChannels<=MaxBadChannels;

        % if too few, skip
        if nnz(CleanEpochs)*EpochLength < ICAMinutes(1)*60
            EpochsNoICA(Epochs) = true;
            disp(['Not enough data for cycle #', num2str(CycleIdx), ', stage ', num2str(UniqueScores(StageIdx))])
            continue
        end

        % if many, take only first n minutes
        nArtefacts = nBadChannels;
        nArtefacts(~CleanEpochs) = nan;
        [~, CleanestEpochs] = mink(nArtefacts, ceil(ICAMinutes(2)*60/EpochLength));
        CleanEpochs = false(size(Scoring));
        CleanEpochs(CleanestEpochs) = true;
        CleanEpochs(isnan(nArtefacts)) = false;

        % select clean EEG
        [Starts, Ends] = sprep.utils.data2windows(CleanEpochs);
        Starts = Starts - EpochLength; % fence-post problem solution. If Start = 1 (the first epoch) then it needs to be 0 for whn its in seconds.
        EEGICA = pop_select(EEGfiltered, 'time', [Starts(:), Ends(:)]*EpochLength); % starts and ends is in epoch indexes, so need to turn into seconds

        if size(EEGICA.data, 2)/EEG.srate < ICAMinutes(1)*60
            disp('skipping cycle due to insuficient data')
            EpochsNoICA(Epochs) = true;
            continue
        end

        % run ICA
        try
        EEGICA = sprep.eeglab_ica(EEGICA);
        catch
        a=1;
        end

        % select EEG of stage & cycle, including unclean data
        EpochsInTime = sprep.utils.scoring2time(Epochs, EpochLength, EEG.srate, size(EEG.data, 2)); % uses points, to more easily get chunk of EEG data and put it back % TODO: check that off-by-one isn't a problem
        [Starts, Ends] = sprep.utils.data2windows(EpochsInTime);
        Edges = [Starts(:), Ends(:)];
        EEGStage = pop_select(EEG, 'point', [Starts(:), Ends(:)]);

        % switch out clean filtered data for all epochs unfiltered data
        EEGICA.data = EEGStage.data;
        EEGICA = eeg_checkset(EEGICA);

        % remove bad ICA artefacts
        EEGICA = sprep.eeg.remove_ica_artefacts(EEGICA, ArtefactTypes);

        % replace EEG with clean data
        EEG.data(:, EpochsInTime) = EEGICA.data;

        % save components
        EEGICA.data = [];
        EEGICA.Edges = Edges;
        if ~isfield(EEG, 'allICA')
            EEG.allICA = EEGICA;
            Idx = 1;
        else
            EEG.allICA(Idx) = EEGICA;
        end
        Idx = Idx+1;
    end
end


