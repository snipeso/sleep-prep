function [EEG, interpolatedPoints] = interpolate_artefacts(EEG, Artefacts, EpochLength)
arguments
    EEG
    Artefacts
    EpochLength = []; % this assumes artefacts is the same number of points as EEG data
end

nChannels = size(Artefacts, 1);
nPoints = size(EEG.data, 2);

interpolatedPoints = false(size(EEG.data));

% timepoints that have fewer than half of available channels won't be
% interpolated
Artefacts(:, sum(Artefacts, 1)>nChannels/2) = 0;

% identify all the unique subsets of bad channels; this will be at most the
% same as the number of epochs, but best case scenario just a couple if for
% example there's one bad electrode that pops halfway through the night.
% It'll therefore either be faster or the same as epoch-wise interpolation.
[ClustersOfBadChannels, ~, TimepointsOfClusters] = unique(Artefacts', 'rows');
nClusters = size(ClustersOfBadChannels, 1);


disp(['Interpolating ', num2str(nClusters), ' segments'])

for ClusterIdx = 1:nClusters
    
    % get one unique set of bad channels
    BadChannels = ClustersOfBadChannels(ClusterIdx, :);
    if not(any(BadChannels==1))
        continue
    end

    % find the corresponding time points where there are those bad channels
    BadWindows = TimepointsOfClusters==ClusterIdx;

    if ~isempty(EpochLength)
    BadPoints = sprep.monoch.resample_scoring(BadWindows, EpochLength, [], EEG.srate, nPoints);
    else
        BadPoints = BadWindows;
    end

    [Starts, Ends] = sprep.utils.data2windows(BadPoints);
    
    % select relevant data
    EEGMini = pop_select(EEG, 'point', [Starts, Ends]);
    EEGMini = pop_select(EEGMini, 'nochannel', find(BadChannels));

    % interpolate only that subset of data back to the original number of
    % channels
    EEGMini = pop_interp(EEGMini, EEG.chanlocs);

    % restore the data to original matrix
    EEG.data(:, BadPoints) = EEGMini.data;
    interpolatedPoints(BadChannels, BadPoints) = true;

    disp(['finished cluster ', num2str(ClusterIdx), '/', num2str(nClusters)])
end

% interpolate bad channels