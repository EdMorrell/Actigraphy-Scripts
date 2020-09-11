close all
clear

% --- Sleep-Bout Analysis

fn_XC = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\AWD\Reverse Lighting\Analysis (Reverse Lighting)';

addpath('D:\Ed\Scripts\Tools')

cd(fn_XC)

%Circular shift values to have time relative to lights off?
c_shift = false;

genotype = {'WT';'Het'};

WT = {'B1_RL_S2';'B1_RL_S8';'B2_RL_S2'};
Het = {'B1_RL_S1';'B1_RL_S4';'B1_RL_S5';'B1_RL_S6';'B1_RL_S7';'B2_RL_S1'};
%%
for iGene = 1:size(genotype,1)
    
    eval(sprintf('%s_Bout_Length = zeros(size(%s,1),24);',genotype{iGene},...
        genotype{iGene}))
    eval(sprintf('%s_Bout_Num = zeros(size(%s,1),24);',genotype{iGene},...
        genotype{iGene}))
    
    eval(sprintf('an_num = size(%s,1);',genotype{iGene}));
    for iAnimal = 1:an_num
        eval(sprintf('f_name = [%s{iAnimal} ''_Bouts_Table Data.csv''];',...
            genotype{iGene}))
        T = readtable(f_name);
        
        BL_strs = T.Var5;
        BT_strs = T.Var4;
        
        %Removes lines with headers etc.
        BL_strs(1:12) = [];
        BT_strs(1:12) = [];
        
        Bout_Lengths = zeros(size(BL_strs,1),size(BL_strs,2));
        Bout_Lengths = str2double(BL_strs);
        
        Bout_Times = zeros(size(BT_strs,1),size(BT_strs,2));
        Bout_Times = str2double(BT_strs);
        
        for iCirc = 1:24
            time_ind = find(Bout_Times >= iCirc-1 & Bout_Times < iCirc);
            Circ_BLs = Bout_Lengths(time_ind);
            eval(sprintf('%s_Bout_Length(iAnimal,iCirc) = nanmean(Circ_BLs);',...
                genotype{iGene}))
            eval(sprintf('%s_Bout_Num(iAnimal,iCirc) = size(Circ_BLs,1) / 14;',...
                genotype{iGene})) %Divide by 14 to get number per day
            clear Circ_BLs time_ind
        end
        
        clear Bout_Times Bout_Lengths BL_strs BT_strs
        
    end
end

%% PLotter - Sleep Bout Length
Circ_Time = 1:24;
lights = [8.25 20.25];

WT_ML = nanmean(WT_Bout_Length,1);
Het_ML = nanmean(Het_Bout_Length,1);

WT_SL = std(WT_Bout_Length,1) / sqrt(size(WT_Bout_Length,1));
Het_SL = std(Het_Bout_Length,1) / sqrt(size(Het_Bout_Length,1));

if c_shift
    WT_ML = circshift(WT_ML, -8);
    Het_ML = circshift(Het_ML, -8);
    WT_SL = circshift(WT_SL, -8);
    Het_SL = circshift(Het_SL, -8);
    lights = [0 12];
end

figure; hold on
errorbar(Circ_Time,WT_ML,WT_SL,'--s',...
    'Color', 'k',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
errorbar(Circ_Time,Het_ML,Het_SL,'--s',...
    'Color', 'c',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','c',...
    'MarkerFaceColor','c')

y1=get(gca,'ylim');
patch([lights(1) lights(2) lights(2) lights(1)], [y1(1) y1(1) y1(2) y1(2)],...
    'k','LineStyle', 'none');
alpha(0.3)

ax = plot_prop();

%% PLotter - Sleep Bout Num
Circ_Time = 1:24;

WT_MN = nanmean(WT_Bout_Num,1);
Het_MN = nanmean(Het_Bout_Num,1);

WT_SN = std(WT_Bout_Num,1) / sqrt(size(WT_Bout_Num,1));
Het_SN = std(Het_Bout_Num,1) / sqrt(size(Het_Bout_Num,1));

if c_shift
    WT_MN = circshift(WT_MN, -8);
    Het_MN = circshift(Het_MN, -8);
    WT_SN = circshift(WT_SN, -8);
    Het_SN = circshift(Het_SN, -8);
end

figure; hold on
errorbar(Circ_Time,WT_MN,WT_SN,'--s',...
    'Color', 'k',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
errorbar(Circ_Time,Het_MN,Het_SN,'--s',...
    'Color', 'c',...
    'LineWidth',1.5,...
    'MarkerSize',6,...
    'MarkerEdgeColor','c',...
    'MarkerFaceColor','c')

y1=get(gca,'ylim');
patch([lights(1) lights(2) lights(2) lights(1)], [y1(1) y1(1) y1(2) y1(2)],...
    'k','LineStyle', 'none');
alpha(0.3)

ax = plot_prop();

%% ANOVA
Meas = {'Bout_Length';'Bout_Num'};
for iMeas = 1:size(Meas,1)
    Genotypes = [];
    G_Nums = [];
    for iGene = 1:size(genotype,1)

        eval(sprintf('Ob_Num = size(%s_%s,1);',genotype{iGene},...
            Meas{iMeas}));
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

    eval(sprintf('meas = [WT_%s;Het_%s];',Meas{iMeas},Meas{iMeas}))

    t = table(Genotypes,meas(:,1),meas(:,2),meas(:,3),meas(:,4),meas(:,5),...
        meas(:,6),meas(:,7),meas(:,8),meas(:,9),meas(:,10),meas(:,11),meas(:,12),...
        meas(:,13),meas(:,14),meas(:,15),meas(:,16),meas(:,17),meas(:,18),...
        meas(:,19),meas(:,20),meas(:,21),meas(:,22),meas(:,23),meas(:,24),...
        'VariableNames',{'Genotypes','D1','D2','D3','D4','D5','D6','D7',...
        'D8','D9','D10','D11','D12','D13','D14','D15','D16','D17','D18',...
        'D19','D20','D21','D22','D23','D24',});

    Time = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]';

    rm = fitrm(t,'D1-D24 ~ Genotypes','WithinDesign',Time,...
        'WithinModel','orthogonalcontrasts');
    
    eval(sprintf('%s_ranovatbl = ranova(rm);',Meas{iMeas}))
    
end