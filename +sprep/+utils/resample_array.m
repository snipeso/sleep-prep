function NewArray = resample_array(Array, old_period, new_period, SampleRate, NPoints, mode, nNewEpochs)
% this is specifically for when data in Matrix is categorical, and so you
% jut want the majority score for a new window.
% Note, this is a slightly convoluted method, that first upsamples any
% matrix to the original size of the EEG array, then downsamples it; this
% is to make sure everything ultimately matches the original EEG.
arguments
    Array
    old_period
    new_period
    SampleRate
    NPoints
    mode = 'mode'; % could also be 'mean', 'max'
    nNewEpochs = [];
end

% upsample the data so that each point in the original EEG gets a value
if numel(Array) == NPoints
    ArrayInTime = Array; % if the data was already the size of the EEG, skip
else
    ArrayInTime = sprep.utils.scoring2time(Array, old_period, SampleRate, NPoints);
end

% if no new period is provided, assumes that it just wants a datapoint for
% each EEG point
if isempty(new_period)
    NewArray = ArrayInTime;
    return
end

%%% downsample to new epoch length

% new epoch start and end times
[Starts, Ends] = sprep.utils.epoch_edges(new_period, SampleRate, numel(ArrayInTime));

if ~exist("nNewEpochs", 'var') || isempty(nNewEpochs)
    nNewEpochs = numel(Starts);
end

NewArray = nan(1, nNewEpochs);

% group scores into epochs, assign based on most frequent score for each timepoint
for EpochIdx = 1:nNewEpochs
    Epoch = ArrayInTime(Starts(EpochIdx):Ends(EpochIdx));

    switch mode
        case 'mode'
            NewArray(EpochIdx) = mode(Epoch);
        case 'mean'
            NewArray(EpochIdx) = mean(Epoch, 'omitnan');
        case 'max'
            NewArray(EpochIdx) = max(Epoch);
        otherwise
            error('invalid mode for resampling array. use either: mode, max, mean')
    end

    if any(isnan(Epoch))
        NewArray(EpochIdx) = nan;
    end
end