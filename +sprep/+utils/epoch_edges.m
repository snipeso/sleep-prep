function [Starts, Ends] = epoch_edges(WindowLength, SampleRate, nPoints)


Starts = unique([1:WindowLength*SampleRate:nPoints, nPoints]);
Ends = Starts(2:end)-1;
Starts = Starts(1:end-1);