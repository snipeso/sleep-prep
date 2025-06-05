function EEG = detrend_median(EEG, WindowLength)
arguments
    EEG
    WindowLength = 10; % seconds
end


MedFilt = medfilt1(EEG.data', WindowLength*EEG.srate)';
EEG.data = EEG.data-MedFilt;