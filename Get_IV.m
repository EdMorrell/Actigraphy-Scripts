close all
clear

%Actigraphy mat file filename
fn = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\Normal Lighting\Actigraphy.mat';

load(fn)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors = struct2cell(Actigraphy.Sensors);

clear Actigraphy

%Filename of data from second batch
fn2 = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch2\Normal Lighting\Actigraphy.mat';

load(fn2)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors2 = struct2cell(Actigraphy.Sensors);

%Combines data from batch1 and batch2
Sensors = [Sensors; Sensors2];

clear Sensors2

%%
%Runs Intradaily Variability function on each sensor
for iSensor = 1:size(Sensors,1)

    [IV] = Intradaily_Variability(Sensors{iSensor,1});
    
    IV_array(iSensor) = IV;
    
end

%% By Genotype

genotype = {'WT';'Het'};

WT = [2,7,9];
Het = [1,3,4,5,6,8];

for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_IV = IV_array(%s);',genotype{iGene},genotype{iGene}))
    
end

%Mean & SEM generator and Plotter
[mean_array,SEM_array] = Plot_SampleMeans(WT_IV,Het_IV,1,'WTs','Hets',...
    'Interdaily Stability',1,1);

% Stats
[hVal, pVal, Norm] = CompareMeans_Stats(WT_IV, Het_IV);
