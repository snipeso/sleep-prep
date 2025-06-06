function NewSignal = pad_windows(Signal, Padding)
arguments
Signal % should be a boolean array
Padding
end

NewSignal = zeros(size(Signal));

[Starts, Ends] = sprep.utils.data2windows(Signal);

Starts = Starts-Padding;
Ends = Ends+Padding;

% deal with edges
Starts(Starts<=0) = 1;
Ends(Ends>numel(Signal)) = numel(Signal);

for StartIdx = 1:numel(Starts)
    NewSignal(Starts(StartIdx):Ends(StartIdx)) = 1;
end

