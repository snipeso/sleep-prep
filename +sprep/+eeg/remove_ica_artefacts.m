function EEG = remove_ica_artefacts(EEG, ArtefactTypes)
arguments
    EEG
    ArtefactTypes = {'Muscle', 'Eye', 'Heart'}; % 1:Brain, 2:Muscle, 3:Eye, 4:Heart, 5:LineNoise, 6:ChannelNoise, 7:Other
end

%%% get artefact code
AllComponents = struct();
AllComponents.Brain = 1;
AllComponents.Muscle = 2;
AllComponents.Eye = 3;
AllComponents.Heart = 4;
AllComponents.LineNoise = 5;
AllComponents.ChannelNoise = 6;
AllComponents.Other = 7;

AllTypeNames = fieldnames(AllComponents);
if any(~ismember(ArtefactTypes, AllTypeNames))
    error('incorrect IC type. Should be: Brain, Muscle, Eye, Heart, LineNoise, ChannelNoise, Other')
end

RemoveComps = nan(size(ArtefactTypes));

for TypeIdx = 1:numel(ArtefactTypes)
    RemoveComps(TypeIdx) = AllComponents.(ArtefactTypes{TypeIdx});
end

%%% select bad components

% assign to each component the classification that was highest
TopClassifications = sprep.top_components_by_category(EEG);
Rejects = ismember(TopClassifications, RemoveComps);
EEG.reject.gcompreject = Rejects';
badcomps = find(Rejects); % sprep.plot.eeglab_scroll_ica(EEG)

% remove components from data
EEG = pop_subcomp(EEG, badcomps);


