close all
clear

% --- Mean Sleep Latency (Onset & Offset relative to lights on % off)

fn_XC = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\AWD\Reverse Lighting\Analysis (Reverse Lighting)';

addpath('D:\Ed\Scripts\Tools')

cd(fn_XC)

genotype = {'WT';'Het'};

WT = {'B1_RL_S2';'B1_RL_S8';'B2_RL_S2'};
Het = {'B1_RL_S1';'B1_RL_S4';'B1_RL_S5';'B1_RL_S6';'B1_RL_S7';'B2_RL_S1'};

lights_on = 20.25;
lights_off = 8.25;
%%
for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_OffSets = zeros(size(%s,1),13);',genotype{iGene},...
        genotype{iGene}))
    eval(sprintf('%s_OnSets = zeros(size(%s,1),13);',genotype{iGene},...
        genotype{iGene}))
    
    eval(sprintf('an_num = size(%s,1);',genotype{iGene}));
    for iAnimal = 1:an_num
        %Offsets (Essentially sleep onset latency)
        eval(sprintf('f_off = [%s{iAnimal} ''_Offsets_Table Data.csv''];',...
            genotype{iGene}))
        TOff = readtable(f_off);
        
        offsets_strs = TOff.Var3;
        offsets_strs(1:5) = [];
        offsets_strs(14) = []; %Removes last data point as recording stopped prior to lights on
        
        offsets = zeros(size(offsets_strs,1),size(offsets_strs,2));
        offsets = str2double(offsets_strs);
        
        eval(sprintf('%s_OffSets(iAnimal,:) = offsets;',genotype{iGene}))
        
        clear offsets offsets_strs
        
        %Onsets - Sleep Offset
        eval(sprintf('f_on = [%s{iAnimal} ''_Onsets_Table Data.csv''];',...
            genotype{iGene}))
        TOn = readtable(f_on);
        
        onsets_strs = TOn.Var3;
        onsets_strs(1:5) = [];
        onsets_strs(1) = []; %Removes first data point as recording started after lights off
        
        onsets = zeros(size(onsets_strs,1),size(onsets_strs,2));
        onsets = str2double(onsets_strs); 
        
        eval(sprintf('%s_OnSets(iAnimal,:) = onsets;',genotype{iGene}))
        
        clear onsets onsets_strs
    end
    
    eval(sprintf('%s_OnSets = %s_OnSets - lights_off;',genotype{iGene},...
        genotype{iGene}))
    eval(sprintf('%s_OffSets = %s_OffSets - lights_on;',genotype{iGene},...
        genotype{iGene}))
    
end

%% Plotter
WOS = nanmean(WT_OffSets,2) * 60;
HOS = nanmean(Het_OffSets,2) * 60;

[~,~] = Plot_SampleMeans(WOS',...
    HOS',1,'WT','Het','Sleep Onset Latency',1,1);

[hOff, pOff,~] = CompareMeans_Stats(WOS,HOS);

WOnS = nanmean(WT_OnSets,2) * 60;
HOnS = nanmean(Het_OnSets,2) * 60;

[~,~] = Plot_SampleMeans(WOnS',...
    HOnS',1,'WT','Het','Activity Onset Latency',1,1);

[hOn, pOn,~] = CompareMeans_Stats(WOnS,HOnS);

