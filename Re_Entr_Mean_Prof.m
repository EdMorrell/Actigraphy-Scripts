close all
clear

nl_fn = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\Normal Lighting\Actigraphy.mat';
rl_fn = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\Reverse Lighting\Actigraphy.mat';

%Params
freq = 60;

load(rl_fn)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors = struct2cell(Actigraphy.Sensors);

%% Mean Profile
% Gets a mean 24 hour profile for each sensor
for iSensor = 1:size(Sensors,1)

    [IS,Circ_TimeStamps,Mean_Prof] = Interdaily_Stability(Sensors{iSensor,1},...
        Actigraphy.TimeStamps,0, freq);
    
    Mean_Prof_array(iSensor,:) = Mean_Prof';
    
end

clear Actigraphy Sensors

%% 
load(nl_fn)

Sensors = struct2cell(Actigraphy.Sensors);

for iSensor = 1:size(Sensors,1)
    
    Circ_TimeStamps = Actigraphy.TimeStamps + (freq*12);
    Circ_TimeStamps = mod(Circ_TimeStamps,(freq*24));
    [xn, ~, ix] = unique(Circ_TimeStamps);
    
    iday_end = find(ix == 24);
    iday_end = [1, iday_end'];
    for iDay = 1:(size(iday_end,2)-1)
        
        day_prof = Sensors{iSensor,1}(1,iday_end(iDay):iday_end(iDay+1)-1);
        if ~isequal(size(day_prof,2)-1,size(Mean_Prof,1))
            sh_Mean_Prof = Mean_Prof((size(Mean_Prof,1)- ...
                size(day_prof,2)+1):size(Mean_Prof,1))';
            error_dist = sum(sqrt((day_prof - sh_Mean_Prof).^2))/...
                size(day_prof,2);
            Daily_Diff(iDay) = error_dist;
        else
            error_dist = sum(sqrt((day_prof - Mean_Prof).^2))/...
                size(day_prof,2);
            Daily_Diff(iDay) = error_dist;
        end
        
    end
    
    Daily_Diffs{iSensor} = Daily_Diff;
end

%%
num_sens = size(Daily_Diffs,2);
day_array = 1:size(Daily_Diff,2);
figure;
for iSensor = 1:size(Daily_Diffs,2)
    
    subplot(num_sens,1,iSensor);
    plot(day_array,Daily_Diffs{1,iSensor},'k','LineWidth',1.5)
    
    %Plot Properties
    ax = gca;
    ax.FontName = 'Arial';
    ax.FontWeight = 'bold';
    ax.Box = 'off';
    ax.LineWidth = 1.5;  
    set(gca, 'YTick', [])
    ylim([0 max(max(Daily_Diffs{1,iSensor},2))]);
    
end
%%
thold = 0.75;

for iSensor = 1:size(Daily_Diffs,2)
   
    b_thold_pos = find(Daily_Diffs{1,iSensor} < ...
        max(max(Daily_Diffs{1,iSensor},2)) * thold);
    
    if isempty(min(b_thold_pos))
        b_thold(iSensor) = NaN;
    else
        b_thold(iSensor) = min(b_thold_pos);
    end
    
end