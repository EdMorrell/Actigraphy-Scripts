close all
clear

f_name = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\AWD\Normal Lighting\Analysis (AWD)';

addpath('D:\Ed\Scripts\Tools')

graph_file = 'WT_Example.mat';

load([f_name filesep graph_file]);

max_val = max(max(Actogram));
Actogram = Actogram ./ max_val; 

x_vals = 0:24/size(Actogram,1):24;

%%
figure; hold on
for iCol = 1:size(Actogram,2)
    
    row_vals = Actogram(:,size(Actogram,2) - (iCol-1));
    row_vals = row_vals + iCol;
    
   plot(x_vals(1:size(x_vals,2)-1),row_vals,'k','LineWidth',1.5);
    
end

y1=get(gca,'ylim');
patch([12 24 24 12], [y1(1) y1(1) y1(2) y1(2)],...
    'k','LineStyle', 'none');
alpha(0.3)

ax = plot_prop();