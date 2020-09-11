close all
clear

%Filename of raw data (to be imported with ImportBehavLogger - v. slow)
fn_rawdata = 'Z:\Ed\cacna1c Batch3\Activity Monitor\Actigraphy_23_09_19.txt';

addpath('D:\Ed\Scripts\Load Data'); %Path where ImportBehavLogger is located

%Parameters
normal_lighting = false; %ie - lights on: 8:15am, lights off: 8:15pm

start_min = 189; %Minutes from Lights On/Off the recording started
                 
num_sens = 8; %Number of sensors

avoid = [3]; %Any sensors not to plot

mincr = 60; %Time increment in mins (for binning data)

%% Import Data & Plot
%Runs Import Function
[TimeStamp,S1,S2,S3,S4,S5,S6,S7,S8,LightLevel1,LightLevel2] = ...
    ImportBehavLogger_Edit(fn_rawdata,1);

Time_Secs = [10:10:size(TimeStamp,1)*10]; %Creates a timestamp array of time in 10s increments
% Plotter
count = 1;
figure;
for iSens = 1:num_sens
    if ismember(iSens,avoid) == 1
        continue
    else
        subplot(num_sens,1,count)
        eval(sprintf('plot(S%d)',iSens));
        count = count + 1;
    end
end
%% Binning 
incr = mincr * 6; %Increment (for binning sensor data) multiplied by 6 (number of samples/minute)

Time_Binned = [0:mincr:((size(TimeStamp,1)+1)/6)]; %Time in minutes
Time_Binned = Time_Binned + start_min;
% Time_Binned = Time_Binned + mincr;

for iSens = 1:num_sens
    if ismember(iSens,avoid) == 1
        continue
    else
        eval(sprintf('S_array_length = size(S%d,1);',iSens))
        bin_count = 1;
        for iTime = 1:incr:S_array_length

            if iTime + incr > S_array_length
                eval(sprintf(['Binned_Data(bin_count) = '...
                    'sum(S%d(iTime:S_array_length));'],iSens));
            else
                eval(sprintf(['Binned_Data(bin_count) = '...
                    'sum(S%d(iTime:iTime+incr));'],iSens));
                bin_count = bin_count + 1;
            end
        end
        eval(sprintf('Actigraphy.Sensors.S%d = Binned_Data;',iSens))
        clear Binned_Data
    end
end
Actigraphy.TimeStamps = Time_Binned;
%% Lights On/Off
Day_Incr = 720; %No. of mins in 12 hours

if normal_lighting
    Lights_On_Times = Day_Incr*2:Day_Incr*2:max(Time_Binned);
    Lights_Off_Times = Day_Incr:Day_Incr*2:max(Time_Binned);
else
    Lights_On_Times = Day_Incr:Day_Incr*2:max(Time_Binned);
    Lights_Off_Times = Day_Incr*2:Day_Incr*2:max(Time_Binned);
end

%Counts start and ends of recordings as first or last lights on/off
%timestamp depending on light situation when recording started
if min(Lights_On_Times) < min(Lights_Off_Times)
    Lights_Off_Times = [0 Lights_Off_Times];
end
if max(Lights_Off_Times) > max(Lights_On_Times)
    Lights_On_Times = [Lights_On_Times max(Actigraphy.TimeStamps)];
end

Actigraphy.Lights_On_Times = Lights_On_Times;
Actigraphy.Lights_Off_Times = Lights_Off_Times;

%save Actigraphy Actigraphy

%% Plotter
if ~exist('Lights_On_Times')
    Lights_On_Times = Actigraphy.Lights_On_Times;
end
if ~exist('Light_Off_Times')
    Lights_Off_Times = Actigraphy.Lights_Off_Times;
end
figure;
count = 1;
for iSens = 1:num_sens
    if ismember(iSens,avoid) == 1
        continue
    else
        subplot(num_sens,1,count)
        eval(sprintf('plot(Actigraphy.TimeStamps,Actigraphy.Sensors.S%d)',...
            iSens))
        y1=get(gca,'ylim');
        xlim([min(Actigraphy.TimeStamps) max(Actigraphy.TimeStamps)])
        hold on
        for iLight = 1:(size(Lights_Off_Times,2))
            patch([Lights_Off_Times(iLight) Lights_On_Times(iLight)...
                    Lights_On_Times(iLight) ...
                    Lights_Off_Times(iLight)],...
                    [y1(1) y1(1) y1(2) y1(2)],'k','LineStyle', 'none')
                alpha(0.3)
        end
        count = count + 1;
        %Plot Properties
        ax = gca;
        ax.FontName = 'Arial';
        ax.FontWeight = 'bold';
        ax.Box = 'off';
        ax.LineWidth = 1.5;    
    end
end