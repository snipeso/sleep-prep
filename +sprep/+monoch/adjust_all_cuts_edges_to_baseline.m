function BetterCuts = adjust_all_cuts_edges_to_baseline(Signal, Cuts, Quantile, MaxPntsSearchWindow)
arguments
    Signal (1,:) % important that signal is one dimentional, and always a single row
    Cuts (1, :)
    Quantile = .5; % range around the median to wait to get back to
    MaxPntsSearchWindow = numel(Signal);
end

[Starts, Ends] = data2windows(Cuts);

BetterCuts = false(size(Cuts));

% identify within what range the signal should return to
Edges = quantile(Signal, [.5-Quantile/2 .5+Quantile/2]);

for StartIdx = 1:numel(Starts)

    [WindowStart, WindowEnd] = sprep.monoch.adjust_edges_to_baseline(Signal, Starts(StartIdx), Ends(StartIdx), ...
        Edges, MaxPntsSearchWindow);

    BetterCuts(WindowStart:WindowEnd) = 1;
end