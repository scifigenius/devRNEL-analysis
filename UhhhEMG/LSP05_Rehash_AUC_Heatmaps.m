%% PCA of Recruitement AUC for all electrodes:
clear all;

load('D:\FigRescources\UH3\LSP05\rehash\responses_500us_1Hz_allElecsRC.mat')
response = response2; clear response2;

imuscles = [1:8];
labelmuscles = { 'VM', 'RF', 'VL', 'BF', 'ST', 'TA', 'SO', 'LG'}; %MG for LSP05 SO for LSP02b

%% NNMF for by subgroup
stimAmps = [2000 4000 6000];
C = linspecer(8,'qualitative');
% % stimAmps = [1000,3000,6000];
clear resp h;
midx = [1 3 2 4 5 6 8 7];

hF = figure; maximize;
    
% % tiledlayout(6*length(stimAmps)/length(stimAmps),length(stimAmps)*2);
cmap = magma;
colormap(cmap);
    
for ttmp = 1:6
% %     clearvars -except response ttmp hF resp labelmuscles stimAmps elecs C imuscles
    switch ttmp
    case 1
        idelecs = [7:8]
        titstring = 'Electrodes 7-8';
    case 2
        idelecs = [10:12] 
        titstring = 'Electrodes 10-12';
    case 3
        idelecs = [9 14:15]
        titstring = 'Electrodes 9, 14-15';
    case 4
        idelecs = [16]
        titstring = 'Electrode 16';
    case 5
        idelecs = [18 19]
        titstring = 'Electrodes 18-19';
    case 6
        idelecs = [20 23 24]
        titstring = 'Electrodes 20, 23-24';
    otherwise
        idelecs = [1 4 7 8];
    end
        
figure; maximize;
tiledlayout(3,2)
    for iS = 1:length(stimAmps) 
        figure; maximize;
        tiledlayout(1,2)
        resp(ttmp).elecs = idelecs;
        for iE = 1:length(idelecs)
            eI = find([response(:).elec] == idelecs(iE));
            idx = find(response(eI).StimAmps == stimAmps(iS));
            if isempty(idx)
                continue;
            end
            for iM = 1 : length(imuscles)
                resp(ttmp).stim(iS).Matrix(iE,iM) =  response(eI).muscle(imuscles(iM)).p2pResponse(idx);
            end
        end
        
        
        nexttile;
