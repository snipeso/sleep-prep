function Top = top_components_by_category(EEG, Spread)
% Top = top_components_by_category(Components, Spread)
%
% function to identify the components that are definitely a given category,
% based on it being Spread times more than the next highest component
%
% From iota-neurophys by Sophia Snipes, 2024
arguments
    EEG
    Spread = 0; % just take the highest in every category
end

  Components = EEG.etc.ic_classification.ICLabel.classifications;

nComponents = size(Components, 1);
Top = nan(nComponents, 1);

for Indx_Co = 1:nComponents
    Comps = Components(Indx_Co, :);
    [Max, Indx] = max(Comps);
    Comps(Indx) = [];

    if all(Max > Spread*Comps)
        Top(Indx_Co) = Indx;
    end
end