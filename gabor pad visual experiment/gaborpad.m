function [result] = gaborpad(TotalTrials, numberOfLines)
% this function take the correct rate of response and the reaction time
% against to the variation of degrees from 0, 45, and 90
% for a total trials of 180, each control degree like 0, 45, and 90 takes
% 60 trials. 
% the numberOfLines is the way to make the Gabors more or less beautiful
% 
% After 180 trials, the function will graph plots for correct rate and
% reaction time

clear all; close all; clc;

if nargin<1 % Because I don't have any input for the function, just in case
    % it will crash, this help to put things in line.
  TotalTrials = 800;
  numberOfLines = 101;% equavalent to numberOfPoints
end

experimentMatrix = zeros(TotalTrials, 8); %super preallocation
% 3 conditions: 0, 45, 90 degrees. Each condition has 30 trials
conditions = [0,45,90,135];
% make 60 long vector of each condition
conditionMatrix = repmat(conditions,[TotalTrials/4,1]);
% variations from 0, 45, or 90, or 135
% -5    -4    -3    -2    -1     1     2     3     4     5
% zero is defined in the later program because they need to be specified
% according to the match rate [.75,.25].
deviationAway = linspace(-5,5,11);
deviationAway(deviationAway==0) = [];
% control the matching rate so that will be 75% - 80% the comparison gabor
% is different from the control one
matchRate = datasample([0,1],TotalTrials/4,'Weights',[0.75,0.25]);
idx0 = Shuffle(matchRate);
idx45 = Shuffle(matchRate);
idx90 = Shuffle(matchRate);
idx135 = Shuffle(matchRate);
matchRateMatrix = [idx0;idx45;idx90;idx135]';
TEMP = zeros(TotalTrials/4,4);% preallocation
% the algorithm I design to make the comparison gabors
for cases = 1:size(matchRateMatrix,2)
    % there are 3 cases, 0,45, and 90 degrees. Find all the cases that is
    % not mataching to the control
    % put in deviation gabors to this places
    % store the bars of the histogram
    % if these bars looks skewed or not uniform, redo the whole process
    % if not, shuffle them twice and store them
    
    k = find(matchRateMatrix(:,cases) == 0);
    temp{cases} = datasample(deviationAway,length(k),'Weights',ones(10,1)./length(k));
    [O,P]=hist(temp{cases});
    GG = std(O);
    TTT = zeros(TotalTrials/4,1);

    while std(O)>5.7
        temp{cases} = datasample(deviationAway,length(k),'Weights',ones(10,1)./length(k));
        [O,P]=hist(temp{cases});
        GG = std(O);
    end

    temp{cases} = Shuffle(Shuffle(temp{cases}));
    idxT = matchRateMatrix(:,cases);
    TTT(idxT == 0) = temp{cases};
    TEMP(:,cases) = TTT;
end
Patting = [ones(100,1);zeros(100,1)];

experimentMatrix(:,8) = [Patting;Patting;Patting;Patting];
compareMatrix = conditionMatrix + TEMP;
% putting the 3 most crucial things together
experimentMatrix(:,1) = conditionMatrix(:);
experimentMatrix(:,2) = compareMatrix(:);
experimentMatrix(:,3) = matchRateMatrix(:);
% graphic boundaries
xbound = -2; ybound = 2;

