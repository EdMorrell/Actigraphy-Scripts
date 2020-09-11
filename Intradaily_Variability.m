function [IV] = Intradaily_Variability(Samples)

% --- Intradaily Variability
%     - This function produces a value for intradaily variability from
%       an array of samples (sampled at hourly intervals) (as per Witting
%       et al., 1990)
%       
%    Inputs:
%           - Samples (Row vector of samples)
%    Outputs:
%           - Intradaily Variability

%Calculates the variance of the time series derivative
derV = sum((diff(Samples).^2))/(size(Samples,2)-1);

%Calculates the variance
VarSamp = var(Samples,1);

%Divides variance of the derivative by variance to get IV
IV = derV / VarSamp;

end