function eeglab_scroll(EEG, Data2, WindowLength, Spacing)
arguments
    EEG
    Data2 = [];
    WindowLength = 20;
    Spacing = 50;
end

Pix = get(0,'screensize');


if ~isempty(Data2)
  eegplot(EEG.data, 'srate', EEG.srate, 'spacing', Spacing, 'winlength', WindowLength, ...
        'command', 'm.TMPREJ = TMPREJ', 'data2', Data2, 'position', [0 0 Pix(3) Pix(4)], 'eloc_file', EEG.chanlocs)
else
  eegplot(EEG.data, 'srate', EEG.srate, 'spacing', Spacing, 'winlength', WindowLength, ...
        'command', 'm.TMPREJ = TMPREJ', 'position', [0 0 Pix(3) Pix(4)], 'eloc_file', EEG.chanlocs)    
end
