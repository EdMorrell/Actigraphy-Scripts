close all
clear

%Actigraphy mat file filename
fn = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\Reverse Lighting\Actigraphy.mat';

load(fn)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors = struct2cell(Actigraphy.Sensors);
Timestamps = cell(size(Sensors,1),1);
for iCell = 1:size(Timestamps,1)
    Timestamps{iCell,1} = Actigraphy.TimeStamps;
end

clear Actigraphy

%Filename of data from second batch
fn2 = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch2\Reverse Lighting\Actigraphy.mat';

load(fn2)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors2 = struct2cell(Actigraphy.Sensors);
Timestamps2 = cell(size(Sensors,1),1);
for iCell = 1:size(Timestamps2,1)
    Timestamps2{iCell,1} = Actigraphy.TimeStamps;
end

%Combines data from batch1 and batch2
Sensors = [Sensors; Sensors2];
Timestamps = [Timestamps; Timestamps2];

clear Sensors2 Timestamps2

%% IS
%Runs Interdaily Stability function on each sensor

for iSensor = 1:size(Sensors,1)

    [IS,Circ_TimeStamps] = Interdaily_Stability(Sensors{iSensor,1},...
        Timestamps{iSensor},0, 60);
    
    IS_array(iSensor) = IS;
    
end

%% By Genotype

genotype = {'WT';'Het'};

WT = [2,7,9];
Het = [1,3,4,5,6,8];

for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_IS = IS_array(%s);',genotype{iGene},genotype{iGene}))
    
end

%Mean & SEM generator and Plotter
[mean_array,SEM_array] = Plot_SampleMeans(WT_IS,Het_IS,1,'WTs','Hets',...
    'Interdaily Stability',1,1);

% Stats
[hVal, pVal, Norm] = CompareMeans_Stats(WT_IS, Het_IS);
