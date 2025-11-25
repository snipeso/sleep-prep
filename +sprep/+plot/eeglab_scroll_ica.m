function eeglab_scroll_ica(EEG)

StandardColor = {[.4 .4 .4]};
Pix = get(0,'screensize');

% turn red all the bad components
nComps = size(EEG.icaweights,1);
Colors = repmat(StandardColor, nComps, 1);
Colors(find(EEG.reject.gcompreject)) =  {[1, 0, 0]}; %#ok<FNDSB>

% plot in time all the components
tmpdata = eeg_getdatact(EEG, 'component', 1:nComps);
eegplot(tmpdata, 'srate', EEG.srate,  'spacing', 5, 'dispchans', 40, ...
    'winlength', 20, 'position', [0 0 Pix(3) Pix(4)*.97], ...
    'color', Colors, 'limits', [EEG.xmin EEG.xmax]*1000);