function AllArtefacts = complete_artefact_detection(EEG)
% this is almost example code, but it runs the complete artefact detection
% on EEG data, with no user input required, it just uses all the defaults.
% Data should be notch filtered, and high-pass filtered as much as will be
% used in the final analysis
arguments
    EEG
end

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

AllArtefacts = sprep.utils.remove_channel_or_window(AllArtefacts, .2);
AllArtefacts = sprep.adjust_artefacts_for_holes(AllArtefacts, EEG.chanlocs);