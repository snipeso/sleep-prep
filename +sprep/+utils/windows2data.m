function Array = windows2data(Starts, Ends, nPoints)

Array = zeros(1, nPoints);

for StartIdx = 1:numel(Starts)
    Array(Starts(StartIdx):Ends(StartIdx)) = 1;
end