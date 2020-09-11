close all
clear

fn_XC = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\AWD\Normal Lighting\Analysis (AWD)';

addpath('D:\Ed\Scripts\Tools')

cd(fn_XC)

genotype = {'WT';'Het'};

WT = {'B1_NL_S2';'B1_NL_S8';'B2_NL_S2'};
Het = {'B1_NL_S1';'B1_NL_S4';'B1_NL_S5';'B1_NL_S6';'B1_NL_S7';'B2_NL_S1'};
%%
for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_OffSets = zeros(size(%s,1),28);',genotype{iGene},...
        genotype{iGene}))
    
    eval(sprintf('an_num = size(%s,1);',genotype{iGene}));
    for iAnimal = 1:an_num
        eval(sprintf('f_name = [%s{iAnimal} ''_Offsets_Table Data.csv''];',...
            genotype{iGene}))
        T = readtable(f_name);
        
        offsets_strs = T.Var3;
        offsets_strs(1:5) = [];
        
        offsets = zeros(size(offsets_strs,1),size(offsets_strs,2));
        offsets = str2double(offsets_strs);
        
        %Takes 24 off those at start to make it easier to subtract value
        %from 8:15 (lights on)
        pre_midn = find(offsets > 12);
        offsets(pre_midn) = offsets(pre_midn) - 24;
        
        eval(sprintf('%s_OffSets(iAnimal,:) = offsets;',genotype{iGene}))
        
        clear T offsets
    end
    
end

%% PLotter
Day_Range = 15;

Days = 1:Day_Range;

WT_OffSets = (WT_OffSets - 8.25);
Het_OffSets = (Het_OffSets - 8.25);

WT_MO = nanmean(WT_OffSets,1);
Het_MO = nanmean(Het_OffSets,1);

WT_SO = std(WT_OffSets,1) / sqrt(size(WT_OffSets,1));
Het_SO = std(Het_OffSets,1) / sqrt(size(Het_OffSets,1));

figure; hold on
errorbar(Days,WT_MO(1:Day_Range),WT_SO(1:Day_Range),'--s',...
    'Color', 'k',...
    'LineWidth',2,...
    'MarkerSize',6,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
errorbar(Days,Het_MO(1:Day_Range),Het_SO(1:Day_Range),'--s',...
    'Color', 'c',...
    'LineWidth',2,...
    'MarkerSize',6,...
    'MarkerEdgeColor','c',...
    'MarkerFaceColor','c')

ax = plot_prop();

%% ANOVA
Genotypes = [];
G_Nums = [];
for iGene = 1:size(genotype,1)
    
    eval(sprintf('Ob_Num = size(%s_OffSets,1);',genotype{iGene}));
    iStrings = cell(1,Ob_Num);
    eval(sprintf('iStrings(:) = {''%s''};',genotype{iGene}))
    if iGene == 1
        Nums = zeros(Ob_Num,1);
    else
        Nums = ones(Ob_Num,1);
    end
    
    Genotypes = [Genotypes;iStrings'];
    G_Nums = [G_Nums; Nums];
end

meas = [WT_OffSets;Het_OffSets];

t = table(Genotypes,meas(:,1),meas(:,2),meas(:,3),meas(:,4),meas(:,5),...
    meas(:,6),meas(:,7),meas(:,8),meas(:,9),meas(:,10),meas(:,11),meas(:,12),...
    meas(:,13),meas(:,14),meas(:,15),...
    'VariableNames',{'Genotypes','D1','D2','D3','D4','D5','D6','D7',...
    'D8','D9','D10','D11','D12','D13','D14','D15'});

Time = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]';

rm = fitrm(t,'D1-D15 ~ Genotypes','WithinDesign',Time,...
    'WithinModel','orthogonalcontrasts');
ranovatbl = ranova(rm);