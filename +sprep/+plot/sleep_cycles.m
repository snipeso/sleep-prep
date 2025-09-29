function sleep_cycles(Scoring, Time, Starts, Ends, ScoringIndexes, ScoringLabels)

Colors = turbo(numel(Starts)+2);
Colors([1, end], :) = [];

hold on
for StartIdx = 1:numel(Starts)
    plot(Time(Starts(StartIdx):Ends(StartIdx)), Scoring(Starts(StartIdx):Ends(StartIdx)), 'Color',Colors(StartIdx, :),'LineWidth',2)
end

yticks(ScoringIndexes)
yticklabels(ScoringLabels)
ylim([min(ScoringIndexes)-.5 max(ScoringIndexes)+.5])