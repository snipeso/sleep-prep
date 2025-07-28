function [Starts, Ends] = detect_sleep_cycles(Scoring, EpochLength, MinTime)
arguments
    Scoring
    EpochLength
    MinTime = 10; % minutes
end

% ignore n1 and wake by assigning them to the previous stage
Scoring(1) = -2; % assign first score to NREM sleep so that the next code can reassign wake and n1 appropriately
Scoring = sprep.scoring.reassign_n1(Scoring, -1);
Scoring = sprep.scoring.reassign_n1(Scoring, 0);
Scoring(Scoring<0) = -1;

% NREM bouts
[Starts, Ends] = sprep.utils.data2windows(Scoring<=0);

Durations = (Ends+1-Starts)*EpochLength;

Troughs = Starts(Durations>MinTime*60); % start of NREM/wake

Starts = Troughs;
Ends = Troughs(2:end)-1;
Ends(end+1) = numel(Scoring);

Starts(Starts==numel(Scoring)) = []; % exclude start if its the last epoch
Ends = unique(Ends); % in case adding numel(scoring) duplicated the end