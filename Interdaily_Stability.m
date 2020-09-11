function [IS,Circ_TimeStamps,Mean_Prof] = Interdaily_Stability(Samples,...
    Timestamps,Lighting_Schedule,Freq)

% ---   Interdaily Stability
%          - This function calculates Interdaily Stability from an array of
%          samples (as per Witting et al., 1990)
% Inputs:
%        - Samples: Row vector of activity samples
%        - Timestamps: Row vector of timestamps
%        - Lighting Schedule: 1 for nommal lighting
%                             0 for reverse lighting
%        - Freq: Sampling frequency (in mins)
% Outputs:
%         - Interdaily Stability
%         - Circ_Timestamps: Timestamps array in circadian time
%         - Mean Profile: A mean 24 hour profile

if nargin < 4
    Freq = mean(diff(Timestamps));
elseif nargin < 3
    error('Not enough Input Arguments')
end

%Converts timestamps into Circadian time (in mins)(0 = start of dark phase, 
%1440 = end of light phase)
if Lighting_Schedule ~= 1 && Lighting_Schedule ~= 0
    error(['Lighting_Schedule must be provided (either a 1 for '...
        'normal lighting or 0 for reverse lighting'])
elseif Lighting_Schedule == 1
    Circ_TimeStamps = Timestamps + (Freq*12);
else
    Circ_TimeStamps = Timestamps;
end
Circ_TimeStamps = mod(Circ_TimeStamps,(Freq*24));

%Creates a mean 24 hour activity profile
[xn, ~, ix] = unique(Circ_TimeStamps);
Mean_Prof = accumarray(ix,Samples,[],@mean);

%Calculates IS (variance of mean 24h profile/variance of raw data))
IS = var(Mean_Prof,1)/var(Samples,1);

end