function EEG = cut_out_artefacts(EEG, RemoveEpochs, EpochLength)

% [Starts, Ends] = sprep.utils.data2windows(RemoveEpochs);
% 
% Windows = [Starts'-1, Ends']*EpochLength;
% 
% % make sure to capture any of that lingering EEG at the end when its not
% % exactly a multiple of the epoch lengths
% if Ends(end)==numel(RemoveEpochs)
%     Windows(end) = size(EEG.data, 2)/EEG.srate;
% end
% 
% EEG = pop_select(EEG, 'notime', Windows);

UpsampledArtefacts = sprep.utils.resample_array(RemoveEpochs, EpochLength, [], EEG.srate, size(EEG.data, 2), 'max');
EndArtefacts = numel(RemoveEpochs)*EpochLength*EEG.srate;
UpsampledArtefacts(:, EndArtefacts:end) = 1; % remove last seconds of data

EEG.data(:, UpsampledArtefacts) = [];

EEG = eeg_checkset(EEG); % it won't be happy