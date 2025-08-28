function EEG = cut_out_artefacts(EEG, RemoveEpochs, EpochLength)

[Starts, Ends] = sprep.utils.data2windows(RemoveEpochs);

Windows = [Starts'-1, Ends']*EpochLength;

% make sure to capture any of that lingering EEG at the end when its not
% exactly a multiple of the epoch lengths
if Ends(end)==numel(RemoveEpochs)
    Windows(end) = size(EEG.data, 2)/EEG.srate;
end

EEG = pop_select(EEG, 'notime', Windows);