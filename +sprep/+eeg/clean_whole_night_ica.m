function EEG = clean_whole_night_ica(EEG, Scoring, EpochLength, ArtefactTypes, MinTimeCycleDetection)
arguments
    EEG
    Scoring
    EpochLength
    ArtefactTypes = {'Eye', 'Heart', 'Muscle'};
    MinTimeCycleDetection = 10; % minutes
end

% identify sleep cycles (going to run ICA seperately on each stage of each
% cycle)
[Starts, Ends] = sprep.scoring.detect_sleep_cycles(Scoring, EpochLength, MinTimeCycleDetection);

% simplify scoring
Scoring = sprep.scoring.reassign_n1(Scoring, -1); % assign N1 to whatever came first
Scoring(Scoring<0) = -1; % group NREM together (TODO: check that this is ok)

UniqueScores = unique(Scoring);
UniqueScores(isnan(UniqueScores)) = [];


% filter just for ICA detection
EEGICA = sprep.highpass_eeg(EEG, high_pass, hp_stopband);


%%%%%%%%%%%%%
%%% Run


for CycleIdx = 1:numel(Starts)

    for StageIdx = 1:numel(UniqueScores)
        EEGICA = sprep.eeglab_ica(EEGICA);

        % use non-filtered data
        EEGICA.data = EEG.data;


        EEGICA = sprep.eeg.remove_ica_artefacts(EEGICA, {'Eye', 'Heart'});
    end
end

