function Array = close_gaps(Array, GapSize, SignalSize)
% takes ones and zeros, and removes all the itty bitty gaps so that the
% signal is more continuous, and removes all the itty bitty signals.
arguments
    Array
    GapSize = []; % in number of points
    SignalSize = [];
end


if ~isempty(GapSize)
    [Starts, Ends] = sprep.utils.data2windows(Array~=1);
    Gaps = Ends-Starts;
    Starts(Gaps<GapSize) = [];
    Ends(Gaps<GapSize) = [];
    Array = ~sprep.utils.windows2data(Starts, Ends, numel(Array));
end


if ~isempty(SignalSize)
     [Starts, Ends] = sprep.utils.data2windows(Array==1);
    Signal = Ends-Starts;
    Starts(Signal<SignalSize) = [];
    Ends(Signal<SignalSize) = [];
    Array = sprep.utils.windows2data(Starts, Ends, numel(Array));
end