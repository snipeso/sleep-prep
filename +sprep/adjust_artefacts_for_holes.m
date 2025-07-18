function Artefacts = adjust_artefacts_for_holes(Artefacts, Chanlocs)

Holes = sprep.utils.find_holes(Artefacts, Chanlocs);
Artefacts(:, any(Holes)) = 1;