function EEG = reref(EEG, NewReferenceChannels)
arguments
    EEG
    NewReferenceChannels = []; % average reference
end
% rereferences, but handles NaNs in EEG data

if isempty(NewReferenceChannels)
EEG.data = EEG.data - mean(EEG.data, 1, 'omitnan');
else

AllChannels = 1:size(EEG.data, 1); % indexes of channels
AllChannels(NewReferenceChannels) = [];

EEG.data = EEG.data(AllChannels, :) - mean(EEG.data(NewReferenceChannels, :), 1, 'omitnan');
end