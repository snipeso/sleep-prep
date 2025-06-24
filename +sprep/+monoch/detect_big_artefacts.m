function Artefacts = detect_big_artefacts(Signal, VoltageThreshold, DiffVoltageThreshold, Padding)
arguments
    Signal (1, :)
    VoltageThreshold = 1000;
    DiffVoltageThreshold = 100;
    Padding = 100; % points
end
% Do this step only after having removed the general trend in the signal
% and removed line noise. Padding especially important for sharp artefacts,
% since the can have small ripples around them after filtering.
% MONOCHANNEL

% find all timepoints that are really big, or really sharp
Artefacts = abs(diff([Signal, 0])) > DiffVoltageThreshold | abs(Signal) > VoltageThreshold;

Artefacts = sprep.utils.pad_windows(Artefacts, Padding);
