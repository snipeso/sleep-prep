function Correlations = correlate_noise(EEG, MostCorrCh, CorrWindow)
arguments
    EEG
    MostCorrCh = [];
    CorrWindow = 30;
end
% this function tackles the particular artefact when an amplifier or the
% reference channel becomes disconnected; it leads to many or all channels
% to be extremely correlated with each other. Because N3 can also have
% extremely high correlations, this function focuses on high frequencies,
% which are seldom highly correlated even in N3.

nChannels = size(EEG.data, 1);
nPoints = size(EEG.data, 2);
SampleRate = EEG.srate;


% EEG = pop_eegfiltnew(EEG, 15, []);
% EEG = pop_eegfiltnew(EEG, 45, []);

% identify just one channel to correlate with any other
if isempty(MostCorrCh)
    disp('No correlations provided, so just using closest channel')
    % get physically closest channel
    MostCorrCh = sprep.utils.find_neighbors(EEG.chanlocs, 'Closest');
else
    % get only one channel to correlate
    MostCorrCh = mode(MostCorrCh');
end

Correlations = nan(nChannels, nPoints);

for ChannelIdx = 1:nChannels

    NeighborIdx = MostCorrCh(ChannelIdx);
    Correlations(ChannelIdx, :) = sprep.external.movcorr(EEG.data(ChannelIdx, :)', ...
        EEG.data(NeighborIdx, :)', CorrWindow*SampleRate);

end