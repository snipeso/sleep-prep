function ScoringInTime = scoring2time(Scoring, EpochLength, SampleRate, NPoints)

if islogical(Scoring)
ScoringInTime = false(1, NPoints);
else
ScoringInTime = nan(1, NPoints);
end

ScoringRep = repmat(Scoring, EpochLength*SampleRate, 1);
ScoringRep = reshape(ScoringRep, [], 1);
ScoringInTime(1:numel(ScoringRep)) = ScoringRep;
ScoringInTime = ScoringInTime(1:NPoints);

% TODO: rename everything to something more generic