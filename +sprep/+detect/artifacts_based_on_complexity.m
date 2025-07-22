function Artefacts = artifacts_based_on_complexity(EEG, ArtefactCandidates, HighPassFilt, LZCWindow, LZCThreshold)
arguments
    EEG
    ArtefactCandidates
    HighPassFilt = 4;
    LZCWindow = 2; % seconds
    LZCThreshold = 2; % complexity units?
end

LZCType = 'primitive';
LZCNormalization = true;

LZCWindow = LZCWindow*EEG.srate;
nPoints = size(EEG.data, 2);

% filter out low frequencies that artificially tip the scales of LZC
EEG = pop_reref(EEG, []);
EEG = pop_eegfiltnew(EEG, HighPassFilt, []);

Artefacts = false(size(ArtefactCandidates));

for ChannelIdx = 1:size(ArtefactCandidates, 1)
    [Starts, Ends] = sprep.utils.data2windows(ArtefactCandidates(ChannelIdx, :));

    Rejects = 0;
    for StartIdx = 1:numel(Starts)

        % only take first 2 seconds from artifact; this is because LCZ calc
        % time explodes with longer windows, and is less reliable with
        % shorter windows
        
        End = (Starts(StartIdx)+LZCWindow);
        if End > Ends(StartIdx)
            End = Ends(StartIdx);
    elseif End > nPoints
            End = nPoints;
        end
        Snippet = EEG.data(ChannelIdx, Starts(StartIdx):End);

        LZC = sprep.external.calc_lz_complexity(Snippet>0, LZCType, LZCNormalization);

        if LZC > LZCThreshold
            Artefacts(ChannelIdx, Starts(StartIdx):Ends(StartIdx)) = true;
        else
            Rejects = Rejects +1;
        end
    end

    disp(['For Ch', num2str(ChannelIdx), ' ', num2str(Rejects),'/',num2str(numel(Starts)), ' below threshold'])
end