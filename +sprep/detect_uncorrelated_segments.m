function UncorrelatedArtefacts = detect_uncorrelated_segments(EEG, Artefacts, HighPassFilter, LowPassFilter, Window)
arguments
    EEG
    Artefacts = zeros(size(EEG.data));
    HighPassFilter = 1;
    LowPassFilter = 6;
    Window = 4;
end


% % normalize data, avoids having to rereference to get amplitudes in same
% % ranges
% Data = EEG.data;
% Data = zscore(Data')';

% filter data
EEG = pop_eegfiltnew(EEG, HighPassFilter);
EEG = pop_eegfiltnew(EEG, [], LowPassFilter);


% average reference
EEG.data(Artifacts) = nan;
EEG.data = EEG.data - mean(EEG.data, 1, 'omitnan');


%  see when channels are too correlated (100%) or not correlated enough with
% their neighbors
 R = correlate_neighbors(EEG, Window, 'max');

sprep.external.movcorr()
