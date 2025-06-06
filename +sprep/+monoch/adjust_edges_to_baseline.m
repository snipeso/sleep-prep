function [WindowStart, WindowEnd] = adjust_edges_to_baseline(Signal, StartCut, EndCut, Edges, MaxPntsSearchWindow)
arguments
    Signal (1,:) % important that signal is one dimentional, and always a single row
    StartCut
    EndCut
    Edges = quantile(Signal, [.5-Quantile/2 .5+Quantile/2]);
    MaxPntsSearchWindow = numel(Signal);
end
% [WindowStart, WindowEnd] = return_to_baseline(Signal, StartCut, EndCut, Quantile, MaxPntsSearchWindow)
%
% resets the edges of window so that they are around the median of the
% whole signal.

% identify the first points from the original cut that returns to baseline
Indices = 1:numel(Signal);
BaselineSignal =  Signal >=Edges(1) & Signal <=Edges(2); % all the points within the identified range

MinStart = StartCut-MaxPntsSearchWindow/2;
if MinStart <1
    MinStart = 1;
end

MaxEnd = EndCut + MaxPntsSearchWindow/2';
if MaxEnd > numel(Signal)
    MaxEnd = numel(Signal);
end

WindowStart = find(Indices<=StartCut & BaselineSignal, 1, 'last');
WindowEnd = find(Indices>=EndCut & BaselineSignal, 1, 'first');


% Make sure it's not outside maximum allowable extension range. If it is,
% then just take the edges that minimize the distance from the middle of
% the signal

Midpoint = mean(Edges); % the theoretical 0 of the channel. Using this instead of actual 0, because there might be large offsets

if isempty(WindowStart) || WindowStart < MinStart
    [~, Idx] = min(abs(Signal(MinStart:StartCut))-Midpoint);
    WindowStart = Idx+MinStart-1;
end

if isempty(WindowEnd) || WindowEnd > MaxEnd
    [~, Idx] = min(abs(Signal(EndCut:MaxEnd))-Midpoint);
    WindowEnd = Idx+EndCut-1;
end



