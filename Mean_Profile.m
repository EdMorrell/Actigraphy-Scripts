close all
clear

%Actigraphy mat file filename
fn = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\Reverse Lighting\Actigraphy.mat';

load(fn)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors = struct2cell(Actigraphy.Sensors);

clear Actigraphy

%Filename of data from second batch
fn2 = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch2\Reverse Lighting\Actigraphy.mat';

load(fn2)

%Extracts sensor data from Actigraphy structure to a cell array
Sensors2 = struct2cell(Actigraphy.Sensors);

%Combines data from batch1 and batch2
Sensors = [Sensors; Sensors2];

clear Sensors2

%Params
freq = 60;

genotype = {'WT';'Het'};

WT = [2,7,9];
Het = [1,3,4,5,6,8];
%% Mean Profile
% Gets a mean 24 hour profile for each animal
for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_MP = zeros(size(%s,1),24);',genotype{iGene},...
        genotype{iGene}))
    
    eval(sprintf('an_num = size(%s,2);',genotype{iGene}));
    for iAnimal = 1:an_num
        eval(sprintf('Sens_Array = Sensors{%s(1,iAnimal),1};',genotype{iGene}))
        [IS,Circ_TimeStamps,Mean_Prof] = Interdaily_Stability(Sens_Array,...
            Actigraphy.TimeStamps,0, freq);
        eval(sprintf('%s_MP(iAnimal,:) = Mean_Prof'';',genotype{iGene}))
    end
end

%% Plotter

%% PLotter - Sleep Bout Length
Circ_Time = 1:24;

WT_MMP = nanmean(WT_MP,1);
Het_MMP = nanmean(Het_MP,1);

WT_SMP = std(WT_MP,1) / sqrt(size(WT_MP,1));
Het_SMP = std(Het_MP,1) / sqrt(size(Het_MP,1));

figure; hold on
errorbar(Circ_Time,WT_MMP,WT_SMP,'--s',...
    'Color', 'k',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
errorbar(Circ_Time,Het_MMP,Het_SMP,'--s',...
    'Color', 'c',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','c',...
    'MarkerFaceColor','c')

y1=get(gca,'ylim');
patch([0 12 12 0], [y1(1) y1(1) y1(2) y1(2)],...
    'k','LineStyle', 'none');
alpha(0.3)

ax = plot_prop();