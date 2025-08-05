clear
clc
close all


% make sure the folder with +sprep/ is added to matlab's paths.

%% Fill in parameters according to the data you have


Filepath = 'D:\Data\EPISL\Preprocessed\Specparam\MAT\EPISL\P223_EPISL_Session1.mat';
load(Filepath, 'EEG', 'Scoring') % I save EEG and Scoring together, but however you need to, load in a EEGLAB EEG structure with the sleep data (including chanlocs!) and scoring data
ScoringIndexes = [-3 -2 -1 0 1]; % the code will only consider these numbers in Scoring (which should be a vector of indexes, one score per epoch)
ScoringLabels = {'N3', 'N2', 'N1', 'W', 'R'}; % these are the labels associated in order with the ScoringIndexes
EpochLength = 20;
NotEEG = [49 56 107 113 126 127]; % channels to remove right away



%% detect artefact

% remove non-eeg channels
EEG = pop_select(EEG, 'nochannel', NotEEG);

StartTime = tic;
EEG = pop_eegfiltnew(EEG, 0.5, []); % filter to frequency range of interest; this is so big artifact detection detects artefacts in relevant ranges; I'm using pop_eegplot for simplicity, but do what you want
EEG = sprep.line_filter(EEG, 50, false);


% NB: both these steps have to be done before any rereferencing, but after
% filtering! Some big artefacts just disappear once filtered, so no point
% marking that data as artefactual
ArtefactsBig = sprep.detect.big_artefacts(EEG);
ArtefactsFlat = sprep.detect.flatishlines(EEG);
ArtefactsDisconnected = sprep.detect.disconnected_channels(EEG);

% set the really big artefacts to zero because they can spread their evil
% to other channels during rereferencing for later artefact detection
% based on average reference.
EEG_arti = sprep.eeg.zero_artefacts(EEG, ArtefactsBig);
ArtefactsMuscle = sprep.detect.muscle_bursts(EEG_arti);
[~, ArtefactsCorrelation, ArtefactsDifference] = sprep.detect.bad_channels_based_on_neighbors(EEG_arti);

EndTime = toc(StartTime);

AllArtefacts = {ArtefactsMuscle, ArtefactsCorrelation, ArtefactsDifference, ArtefactsBig,  ArtefactsFlat, ArtefactsDisconnected};
ArtefactLabels = {'Muscle', 'Correlation', 'Difference', 'Big', 'Flat', 'Unplugged'};



% this plots a diagram of which artefacts were detected by each detector,
% and which by multiple detectors; allows to evaluate whether any of them
% are redundant
Time = linspace(0, size(EEG.data, 2)/EEG.srate, size(EEG.data, 2));
sprep.diagnose.removed_data(AllArtefacts, ArtefactLabels, Time, cd, 'demo', EndTime);



%% extra

% extend edges or artefacts so that it closes gaps, and makes sure the
% signal gets back down to baseline values, so that if you were to cut data
% at that point, then calculate power or so on the concatenated data, there
% wouldn't be any jumps
ArtefactsMerged = sprep.merge_artefacts(AllArtefacts);
AllArtefactsSmooth = sprep.adjust_artefact_edges(EEG, ArtefactsMerged);


%% visualize epochs marked as artefacts

ArtefactsData = EEG.data;
ArtefactsData(AllArtefactsSmooth==0) = nan;
% ArtefactsData(ArtefactsMuscle==0) = nan; % explore also individidually which artefacts were detected

if size(EEG.data) == size(ArtefactsData) % just checking
    sprep.plot.eeglab_scroll(EEG, ArtefactsData)
end



%% TODO: example code for ICA