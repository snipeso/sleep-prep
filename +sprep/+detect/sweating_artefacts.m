function Artefacts = sweating_artefacts(Power, Frequencies, MaxSweatFrequency, MinFrequencyOfInterest)
arguments
    Power
    Frequencies
    MaxSweatFrequency = 0.5;
    MinFrequencyOfInterest = 0.5;
end

Power = log10(Power);

% TODO: make it take in EEG, and then calculate power 
MaxFrequencyIndex = find(Frequencies>MaxSweatFrequency, 1, 'first')-1;
LowPower = Power(:, :, 1:MaxFrequencyIndex);

Median = median(LowPower,  1, 'omitnan');

Diff = LowPower - Median;
STD = mad(Diff, 1, 1);

Threshold = Median + 5*STD;

Artefacts = LowPower > Threshold;