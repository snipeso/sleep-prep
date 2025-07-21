function EEG = smooth(EEG, SmoothSpan, Type)

disp('Smoothing eeg')
for ChannelIdx = 1:size(EEG.data, 1)

    switch Type
        case 'mean'
            EEG.data(ChannelIdx, :) = movmean(EEG.data(ChannelIdx, :), SmoothSpan*EEG.srate);
        case 'median'
             EEG.data(ChannelIdx, :) = movmedian(EEG.data(ChannelIdx, :), SmoothSpan*EEG.srate);
        otherwise
            EEG.data(ChannelIdx, :) = smooth(EEG.data(ChannelIdx, :)', SmoothSpan*EEG.srate)';
    end
end