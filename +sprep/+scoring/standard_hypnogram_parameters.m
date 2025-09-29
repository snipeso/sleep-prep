function HypnogramSummary = standard_hypnogram_parameters(Scoring, EpochLength)
arguments
    Scoring
    EpochLength
end
% Scoring should be a numerical array such that:
    % - N3 = -3
    % - N2 = -2
    % - N1 = -1
    % - W = 0
    % - R = 1
% EpochLength is the duration in seconds of each epoch
% LightsOn/LightsOff is the epoch number that should start counting "time
% in bed"
% Output is a struct with fields:
    % - TST: total sleep time (min)
    % - SE: sleep efficiency
    % ... TODOL


HypnogramSummary = struct();


% Total sleep time
TST = sum(ismember(Scoring, [-3, -2, -1, 1])); % Pro tip: since sometimes scoring can have characters that aren't actual stages, best to always indicate exactly the stages you want, and not "not wake"
HypnogramSummary.TST = TST*EpochLength/60; % convert to minutes

% Sleep efficiency
TIB = numel(Scoring); % number of epochs
HypnogramSummary.SleepEfficiency = 100*TST/TIB;
HypnogramSummary.TIB = TIB*EpochLength/60; % convert to minutes

% Time spent and percentages of N1, N2, N3, REM
timeN1 = sum(Scoring == -1); % number of epochs of N1
HypnogramSummary.timeN1 = timeN1*EpochLength/60; % convert to minutes
HypnogramSummary.PercN1 = (timeN1/TST)*100; % percentage of N1

timeN2 = sum(Scoring == -2); % number of epochs of N2
HypnogramSummary.timeN2 = timeN2*EpochLength/60; % convert to minutes
HypnogramSummary.PercN2 = (timeN2/TST)*100; % percentage of N2

timeN3 = sum(Scoring == -3); % number of epochs of N3
HypnogramSummary.timeN3 = timeN3*EpochLength/60; % convert to minutes
HypnogramSummary.PercN3 = (timeN3/TST)*100; % percentage of N3

timeREM = sum(Scoring == 1); % number of epochs of REM
HypnogramSummary.timeREM = timeREM*EpochLength/60; % convert to minutes
HypnogramSummary.PercREM = (timeREM/TST)*100; % percentage of REM

% SOL
sleepStart = find(Scoring  ~= 0, 1, 'first');
HypnogramSummary.SOL = (sleepStart)*EpochLength/60; % convert to minutes

% REM latency 
REMStart = find(Scoring == 1, 1, 'first');
HypnogramSummary.REMLatEp = (REMStart - sleepStart); % epoch number;
HypnogramSummary.REMLat = (REMStart - sleepStart)*EpochLength/60; % convert to minutes;

% WASO
timeW = sum(Scoring == 0); % number of epochs of Wake
timeWASO = timeW - (sleepStart - 1);
HypnogramSummary.WASO = timeWASO*EpochLength/60; % convert to minutes;

% TODOL


