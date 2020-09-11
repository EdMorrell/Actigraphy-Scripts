close all
clear

%Filename of raw data (to be imported with ImportBehavLogger)
fn_rawdata = 'Z:\Ed\cacna1c Batch3\Activity Monitor\Actigraphy_24_02_20.txt';
addpath('D:\Ed\Scripts\Load Data'); %Path where ImportBehavLogger_Edit is found

%Save Directory for AWD file
save_dir = 'D:\Ed\Data\Matlab Outputs\Actigraphy\Batch1\AWD\Reverse Lighting';

%Parameters

%Start date and time of rec
date = '10-feb-2020'; %In form: dd-mon-yyyy (lower-case month)
time = '10:45'; %In form: hh:mm (24 hour time)

%Prefix name to save every file as (name in form: save_name_S#.)
save_name = 'Batch1_RL';

num_sens = 8; %Number of sensors

avoid = [3,4,5,6,7,8]; %Any sensors not to use

incr = (1/6)*4; %Time increment in mins * 4;

%% Runs Import Function
[TimeStamp,S1,S2,S3,S4,S5,S6,S7,S8,LightLevel1,LightLevel2] = ...
    ImportBehavLogger_Edit(fn_rawdata,1);

%% Creates .awd file for each
cd(save_dir)
for iSens = 1:num_sens
        if ismember(iSens,avoid) == 1
            continue
        else
            eval(sprintf('Sens = S%d;',iSens))

            fileID = fopen(sprintf('%s_S%d.awd',save_name,iSens),'w');
            
            formatSpec = '%d \n';
            fprintf(fileID,'Sensor%d\n',iSens);
            fprintf(fileID,'%s\n',date);
            fprintf(fileID,'%s\n',time);
            fprintf(fileID,'%d\n',incr);
            fprintf(fileID,'0\n');
            fprintf(fileID,'0\n');
            fprintf(fileID,'0\n');
            fprintf(fileID,formatSpec,Sens);
            fclose(fileID);
        end
    end