% initializing the mother screen
scrSz = get(0,'ScreenSize');
f1 = figure;
set(f1,'Position',scrSz); % full screen the display
set(f1,'ToolBar','none')
set(f1,'MenuBar','none')
h(1) = text(0, 0.7, 'You will see 2 Gabors in the experiment');hold on
h(2)= text(0,0.5,'The lines could be tilted from 0,45, or 90 degree for a little bit');
h(3)=text(0,0.3,'Your task is to tell us whether the two Gabors are in the same degree');% adding more texts, you don't need to hold on
h(4)=text(0,0.1,'press 1 when it is the same, and press 4 when it is not the same');
h(5)=text(0,-0.1,'Press any keys to move on when you are ready');
set(gcf,'Color',[1,1,1])
axis off
hold off
keyPress = zeros(TotalTrials, 1);% preallocation
reactionTime = zeros(TotalTrials,1);% preallocation
pause % waiting for responses
for ii = 1:length(experimentMatrix);
    
    % Gaborcontrol are those 0,45, and 90 degree gabors
    [Gaborcontrol,Guassian] = GaborMaking(experimentMatrix(ii,1),xbound,ybound,numberOfLines);
    % Gaborcompare are those deviated from 0, 45, and 90 degree gabors,
    % but 20% of the time, they are not deviated
    Gaborcompare = GaborMaking(experimentMatrix(ii,2),xbound,ybound,numberOfLines);
   
if experimentMatrix(ii,8) ==0
 % put control and comparison together
    Gabor2 = cat(2,Gaborcontrol,Gaborcompare); % real stimuli
    GuassianMask = cat(2,Guassian, Guassian); % mask flash before stimuli
    imagesc(GuassianMask);% I don't use hold on because I don't want to
    axis equal;
    axis off;
    colormap(gray(256));
    pause(0.5 + rand)
    imagesc(Gabor2)
    axis equal;
    axis off;
    colormap(gray(256));
else
    Gabor2 = cat(1, Gaborcontrol,Gaborcompare);
    GuassianMask = cat(1, Guassian, Guassian);
    imagesc(GuassianMask);% I don't use hold on because I don't want to
    axis equal;
    axis off;
    colormap(gray(256));
    pause(0.5 + rand)
    imagesc(Gabor2)
    axis equal;
    axis off;
    colormap(gray(256));
end
    tic;pause
    keyPress(ii) = get(f1,'CurrentCharacter');% store the pressed key
    % I choose 1 and 4 for specific reasons
    reactionTime(ii) = toc;% store reaction time
    pause(0.2+rand)
end
pause
close% close the full screen experiment
experimentMatrix(:,4) = keyPress;
experimentMatrix(:,5) = reactionTime;
% the assigned value for key 1 is always less than the assigned value for
% key 4 in PC and MAC, thus, the mea of all the 1s and 4s will always
% inbetween 1 and 4. So by simply checking whether the pressed key is less
% than the the mean, it is key 1, and vis versa. The response are encoded
% into 0 or 1 in this method
% And by comparing the encoded performance to the design matrix, I could
% easily calculate correct or not

experimentMatrix(:,6) = (experimentMatrix(:,4) < mean(experimentMatrix(:,4)));
experimentMatrix(:,7) = experimentMatrix(:,3) == experimentMatrix(:,6);
% way to group the target data
[B, Idx] = sort(experimentMatrix(:,2));% sort the comparison gabors, and have
% the indeces of the sorting, so that I could project the indeces to the
% other vectors
T(:,1) = experimentMatrix(:,7);
T(:,1) = T(Idx,1);
T(:,2) = experimentMatrix(:,5);
T(:,2) = T(Idx,2);
cnt = 1; % counting 
M = unique(B); % so to have the unique cases with no repeated cases
CorrectRate = zeros(1,length(M));% preallocation
MeanReactionTime = zeros(1,length(M));% preallocation

% algorithm to calculate the correction rate and reaction time in terms of
% group of deviation of the control degrees
for ii = 1:length(M)
    % this the mean of responses in terms of 1 and 0, according to its
    % groups. It means that I only take the mean when all the responses
    % belong to the same comparison gabor. Same for reaction time
    CorrectRate(cnt) = mean(T(B==M(ii),1));
    MeanReactionTime(cnt) = mean(T(B==M(ii),2));
    cnt = cnt +1; % start from 1
