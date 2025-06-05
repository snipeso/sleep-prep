function NewMatrix = resample_matrix(Matrix, old_period, new_period, SampleRate, NPoints, nNewEpochs)
% this is specifically for when data in Matrix is categorical, and so you
% jut want the majority score for a new window.
% Note, this is a slightly convoluted method, that first upsamples any
% matrix to the original size of the EEG array, then downsamples it; this
% is to make sure everything ultimately matches the original EEG.

disp('Resampling matrix (inefficient code)')

nChannels = size(Matrix, 1);

NewMatrix = nan(nChannels, nNewEpochs);

for ChannelIdx = 1:nChannels
    NewMatrix(ChannelIdx, :) = sprep.utils.resample_array(Matrix(ChannelIdx, :), ...
        old_period, new_period, SampleRate, NPoints, 'max', nNewEpochs);
end