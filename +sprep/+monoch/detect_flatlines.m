function Flatlines = detect_flatlines(Signal, MaxContiguous, MinGap)
arguments
    Signal (1, :)
    MaxContiguous = 2;
    MinGap = [];
end

% figure out all the flat lines in the signal
Derivative = diff(Signal);
[Starts, Ends] = sprep.utils.data2windows(Derivative==0);
Ends = Ends+1; % since it's the derivative, fencepost problem

% ignore the microscopic ones
Durations = Ends-Starts;
Ignore = Durations<=MaxContiguous;

Starts(Ignore) = [];
Ends(Ignore) = [];

% turn back into a vector
Flatlines = zeros(size(Signal));
for StartIdx = 1:numel(Starts)
    Flatlines(Starts(StartIdx):Ends(StartIdx)) = 1;
end


if ~isempty(MinGap)
    % remove small gaps
    GapEnds = Starts(2:end);
    GapStarts = Ends(1:end-1);
    Gaps = GapEnds-GapStarts;
    GapStarts(Gaps>MinGap) = [];
    GapEnds(Gaps>MinGap) = [];

    for StartIdx = 1:numel(GapStarts)
        Flatlines(GapStarts(StartIdx):GapEnds(StartIdx)) = 1;
    end
end