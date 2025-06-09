function UncorrelatedArtefacts = detect_uncorrelated_segments(EEG, Artefacts)
arguments
    EEG
    Artefacts = zeros(size(EEG.data));
end


% % normalize data, avoids having to rereference to get amplitudes in same
% % ranges
% Data = EEG.data;
% Data = zscore(Data')';


%  see when channels are too correlated (100%) or not correlated enough with
% their neighbors


sprep.external.movcorr()
