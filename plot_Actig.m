function [fig_hand] = plot_Actig(fig_hand, Timestamps, Sensor, Lights_Off_Times,...
    Lights_On_Times,colour)

%  --- Plots Actigraphy (run as a function so can combine data from
%      different datasets to same graph)

    fig_hand = plot(Timestamps,Sensor,colour,'LineWidth', 1.25);
    y1=get(gca,'ylim');
    xlim([min(Timestamps) max(Timestamps)])
    hold on
    for iLight = 1:(size(Lights_Off_Times,2))
        patch([Lights_Off_Times(iLight) Lights_On_Times(iLight)...
                Lights_On_Times(iLight) ...
                Lights_Off_Times(iLight)],...
                [y1(1) y1(1) y1(2) y1(2)],'k','LineStyle', 'none')
            alpha(0.3)
    end
    %Plot Properties
    ax = gca;
    ax.FontName = 'Arial';
    ax.FontWeight = 'bold';
    ax.Box = 'off';
    ax.LineWidth = 1.5;  
    set(gca,'XTick',[], 'YTick', [])

end