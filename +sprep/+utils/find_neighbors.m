function Neighbors = find_neighbors(Chanlocs, Distance)
% Neighbors = find_neighbors(Chanlocs)
% finds all the channels that are 2 times the median minimum distance of
% each channel to the other.
%
% From sprep
arguments
    Chanlocs
    Distance = 'TwiceMedian';
end

M = channel_distances([Chanlocs.X], [Chanlocs.Y], [Chanlocs.Z]);
M(1:numel(Chanlocs)+1:numel(M)) = nan; % set diagonal to nan;

switch Distance
    case 'TwiceMedian'
        Neighbors = M <= median(min(M))*2;
    case 'Closest'
        [~, Neighbors] = min(M);
    otherwise
        error('Incorrect input for find_neighbors')
end
end


function M = channel_distances(X, Y, Z)
% distances between electrodes

M = nan(numel(X));

for Indx_Ch1 = 1:numel(X)
    for Indx_Ch2 = 1:numel(X)
        M(Indx_Ch1, Indx_Ch2) = sqrt((X(Indx_Ch2)-X(Indx_Ch1))^2 +...
            (Y(Indx_Ch2)-Y(Indx_Ch1))^2 + (Z(Indx_Ch2)-Z(Indx_Ch1))^2);
    end
end
end
