function Artefacts = timepoints_correlated_with_artefacts(Artefacts, MostCorrCh, maxIterations)
arguments
    Artefacts
    MostCorrCh
    maxIterations = 5;
end

ArtefactsToCheck = single(Artefacts);

Iteration = 1;
while any(ArtefactsToCheck(:)==1) && Iteration <= maxIterations
    NArtifactPoints = nnz(ArtefactsToCheck);

    % selects the channel where there's an artefact; if there's more than
    % one, it jut picks the first one; if there's none, ignores
    [Max, ChannelIndex] = max(ArtefactsToCheck);

    % make nan all values selected, so they're ignored on the next while
    % loop
    linearIndices = sprep.utils.get_linear_indices(ArtefactsToCheck, ChannelIndex);
    ArtefactsToCheck(linearIndices) = nan;

    ChannelIndex(Max==0 | isnan(Max)) = nan; % might need to hack to being an extra row

    ChannelsCorrelatedToArtefacts = MostCorrCh == ChannelIndex; % this is some matlab magic that gives 1s whenever a value in a MostCorrCh is the same for that column in ChannelIndex
    
    % assign artefact status to channels that correlated with artefacts
    Artefacts(ChannelsCorrelatedToArtefacts) = 1;
    ArtefactsToCheck(ChannelsCorrelatedToArtefacts) = 1;

    disp([num2str(NArtifactPoints) ' artifact points left'])

    Iteration = Iteration+1;
end