% %             subplot(length(stimAmps),2,(2*iS-1))
        if length(idelecs) <= 2
            k = 1   
        elseif  length(idelecs) > 2
            k = 3
        end
        
        [resp(ttmp).stim(iS).W,resp(ttmp).stim(iS).H] = nnmf(resp(ttmp).stim(iS).Matrix,k);
        if isempty(resp(ttmp).stim(iS).H)
            continue;
        elseif size(resp(ttmp).stim(iS).H,1) <2
            h = scatter([1:8],resp(ttmp).stim(iS).H(midx)',[],C(ttmp,:),'filled');
%             h = biplot([resp(ttmp).H'  zeros(size(resp(ttmp).H))'],...
%                 'VarLabels',labelmuscles,'Color',C(ttmp,:));
        ylabel('Component 1')
        xticks([1:8]); xticklabels(labelmuscles(midx));
        ylim([0 1]);
        else
            h = biplot(resp(ttmp).stim(iS).H','VarLabels',labelmuscles,'Color',C(ttmp,:));
            xlim([0 1]);
            ylim([0 1]);
            zlim([0 1]);
        end

        title([titstring ' | ' num2str(stimAmps(iS)/1000) 'mA']);
        
         nexttile; 
% %          subplot(length(stimAmps),2,2*iS)
        colormap(cmap);
        imagesc(resp(ttmp).stim(iS).H'); hold on;
        yticks([1:8]); yticklabels(labelmuscles);
        title([titstring ' | ' num2str(stimAmps(iS)/1000) 'mA']);
        colorbar; caxis([0,0.8]);
    end
       
 
end

%% Plot RCs 

check_p = 0.5;
check_f = 1;
msubset = [9:16];%[11 12 16 14];
% % etmp= [response.elec];
% % elecs = etmp(1:4:end);
elecs = [1 2 3 4 5 6 7 8 9 10 11 12 33 34 35] %[7 8 10 11 12 9 14 15 16 18 19 20 23 24];%[1 4 7 9 11 18 13 20 16 23 26 29];
C = linspecer(length(msubset));

for i = 1:length(msubset)
    m = msubset(i);
    for r = 1:length(elecs)
        e = find([response.elec] == elecs(r));
        tmp(e) = max(response(e).muscle(m).p2pResponse);
    end
    maxR(m) = max(tmp);
end

hF = figure;maximize;
tiledlayout(round((length(elecs))/4),4);
for r = 1:length(elecs)
    h(r) = nexttile;
    for i = 1:length(msubset)
        m = msubset(i);
    

%         h(i,r) = subplot(length(elecs),length(msubset),length(msubset)*(r-1)+i);
        e = find([response.elec] == elecs(r));
        p = plot(response(e).StimAmps/1000, response(e).muscle(m).p2pResponse,'Color',C(i,:), 'LineWidth', 2);
%         p.FaceColor = C(r,:);
        hold on;
% %         if i==1
% %             ylabel('EMG (uV)');
% %         end
% %         if r==length(elecs)
% %             xlabel('StimAmp (mA)');
% %         end
% %         if r==1
% %             title(response(e).muscle(m).Muscle_ID);
% %         end
% % %         legend(['E' num2str(elecs(r))],'Location','northwest');
        box off
% %         h(i,r).Color = 'none';
    end
    title(['Electrode: ' num2str(elecs(r))]);
     legend(labelmuscles,'Location','northwest');
    
end
% % linkaxes([h],'xy');
% % nexttile; 
% % for i=1:length(msubset)
% %     yline(i,'LineWidth', 2, 'Color',C(i,:));
% % end
% % legend(labelmuscles);
% % for i = 1:length(msubset)
% % linkaxes([h(i,:)],'xy');
% % end

tit = sgtitle(['Recruitment Curves by Muscle for Electrodes ' num2str(elecs(1)) '-' num2str(elecs(end))]);
set(0,'defaultAxesFontSize',12)
% % saveas(hF,['D:\FigRescources\UH3\LSP05\rehash\PAD\Stacked_RCs_e' num2str(elecs(1)) '-' num2str(elecs(end)) '.png'])
% % savefig(hF,['D:\FigRescources\UH3\LSP05\rehash\PAD\Stacked_RCs_e' num2str(elecs(1)) '-' num2str(elecs(end))])
% % 
% % close all;

%% Find Frequency of Activation at Threshold
for i = 1:length(response)
    for m = 1:16
        threshes(m,i) = response(i).muscle(m).threshold; %m-8
    end
end

sensethresh = [4000 4000 3500 3000 3000 2000 2000 2500 2500 2000 ...
    2000 2000 2000 2000 3000 3000 2000 2000 2000 2000 1000 1000 2000 1000 1000 2000]; %LSP05

for i = 1:length(response)
    min_thresh = min(threshes(:,i));
    sen_thresh = sensethresh(i);
    for m = 1:16
        if threshes(m,i) <= min_thresh
            count(m,i) = 1;
        else
            count(m,i) = 0;
        end
        
        if threshes(m,i) <= 2*min_thresh
            count2(m,i) = 1;
        else
            count2(m,i) = 0;
        end
        
        if threshes(m,i) <= sen_thresh
            countS(m,i) = 1;
        else
            countS(m,i) = 0;
        end
                
    end
end

musc_heat  = sum(count,2)/length(count);
musc_heat2  = sum(count2,2)/length(count2);
musc_heatS  = sum(countS,2)/length(countS);

cmap = magma;
tiledlayout(1,3)
h(1) = nexttile;
imagesc(musc_heat); 
colormap(cmap);
colorbar;
caxis([0 1]);
title('At Threshold');
yticklabels(labelmuscles);
h(2) = nexttile;
imagesc(musc_heat2); 
colormap(cmap);
colorbar
caxis([0 1]);
title('At 2x Threshold');
h(3) = nexttile;
imagesc(musc_heatS); 
colormap(cmap);
colorbar
caxis([0 1]);
title('At Sensory Threshold');
% % 
% % linkaxes([h],'xy');

%% Find Frequency of Activation at Threshold for LSP02b
% load('C:\Users\dsarma\Box\UH3_paperFigs\LSP02b Threshold Vals.mat')
labelmuscles = { 'lBF', 'lLG', 'lRF', 'lSO', 'lST', 'lVL', 'lVM', 'lTA',...
    'rBF', 'rLG', 'rRF', 'rSO', 'rST', 'rTA', 'rVL', 'rVM'};

for i = 1:size(threshesTable,2)
    for m = 1:size(threshesTable,1)
        if isnumeric(threshesTable{m,i})
            threshes(m,i) = table2array(threshesTable(m,i))
        else
            threshes(m,i) = nan(1)
        end
    end
end
    
for i = 1:size(threshes,2)
    min_thresh = min(threshes(:,i));
    sen_thresh = sensethresh(i);
    for m = 1:16
        if threshes(m,i) <= min_thresh
            count(m,i) = 1;
        else
            count(m,i) = 0;
        end
        
        if threshes(m,i) <= 2*min_thresh
            count2(m,i) = 1;
        else
            count2(m,i) = 0;
        end
        
        if threshes(m,i) <= sen_thresh
            countS(m,i) = 1;
        else
            countS(m,i) = 0;
        end
                
    end
end

musc_heat  = sum(count,2)/length(count);
musc_heat2  = sum(count2,2)/length(count2);
musc_heatS  = sum(countS,2)/length(countS);

cmap = magma;
tiledlayout(1,3)
h(1) = nexttile;
imagesc(musc_heat); 
colormap(cmap);
colorbar;
caxis([0 1]);
title('At Threshold');
yticks(1:16)
yticklabels(labelmuscles);
h(2) = nexttile;
imagesc(musc_heat2); 
colormap(cmap);
colorbar
caxis([0 1]);
title('At 2x Threshold');
yticks(1:16)
yticklabels(labelmuscles);
h(3) = nexttile;
imagesc(musc_heatS); 
colormap(cmap);
colorbar
caxis([0 1]);
title('At Sensory Threshold');
yticks(1:16)
yticklabels(labelmuscles);
% % 
% % linkaxes([h],'xy');