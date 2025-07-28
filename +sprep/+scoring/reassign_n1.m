function Scoring = reassign_n1(Scoring, N1Score)
arguments
    Scoring
    N1Score = -1;
end

[Starts, Ends] = sprep.utils.data2windows(Scoring==N1Score);

for StartIdx = 1:numel(Starts)
    if Starts(StartIdx)>1
    Scoring(Starts(StartIdx):Ends(StartIdx)) = Scoring(Starts(StartIdx)-1);
    else
        Scoring(Starts(StartIdx):Ends(StartIdx)) = 0;
    end
end


