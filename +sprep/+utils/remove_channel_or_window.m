function Artefacts = remove_channel_or_window(Artefacts, Threshold)
% BadSegments = remove_channel_or_window(BadSegments, Threshold)
%
% makes sure that the channel is either completely removed, or the window
% is. BadSegments is a Channel x Epoch matrix of 1s (noise) and 0s (data).
% Threshold is the proportion of bad segments that are acceptable before
% the channel or epoch is removed (from 0 to 1).
%
% From iota-neurophys, Snipes, 2024.
arguments
    Artefacts
    Threshold = 0.3;
end

Artefacts = double(Artefacts);
[nCh, nWin] = size(Artefacts);


while any(sum(Artefacts, 2, 'omitnan')/nWin>Threshold) || ...
        any(sum(Artefacts, 1, 'omitnan')/nCh>Threshold) % while there is still missing data to remove in either channels or segments

    % identify amount of missing data for each channel/segment
    PrcntCh = sum(Artefacts, 2, 'omitnan')/nWin;
    PrcntWin = sum(Artefacts, 1, 'omitnan')/nCh;

    % find out which is missing most data
    MaxCh = max(PrcntCh);
    MaxWin = max(PrcntWin);

    % remove either a channel or a window
    if MaxCh > MaxWin % if the worst channel has more bad data than the worst segment, remove that one
        Artefacts(PrcntCh==MaxCh, :) = nan; % nan so that it doesn't interfere with the tally
    else
        Artefacts(:, PrcntWin==MaxWin) = nan;
    end
end

Artefacts(isnan(Artefacts)) = 1;
Artefacts = logical(Artefacts);
end