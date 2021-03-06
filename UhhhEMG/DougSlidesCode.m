%% Muscle List
Muscle_ID = {'Right VM', 'Right RF', 'Right VL', 'Right BF', 'Right ST', ...
    'Right TA', 'Right SO', 'Right LG', 'Left VM', 'Left RF', 'Left VL',...
    'Left BF', 'Left ST', 'Left Ham', 'Left SO', 'Left LG'};


path_Save = 'R:\users\dsarma\';
path_UH3 = 'R:\data_raw\human\uh3_stim\';
subjectName = 'LSP02b';
reportPath = ['R:\users\dsarma\' subjectName '\'];

addpath('C:\Users\dsarma\Documents\GitHub\mattools\linspecer\');

chanPort = 128; % 128 or 256 based on which Grapevine Port (B or C)
artifactBuffer = 0.005; % post stim artifact settle lag in s, so 0.01 is 10ms
rmsWindow = 0.045; % post stim RMS Window in s, so 0.05 is 50ms
% iter = 1;
C = linspecer(length(Muscle_ID),'qualitative');

%% Identify files to load
disp('Please Select the Ripple Data Folder');
[emgFilenames, emgPathname] = uigetfile([path_UH3 subjectName '\data\Open Loop\Trellis\*.nev'],'Pick files','MultiSelect', 'on');
disp(['User selected ', fullfile(emgPathname, emgFilenames)]);

trialPathname = 'R:\data_raw\human\uh3_stim\LSP02b\data\Open Loop\stim';

for f = 1:length(emgFilenames)
    trialFilenames{f} = [emgFilenames{f}(1:end-10) '.mat']; %2014a friendly, no erase function (-4 for just file, -10 for _x# thing)
end


%% Initialize Analysis Parameters

% Filtering Settings:
fs = 30e3;
lowCut = 75; %lowest frequency to pass
highCut = 7500; %highest frequency to pass
Norder = 2;
Wp = [lowCut, highCut]/(.5*fs);
[b,a]=butter(Norder, Wp);

% % Smoothing Settings:
% Fsmooth = 10; %Lowpass cutoff frequency for smoothing the rectified signal 10 vs 50
% NorderS =  2;
% dt = 1/fs;
% [bS,aS] = butter(NorderS,Fsmooth/(0.5*fs));

% Set Epoch Window for Stim-triggered Averaging
dtPre = 50e-3; % msec before stim onset 
dtPost = 100e-3; % msec after stim onset 
nSampsPre = floor(dtPre*fs);
nSampsPost = floor(dtPost*fs);


for caseIdx = 1:5
    disp(['Starting Case:' num2str(caseIdx)]);
    switch caseIdx
         case 1
            day = 2;
            elecNum = 9;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn003') & contains(trialFilenames,'Set0017'));
         case 2
            day = 2;
            elecNum = 9;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn003') & contains(trialFilenames,'Set0021'));
         case 3
            day = 2;
            elecNum = 10;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn003') & contains(trialFilenames,'Set0018'));
         case 4
            day = 2;
            elecNum = 11;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn003') & contains(trialFilenames,'Set0019'));
         case 5
            day = 2;
            elecNum = 12;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn003') & contains(trialFilenames,'Set0020'));
        case 6
            day = 3;
            elecNum = 33;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn011') & contains(trialFilenames,'Set0032'));
        case 7
            day = 3;
            elecNum = 33;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn011') & ...
                (contains(trialFilenames,'Set0033') | contains(trialFilenames,'Set0034') | contains(trialFilenames,'Set0035')));
        case 8
            day = 3;
            elecNum = 34;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn011') & ...
                (contains(trialFilenames,'Set0036') | contains(trialFilenames,'Set0037') ));
        case 9
            day = 3;
            elecNum = 35;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn011') & ...
                (contains(trialFilenames,'Set0038') | contains(trialFilenames,'Set0039') | ...
                contains(trialFilenames,'Set0040') | contains(trialFilenames,'Set0041') | ...
                contains(trialFilenames,'Set0042') | contains(trialFilenames,'Set0043')));
        case 10
            day = 4;
            elecNum = 1;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0002')));                
        case 11
            day = 4;
            elecNum = 2;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0004')));                
        case 12
            day = 4;
            elecNum = 3;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0006')));                
        case 13
            day = 4;
            elecNum = 4;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0009')));                
        case 14
            day = 4;
            elecNum = 5;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0011'))); 
        case 15
            day = 4;
            elecNum = 6;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0015')));                
        case 16
            day = 4;
            elecNum = 7;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0019')));                
        case 17
            day = 4;
            elecNum = 8;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0023')));                

        case 18
            day = 4;
            elecNum = 25;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0029')));                
        case 19
            day = 4;
            elecNum = 26;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0031')));                
        case 20
            day = 4;
            elecNum = 27;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0033')));                
        case 21
            day = 4;
            elecNum = 28;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0035')));                
        case 22
            day = 4;
            elecNum = 29;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0037'))); 
        case 23
            day = 4;
            elecNum = 30;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0039')));                
        case 24
            day = 4;
            elecNum = 31;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0041')));                
        case 25
            day = 4;
            elecNum = 32;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0043')));                
        case 26
            day = 4;
            elecNum = 33;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0046')));
        case 27
            day = 4;
            elecNum = 34;
            targMuscles = Muscle_ID;
            sittingIndices = find(contains(trialFilenames,'Ssn013') & (contains(trialFilenames,'Set0049')));             
                       
            
        
        
        case 1
            day = 7;
            elecNum = 33;
            targMuscles = {'Left ST'};
            sittingIndices = find(contains(trialFilenames,'Ssn023') & contains(trialFilenames,'Set002'));
            standingIndices = find(contains(trialFilenames,'Ssn023') & (contains(trialFilenames,'Set005') | contains(trialFilenames,'Set006')));
        case 2
            day = 7;
            elecNum = 6;
            targMuscles = {'Left ST', 'Left BF', 'Left Ham', 'Right ST'};
            sittingIndices = find(contains(trialFilenames,'Ssn023') & contains(trialFilenames,'Set003'));
            standingIndices = find(contains(trialFilenames,'Ssn024') & (contains(trialFilenames,'Set002') | contains(trialFilenames,'Set003')));

        case 3
            day = 12;
            elecNum = 1;
            targMuscles = {'Left ST', 'Left BF', 'Left Ham', 'Right ST', 'Right BF'};
            sittingIndices = find(contains(trialFilenames,'Ssn049') & contains(trialFilenames,'Set005'));
            standingIndices = find(contains(trialFilenames,'Ssn049') & contains(trialFilenames,'Set020'));

        case 4
            day = 12;
            elecNum = 2;
            targMuscles = {'Left ST', 'Left BF', 'Left Ham', 'Left VL', 'Left VM', 'Right ST', 'Right BF'};
            sittingIndices = find(contains(trialFilenames,'Ssn049') & contains(trialFilenames,'Set024'));
            standingIndices = find(contains(trialFilenames,'Ssn050') & contains(trialFilenames,'Set010'));

        case 5
            day = 12;
            elecNum = 3;
            targMuscles = {'Left ST', 'Left BF', 'Left Ham', 'Left VL', 'Left VM', 'Right ST', 'Right BF'};
            sittingIndices = find(contains(trialFilenames,'Ssn049') & contains(trialFilenames,'Set025'));
            standingIndices = find(contains(trialFilenames,'Ssn050') & contains(trialFilenames,'Set011'));
        otherwise
            disp('Wrong Case');
    end
    
    muscIndices = find(contains(Muscle_ID, targMuscles));
    hash(caseIdx).muscleNames = targMuscles;
    hash(caseIdx).Indices.muscles = muscIndices;
    hash(caseIdx).day =  day;
    hash(caseIdx).elecNum = elecNum;
    hash(caseIdx).Indices.sitting = sittingIndices;
    hash(caseIdx).Indices.standing = standingIndices;
    
    
    disp('Starting Seated Trials');
    
    fcount = 1;
    for fIdx = sittingIndices(1):sittingIndices(end)
        disp('Loading Data');
        [analogData,timeVec] = read_continuousData([emgPathname emgFilenames{fIdx}], 'raw' , chanPort+[1:length(Muscle_ID)*2]); %128 vs 256 | 8 vs. 16
        %% 'Data' -> Bipolar EMG
        for i = 1:2:size(analogData,1)
            bipolar = analogData(i:i+1,:);
            emg(round(i/2),:) = diff(flipud(bipolar));
        end
        %% Filtering (Denoising) & Smoothing
        disp('Filtering and Rectify....');
        emgF = filtfilt(b,a,emg')';  
        emgR = abs(emgF);
        
             
        %% Load Trial Stim Parameters
        disp('Loading Trial Info');
        trialInfo = load(fullfile(trialPathname,trialFilenames{fIdx}));
        % Identify Stim Events Channel
            spinalElec(fcount) = cell2mat(trialInfo.Stim_params(1).SpinalElecs);
            nevStimCh(fcount) = trialInfo.Stim_params(1).NSChannels{1,1}(1);   
            % Set Pulse Width, Stim Duration, & Stim Frequency
            stimAmp(fcount) = cell2mat(trialInfo.Stim_params(1).SpinalElecAmps);
            hash(caseIdx).sitting(fcount).stimAmp = stimAmp(fcount);
            pulseWidth(fcount) = cell2mat(trialInfo.Stim_params(1).PulseWidth); %provided in ms
            hash(caseIdx).standing(fcount).pulseWidth = pulseWidth(fcount);
            stimDuration(fcount) = cell2mat(trialInfo.Stim_params(1).Duration)/1000; %in s, provided in ms
            stimFrequency(fcount) = cell2mat(trialInfo.Stim_params(1).Frequency); %this is provided in Hz
            numStims(fcount) = stimDuration(fcount)*stimFrequency(fcount);
            stimLength = round((pulseWidth(fcount)/1000)*fs) + 2;
            hash(caseIdx).standing(fcount).stimLength = stimLength;
            
        disp('Extract Stims');    
        [stimEvts,stchannels] = read_stimEvents([emgPathname emgFilenames{fIdx}],nevStimCh(fcount));
        stims = floor(cell2mat(stimEvts)*fs);
        if length(stims) == 2*numStims(fcount)
            stimBegins = stims(1:2:end);
            stimEnds = stims(2:2:end);
        else
            stimBegins = stims;
        end
        
        hash(caseIdx).sitting(fcount).epochTimeVec = linspace(-dtPre, (stimLength/fs) + dtPost, nSampsPre + nSampsPost + stimLength);
        
        %% Epoch data into Windows 
        disp('Epoching....');
        for i = 1:size(emg,1)
            asd = emgF(i,:);
            emgStim{i} = cell2mat(arrayfun(@(x) asd((stimBegins(x)-nSampsPre):(stimBegins(x)+(stimLength+nSampsPost-1))), 1:length(stimBegins), 'UniformOutput',false)');
            qwe = emgR(i,:);
            emgStimR{i} = cell2mat(arrayfun(@(x) qwe((stimBegins(x)-nSampsPre):(stimBegins(x)+(stimLength+nSampsPost-1))), 1:length(stimBegins), 'UniformOutput',false)');
        end
        hash(caseIdx).sitting(fcount).emgStim = emgStim;
        
        epochRMS = cellfun(@rms,emgStimR,'UniformOutput', false);
        epochP2P = cellfun(@peak2peak,emgStimR,'UniformOutput', false);
        
        %% Extract "Mean" Trace & Response
        disp('Mean Traces & Responses....');
        stimEnd = nSampsPre + stimLength + artifactBuffer*fs;    
        for m = 1:length(Muscle_ID)
            % Mean Trace
            hash(caseIdx).sitting(fcount).meanTrace{m} = mean(emgStim{1,m});
            % Response
            hash(caseIdx).sitting(fcount).responseRMS(m,:) = max(epochRMS{m}(stimEnd:stimEnd+(rmsWindow*fs)));
            hash(caseIdx).sitting(fcount).responseRMSErr(m,:) = std(epochRMS{m}(stimEnd:stimEnd+(rmsWindow*fs)))/sqrt(length(epochRMS{m}(stimEnd:stimEnd+(rmsWindow*fs))));
            hash(caseIdx).sitting(fcount).responseP2P(m,:) = max(epochP2P{m}(stimEnd:stimEnd+(rmsWindow*fs)));
            hash(caseIdx).sitting(fcount).responseRMSErr(m,:) = std(epochP2P{m}(stimEnd:stimEnd+(rmsWindow*fs)))/sqrt(length(epochP2P{m}(stimEnd:stimEnd+(rmsWindow*fs))));
        end
        fcount = fcount + 1;
        
        clear emg;  
    end
    
    disp('Starting Standing Trials');
    
    fcount = 1;
    for fIdx2 = standingIndices(1):standingIndices(end)
        disp('Loading Data');
        [analogData2,timeVec2] = read_continuousData([emgPathname emgFilenames{fIdx2}], 'raw' , chanPort+[1:length(Muscle_ID)*2]); %128 vs 256 | 8 vs. 16
        %% 'Data' -> Bipolar EMG
        for i = 1:2:size(analogData2,1)
            bipolar2 = analogData2(i:i+1,:);
            emg2(round(i/2),:) = diff(flipud(bipolar2));
        end
        %% Filtering (Denoising) & Smoothing
        disp('Filtering and Rectify....');
        emg2F = filtfilt(b,a,emg2')';  
        emg2R = abs(emg2F);
        disp('Filtering and Epoching....')
        
        
        %% Load Trial Stim Parameters
        disp('Loading Trial Info');
        trialInfo = load(fullfile(trialPathname,trialFilenames{fIdx2}));
        % Identify Stim Events Channel
            spinalElec2(fcount) = cell2mat(trialInfo.Stim_params(1).SpinalElecs);
            nevStimCh2(fcount) = trialInfo.Stim_params(1).NSChannels{1,1}(1);   
            % Set Pulse Width, Stim Duration, & Stim Frequency
            stimAmp2(fcount) = cell2mat(trialInfo.Stim_params(1).SpinalElecAmps);
            hash(caseIdx).standing(fcount).stimAmp = stimAmp2(fcount);
            pulseWidth2(fcount) = cell2mat(trialInfo.Stim_params(1).PulseWidth);%provided in ms
            hash(caseIdx).standing(fcount).pulseWidth = pulseWidth2(fcount);
            stimDuration2(fcount) = cell2mat(trialInfo.Stim_params(1).Duration)/1000; %in s, provided in ms
            stimFrequency2(fcount) = cell2mat(trialInfo.Stim_params(1).Frequency); %this is provided in Hz
            numStims2(fcount) = stimDuration2(fcount)*stimFrequency2(fcount);
            stimLength2 = round((pulseWidth2(fcount)/1000)*fs) + 2;
            hash(caseIdx).standing(fcount).stimLength = stimLength2;
        
        disp('Extract Stims');      
        [stimEvts,stchannels] = read_stimEvents([emgPathname emgFilenames{fIdx2}],nevStimCh(fcount));
        stims2 = floor(cell2mat(stimEvts)*fs);
        if length(stims2) == 2*numStims(fcount)
            stimBegins = stims2(1:2:end);
            stimEnds = stims2(2:2:end);
        else
            stimBegins = stims2;
        end
        
        hash(caseIdx).standing(fcount).epochTimeVec = linspace(-dtPre, (stimLength2/fs) + dtPost, nSampsPre + nSampsPost + stimLength2);
        
        %% Epoch data into Windows 
        disp('Epoching....');
        for i = 1:size(emg2,1)
            asd = emg2F(i,:);
            emgStim2{i} = cell2mat(arrayfun(@(x) asd((stimBegins(x)-nSampsPre):(stimBegins(x)+(stimLength2+nSampsPost-1))), 1:length(stimBegins), 'UniformOutput',false)');
            qwe = emg2R(i,:);
            emgStimR2{i} = cell2mat(arrayfun(@(x) qwe((stimBegins(x)-nSampsPre):(stimBegins(x)+(stimLength+nSampsPost-1))), 1:length(stimBegins), 'UniformOutput',false)');
        end
        hash(caseIdx).standing(fcount).emgStim = emgStim2;
        
        epochRMS2 = cellfun(@rms,emgStimR2,'UniformOutput', false);
        epochP2P2 = cellfun(@peak2peak,emgStimR2,'UniformOutput', false);
        
        %% Extract "Mean" Trace & Response
        disp('Mean Traces & Responses....');
        stimEnd2 = nSampsPre + stimLength2 + artifactBuffer*fs;    
        for m = 1:length(Muscle_ID)
            % Mean Trace
            hash(caseIdx).standing(fcount).meanTrace{m} = mean(emgStim2{1,m});
            % Response
            hash(caseIdx).standing(fcount).responseRMS(m,:) = max(epochRMS2{m}(stimEnd2:stimEnd2+(rmsWindow*fs)));
            hash(caseIdx).standing(fcount).responseRMSErr(m,:) = std(epochRMS2{m}(stimEnd2:stimEnd2+(rmsWindow*fs)))/sqrt(length(epochRMS2{m}(stimEnd2:stimEnd2+(rmsWindow*fs))));
            hash(caseIdx).standing(fcount).responseP2P(m,:) = max(epochP2P2{m}(stimEnd2:stimEnd2+(rmsWindow*fs)));
            hash(caseIdx).standing(fcount).responseRMSErr(m,:) = std(epochP2P2{m}(stimEnd2:stimEnd2+(rmsWindow*fs)))/sqrt(length(epochP2P2{m}(stimEnd2:stimEnd2+(rmsWindow*fs))));
        end
        fcount = fcount + 1;
        
        clear emg2;  
    end  
end

