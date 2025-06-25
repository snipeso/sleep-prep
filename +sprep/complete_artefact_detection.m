function AllArtefacts = complete_artefact_detection(EEG, linenoise)
% this is almost example code, but it runs the complete artefact detection
% on EEG data, with no user input required, it just uses all the defaults.
% Data should be unfiltered, but no harm if it is, so long as frequencies
% 0.5-45 Hz are intact.
arguments
    EEG
    linenoise = 50; % Hz
end

% remove drifts (in case not all recordings had high-pass filter)
EEG = sprep.detrend_median(EEG);
EEG = sprep.line_filter(EEG, linenoise, false);

% NB: both these steps have to be done before any rereferencing, but after
% filtering!
ArtefactsBig = sprep.detect.big_artefacts(EEG);
ArtefactsFlat = sprep.detect.flatishlines(EEG);
ArtefactsDisconnected = sprep.detect.disconnected_channels(EEG);

% this function does the rereferencing internally
[~, ArtefactsCorrelation, ArtefactsDifferences] = sprep.detect.bad_channels_based_on_neighbors(EEG);

AllArtefacts = ArtefactsBig | ArtefactsFlat | ArtefactsDisconnected | ...
    ArtefactsDifferences | ArtefactsCorrelation;

AllArtefacts = sprep.adjust_artefact_edges(EEG, AllArtefacts);

