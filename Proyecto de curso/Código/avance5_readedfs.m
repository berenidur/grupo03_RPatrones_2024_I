% if exist('nenf')
%     clc;clearvars -except sk_enf sk_Fs sk_chann sk_label sk_edf nenf;close all;
%     nayuda=nenf;
% else
%     clc;clear;close all;
%     sk_enf=[];
%     sk_Fs=[];
%     sk_chann=[];
%     sk_label=[];
%     sk_edf=[];
%     nayuda=1;
% end
if exist('nenf')
    clc;clearvars -except sk_enf sk_Fs sk_chann sk_label sk_edf nenf T;close all;
    nayuda=nenf;
else
    clc;clear;close all;
    load('sk_chann');
    load('sk_label');
    load('sk_edf');
    T=readtable('sk_table.txt');
    nayuda=1;
end

lista=readlines('descargar0.txt');

% for nenf=1:length(lista)
for nenf=nayuda:length(lista)
    enf=lista(nenf);
    fprintf(strcat('data/',enf,'\t\tnenf=',num2str(nenf),'\n'))
% end

if sum(ismember(sk_chann,enf)) + sum(ismember(sk_edf,enf)) + sum(ismember(sk_label,enf)) + sum(ismember(T.sk_enf,enf))
    fprintf('Skipping...\n\n');
    continue
end

%%
chann='F4C4';
Fs=512;
secs=30;

% n=2;
% for n=[1,2,3,5,10,11]
% disp(n);

if isfile(strcat('DATA_seconds\',enf,'_',num2str(secs),'sec_',chann,'.mat'))
% if 0
    continue
else

A = readtable(strcat('data\',enf,'.txt'),VariableNamingRule="preserve",Delimiter="\t");   % Reads Annotation File and save in A
try
[hdr, record] = edfread(strcat('data\',enf,'.edf'));
catch
    sk_edf=[sk_edf;enf];
    fprintf('Skipping edf...\n\n');
    continue;
end
%%
try
cellconcat=[hdr.transducer; hdr.units; num2cell(hdr.physicalMin); num2cell(hdr.physicalMax); num2cell(hdr.digitalMin); num2cell(hdr.digitalMax); hdr.prefilter; num2cell(hdr.samples); num2cell(hdr.frequency)]';
columnames=["transducer";"units";"physicalMin";"physicalMax";"digitalMin";"digitalMax";"prefilter";"samples";"frequency"];
showinfo=cell2table(cellconcat,'RowNames',hdr.label,'VariableNames',columnames);
catch
    sk_label=[sk_label;enf];
    fprintf('Skipping label...\n\n');
    continue;
end

% keyboard;
%%
% disp('Saving record and hdr files'); save(strcat('Record&hdr\record_',enf,'_',chann,'.mat'),'record','-v7.3');
% save(strcat('Record&hdr\hdr_',enf,'_',chann,'.mat'),'hdr'); disp('Saved')

%disp('Loading files');load('Record&hdr\record_n11.mat')                % Load edf data
%load('Record&hdr\hdr_n11.mat'); disp('Loaded')                         % Load header file
%% Find index for the channel C4A1 or C3A2
Index_c = find(contains(hdr.label,chann)); %ind del canal
if isempty(Index_c)
    sk_chann=[sk_chann;enf];
    fprintf('Skipping chann...\n\n');
    continue;
end

%% Get EEG corresponding to the channel C4A1 or C3A2
val = record(Index_c,:);  % data del canal

%% Get whether the event occuring is A or B
Event = A{:,"Event"};

%% Set sampling frequency dependent on the considered subject (set manually)
% SampleRate = 512;
SampleRate = showinfo{chann,"frequency"};
disp(['SampleRate = ',num2str(SampleRate)])
if SampleRate ~= Fs
    sk_enf=[sk_enf;enf];
    sk_Fs=[sk_Fs;SampleRate];
    fprintf('Skipping Fs...\n\n');
    continue;
end
Min_Duration = secs*SampleRate;                % Minimum duration for segmenting (30 sec)
%% Get the duration of the 'Event' from annotation file
Dur = A{:,"Duration[s]"};

%% Get the time stamp of the 'Event' from annotation file
try
    Time = A{:,"Time[hh:mm:ss]"};
catch ME
    Time = A{:,"Time [hh:mm:ss]"};
end
%% Get start time from the header file
Start_Time_cell = split(hdr.starttime,'.'); % hora a la que empieza la data

%% Get time in seconds (Consider this as reference i.e. 0th instance)
Start_time = str2num(Start_Time_cell{1})*3600+str2num(Start_Time_cell{2})*60+str2num(Start_Time_cell{3});

%% Get time matrix and index by subtracting the reference point
Time_sec = [];
for i = 1:length(Time)
    %T_cell = split(Time{i},'.');
    try
    T_cell = split(char(Time(i),'hh:mm:ss'),':');
    catch
        T_cell = split(Time{i},'.');
    end
    hh = str2num(T_cell{1});
    mm = str2num(T_cell{2});
    ss = str2num(T_cell{3});
    if hh < 12
        hh = hh+24;
    end
    Time_sec = [Time_sec; hh*3600+mm*60+ss];
end
Time_sec_loc = Time_sec-Start_time;

%% 
% Get indices
fprintf('\tGetting samples\n');
Indexsleep = find(contains(Event,'SLEEP-S1'));
Indexwake = find(contains(Event,'SLEEP-S0'));
Index0=Indexsleep(1);

% find the first index of the last 'SLEEP-S0' block

% Find the differences between successive indexes
diffs = diff(Indexwake);

% Identify where the differences are greater than 1 (indicating a break between blocks)
breaks = find(diffs > 1);
if length(breaks) > 1
    last_block_start = breaks(end) + 1;
else
    last_block_start = 1;  % Handle the case where there is only one block
end
Indexend = Indexwake(last_block_start);

% Get timestamp in seconds for A1
Idx_0 = Time_sec_loc(Index0);
Idx_end = Time_sec_loc(Indexend);
total_secs=Idx_end-Idx_0;

% Get duration for A1 and multiply by sampling frequency
Dur_secs = total_secs*SampleRate;

% Empty set for storing A1 phase data
% Extracting the data using time stamp in seconds and duration
Data_unshape = val(Idx_0*SampleRate+1:Idx_0*SampleRate+Dur_secs);

Data_secs = [];
% Segmenting the data in 2 seconds chunks
% Rejecting the extra data that cannot fit in sec duration
l = floor(length(Data_unshape)/Min_Duration);
Data_unshape = Data_unshape(1:l*Min_Duration);        % descarta sobrantes
Data_unshape1 = transpose(reshape(Data_unshape,[Min_Duration,l]));
Data_secs = [Data_secs;Data_unshape1];

% [a, b] = size(Data_secs);
% Data_secs = [Data_secs];

%% Save 
fprintf('\tSaving data...\n')
save(strcat('DATA_seconds\',enf,'_',num2str(secs),'sec_',chann,'.mat'),'Data_secs','chann','Fs','enf','-v7');
fprintf('Done\n\n')
end
end

sk_table=table(sk_enf,sk_Fs);
writetable(sk_table)
type 'sk_table.txt'
save('sk_chann','sk_chann');
save('sk_label','sk_label');
save('sk_edf','sk_edf');