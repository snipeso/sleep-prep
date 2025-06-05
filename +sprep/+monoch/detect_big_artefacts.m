function Artefacts = detect_big_artefacts(Signal, VoltageThreshold, DiffVoltageThreshold, MinGap)
arguments
    Signal (1, :)
    VoltageThreshold = 1000;
    DiffVoltageThreshold = 100;
    MinGap = 1000; % points
end
% Do this step only after having removed the general trend in the signal
% and removed line noise.
% MONOCHANNEL

% find all timepoints that are really big, or really sharp
Artefacts = abs(diff([Signal, 0])) > DiffVoltageThreshold | abs(Signal) > VoltageThreshold;

[Starts, Ends] = sprep.utils.data2windows(not(Artefacts));

GapSizes = Ends-Starts;
Starts(GapSizes>MinGap) = [];
Ends(GapSizes>MinGap) = [];

for StartIdx = 1:numel(Starts)
    Artefacts(Starts(StartIdx):Ends(StartIdx)) = 1;
end
