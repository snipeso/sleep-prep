function [WindowStart, WindowEnd] = adjust_edges_to_baseline(Signal, StartCut, EndCut, Quantile, MaxPntsSearchWindow)
arguments
    Signal (1,:) % important that signal is one dimentional, and always a single row
    StartCut
    EndCut
    Quantile = .5; % range around the median to wait to get back to
    MaxPntsSearchWindow = numel(Signal);
end
% [WindowStart, WindowEnd] = return_to_baseline(Signal, StartCut, EndCut, Quantile, MaxPntsSearchWindow)
%
% resets the edges of window so that they are around the median of the
% whole signal. 

% identify within what range the signal should return to
Edges = quantile(Signal, [.5-Quantile/2 .5+Quantile/2]);

% identify the first points from the original cut that returns to baseline
Indices = 1:numel(Signal); 
BaselineSignal =  Signal >=Edges(1) & Signal <=Edges(2); % all the points within the identified range
MaxWindow = (Indices >= StartCut-MaxPntsSearchWindow/2) & (Indices <= EndCut + MaxPntsSearchWindow/2); % all the points within an acceptable distance from the original cut

WindowStart = find(Indices<=StartCut & BaselineSignal & MaxWindow, 1, 'last');
WindowEnd = find(Indices>=EndCut & BaselineSignal & MaxWindow, 1, 'first');

% if unsuccessful, just just use the whole max window
if isempty(WindowStart)
    WindowStart = find(MaxWindow, 1, 'first');
end

if isempty(WindowEnd)
    WindowEnd = find(Indices, 1, 'last');
end


