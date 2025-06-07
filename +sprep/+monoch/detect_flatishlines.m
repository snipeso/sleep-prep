function Artefacts = detect_flatishlines(Signal, WindowPnts, SDThreshold)
arguments
    Signal (1, :)
    WindowPnts = 500;
    SDThreshold = .001;
end

Artefacts = movstd(Signal, WindowPnts) < SDThreshold;