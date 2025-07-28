function sleep_cycles(Scoring, Time, Starts, Ends)

Color1 = [1 0 0];
Color2 = [0 0 1];

hold on
for StartIdx = 1:numel(Starts)
    if mod(StartIdx, 2) == 1
        Color = Color1;
    else
        Color = Color2;
    end

    plot(Time(Starts(StartIdx):Ends(StartIdx)), Scoring(Starts(StartIdx):Ends(StartIdx)), 'Color',Color,'LineWidth',2)
end