end
% plot the data (correct rate)
figure
subplot(4,1,1)
v(1) = bar(M(1:11), CorrectRate(1:11));
ax = gca;
set(ax,'XTick', [-5:5],'XTickLabel',{'-5','-4','-3','-2','-1',...
    '0','1','2','3','4','5'},'YTick',[0,0.5,1],'YTickLabel',{'0','0.5','1'})
xlabel('degree variation')
ylabel('correct rate')
title('correct rate as a function of degree variated from the control')
subplot(4,1,2)
v(2) = bar(M(12:22),CorrectRate(12:22));
ax = gca;
set(ax,'XTick', [40:50],'XTickLabel',{'40','41','42','43','44',...
    '45','46','47','48','49','50'},'YTick',[0,0.5,1],'YTickLabel',{'0','0.5','1'})
xlabel('degree variation')
ylabel('correct rate')
title('correct rate as a function of degree variated from the control')
subplot(4,1,3)
v(3) = bar(M(23:33),CorrectRate(23:33));
ax = gca;
set(ax,'XTick', [85:95],'XTickLabel',{'85','86','87','88','89','90',...
    '91','92','93','94','95'},'YTick',[0,0.5,1],'YTickLabel',{'0','0.5','1'})
xlabel('degree variation')
ylabel('correct rate')
title('correct rate as a function of degree variated from the control')
subplot(4,1,4)
v(4) = bar(M(34:44),CorrectRate(34:44));
ax = gca;
set(ax,'XTick', [85:95],'XTickLabel',{'130','131','132','133','134','135',...
    '136','137','138','139','140'},'YTick',[0,0.5,1],'YTickLabel',{'0','0.5','1'})
xlabel('degree variation')
ylabel('correct rate')
title('correct rate as a function of degree variated from the control')
% plot the data (reaction time)
figure
subplot(4,1,1)
v(1) = bar(M(1:11), MeanReactionTime(1:11));
ax = gca;
set(ax,'XTick', [-5:5],'XTickLabel',{'-5','-4','-3','-2','-1',...
    '0','1','2','3','4','5'})
xlabel('degree variation')
ylabel('mean reaction time')
title('reaction time as a function of degree variated from the control')
subplot(4,1,2)
v(2) = bar(M(12:22),MeanReactionTime(12:22));
ax = gca;
set(ax,'XTick', [40:50],'XTickLabel',{'40','41','42','43','44',...
    '45','46','47','48','49','50'})
xlabel('degree variation')
ylabel('mean reaction time')
title('reaction time as a function of degree variated from the control')
subplot(4,1,3)
v(3) = bar(M(23:33),MeanReactionTime(23:33));
ax = gca;
set(ax,'XTick', [85:95],'XTickLabel',{'85','86','87','88','89','90',...
    '91','92','93','94','95'})
xlabel('degree variation')
ylabel('mean reaction time')
title('reaction time as a function of degree variated from the control')
subplot(4,1,4)
v(4) = bar(M(34:44),MeanReactionTime(34:44));
ax = gca;
set(ax,'XTick', [85:95],'XTickLabel',{'130','131','132','133','134','135',...
    '136','137','138','139','140'})
xlabel('degree variation')
ylabel('mean reaction time')
title('reaction time as a function of degree variated from the control')

result.experimentMatrix = experimentMatrix;
function [ Gabor,Gaussian ] = GaborMaking(angle, xbound, ybound, numberOfPoints)
% if you don't understand this, go check your class notes
sf = 10;
angle = 90 - angle;
[X, Y] = meshgrid(linspace(xbound, ybound,numberOfPoints));

% Gaussian envelope
Gaussian = exp(-X.^ 2-Y.^2);
% Bar grids
[X, Y] = meshgrid(linspace(-pi,pi, numberOfPoints));
ramp = cos(angle*pi/180)*X - sin(angle*pi/180)*Y;
orientedGrating = sin(sf* ramp);
Gabor = Gaussian .* orientedGrating;



   













