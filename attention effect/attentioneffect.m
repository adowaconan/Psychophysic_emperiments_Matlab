function [result] = attentioneffect(totalTrial)

% the way to use this function is either: 
% %% 1. type result = attentioneffect in the command window
% %% 2. click run button

% This function will:
% 1. Give you 160 trials of experiments
% 2. 80 of them are endogeneous conditions
% 3. 80 of them are exogeneous conditions
% 4. For the endogeneous conditions, you will have 40 trials of vertical
% , 40 trials of horizontal.
% 5. Same as the exogeneous conditions. 
% 6. If the initiation of the function is slow, please be patient, because
% the first part of the function is to create all the 160 stimuli. 
% 7. After you finish all the 160 trials, the function will also report the
% result of your behavioral performance. 


clear all;clc;

if nargin<1 % Because I don't have any input for the function, just in case
    % it will crash, this help to put things in line.
  totalTrial = 160;
end

% create stimuli for endogenous condition
endogenousTrials = zeros(totalTrial/2,7);
% indicator of conditions: 1=endogenous
endogenousTrials(:,1) = ones(totalTrial/2,1);
% indicator of lay outs: 1=vertical, 2=horizotal
endogenousTrials(:,2) = [ones(totalTrial/4,1);ones(totalTrial/4,1) + 1];
% indicator for position of the stimulus is presented 
% for vertical and horizotal layouts, only 1 and 2 will be used, 
% 1 mean one of the rectangles, and 2 means the other rectangle
endogenousTrials(:,3) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
% indicator of the the position of the arrows
endogenousTrials(:,5) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
kd = length(find(endogenousTrials(:,3) == endogenousTrials(:,5)));
% Just calculate the match rate of the stimulus position and the cue
kd = kd/90;
% the algorithm makes sure the arrow cue matches the position of the
% stimulus around 60% to 80% of the time
while kd < .6 || kd>.8
    endogenousTrials(:,5) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
    kd = length(find(endogenousTrials(:,3) == endogenousTrials(:,5)));
    kd = kd/90;
end
% indicator of whether the arrow cue matches to the position of presenting
% stimulus
endogenousTrials(:,4) = endogenousTrials(:,3) == endogenousTrials(:,5);

% Create stimuli for exdogenous condition
exdogenousTrials = zeros(totalTrial/2,7);
% indicator of conditions:2=exdogenous
exdogenousTrials(:,1) = ones(totalTrial/2,1) + 1;
% indicator of lay outs: 1=vertical, 2=horizotal, 3=mixed
exdogenousTrials(:,2) = [ones(totalTrial/4,1);ones(totalTrial/4,1) + 1];
% indicator for true condition 
% for vertical and horizotal layouts, only 1 and 2 will be used, 
% 1 means of the rectangles, and 2 means the other rectangle
exdogenousTrials(:,3) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
% indicator of whether it is a valid cue:1=valid,0=not valid
exdogenousTrials(:,4) = datasample([1,0],totalTrial/2, 'Weights',[.50,.50]);
% indicator of the valid trials
exdogenousTrials(:,5) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
kc = length(find(exdogenousTrials(:,3) == exdogenousTrials(:,5)));
kc = kc/90;
while kc <.6 || kc>.8
    exdogenousTrials(:,5) = datasample([1,2],totalTrial/2, 'Weights',[.5,.5]);
    kc = length(find(exdogenousTrials(:,3) == exdogenousTrials(:,5)));
    kc = kc/90;
end
exdogenousTrials(:,4) = exdogenousTrials(:,3) == exdogenousTrials(:,5);



% save my stimuli to the structure of result
result.kd = kd;
result.kc = kc;
% This is the matrix that has everything!!!!!!!!!!!!!!Wait, not true.
result.experimentMatrix = [endogenousTrials;exdogenousTrials];

% The following experiment is to replicate Poserner paradigm findings
% The stimuli are presented on a black background and you will focus on the
% middle fixation point. 
% One of the factor that influence the model is the cue driving effect
% start the experiment: endogeneous trials
scrSz = get(0,'ScreenSize');
f1 = figure;
set(f1,'Position',scrSz); % full screen the display
set(f1,'ToolBar','none')
set(f1,'MenuBar','none')
% giving the subject some instructions
h(1) = text(0, 0.7, 'You are going to see 2 rectangles, and focus on the red cross, fixation point');hold on
h(2)= text(0,0.5,'Please respond by pressing your mouse on the red cross');
h(3)=text(0,0.3,'Please respond as fast as possible right after the flash of yellow color');% adding more texts, you don't need to hold on
h(4)=text(0,0.1,'The arrows pointing to the rectangles do not nessarily correct cues');
h(5)=text(0,-0.1,'Please do not press your mouse before the yellow flash -- press "g" to start');
xlim([0 2]); ylim([-1 1]);
set(h, 'color',[1,1,1])
set(gcf,'Color',[0,0,0])
axis off
hold off
pause
% preallocation for the storing matrices
keyPress = zeros(totalTrial/2, 2);
reactionTime = zeros(totalTrial/2,1);
% use another function in this function to test
for ii =1:totalTrial/2
    % the function takes
    % 1: whether it is vertical, horizontal, or mixed layout
    % 2: position of the presenting stimulus
    % 3: position of the arrow as a cue
    
    % the interval between trials are randomized between 400ms to 1000ms
    stopBy = randi([400,1000],1)/1000;
    pause(stopBy)
    clf
    endogenous(endogenousTrials(ii,2),endogenousTrials(ii,3),endogenousTrials(ii,5))
    tic
    %pause
    keyPress(ii,:) = ginput(1);
    reactionTime(ii) = toc;
    
end
endogenousTrials(:,6:7) = keyPress;
endogenousTrials(:,8) = reactionTime;
result.endogenousTrials = endogenousTrials;
pause(0.5)
close% close the full screen experiment


% start the exdogeneous trials
scrSz = get(0,'ScreenSize');
f1 = figure;
set(f1,'Position',scrSz); % full screen the display
set(f1,'ToolBar','none')
set(f1,'MenuBar','none')
% giving the subject some instructions
h(1) = text(0, 0.7, 'You will see 2 rectangles.And focus on the red cross, fixation point. Get a mouse! Or just use your mouse pad');hold on
h(2)= text(0,0.5,'Please respond by pressing your mouse on the red cross');
h(3)=text(0,0.3,'Please respond as fast as possible right after the flash of YELLOW color');% adding more texts, you don't need to hold on
h(4)=text(0,0.1,'A flash of red indicates the cue');
h(5)=text(0,-0.1,'Please do not respond before the yellow flash -- press "g" to start');
xlim([0 2]); ylim([-1 1]);
set(h, 'color',[1,1,1])
set(gcf,'Color',[0,0,0])
axis off
hold off
pause 
% preallocation for the storing matrices
keyPress = zeros(totalTrial/2, 2);
reactionTime = zeros(totalTrial/2,1);
% use another function in this function to test
for ii =1:totalTrial/2
    % the interval between trials are randomized between 400ms to 1000ms
    stopBy = randi([400,1000],1)/1000;
    pause(stopBy)
    clf
    % The function takes 3 arguments:
    % 1:whether it is vertial, horizotal, or mixed layout
    % 2:position of the yellow flash
    % 3:position of the red flash
    exdogenous(exdogenousTrials(ii,2),exdogenousTrials(ii,3),exdogenousTrials(ii,5))
    tic
    %pause
    keyPress(ii,:) = ginput(1);
    reactionTime(ii) = toc;
    
end
exdogenousTrials(:,6:7) = keyPress;
exdogenousTrials(:,8) = reactionTime;
pause(0.5)
close all% close the full screen experiment


result.exdogenousTrials = exdogenousTrials;
% now the "result" has all the results

% here comes to data analysis: 2X2 avona 
% dependent variable: reaction time
% independent variables: cue, attention shift direction
% cue: endogenous vs exogenous
% attention shift direction: vertical vs horizontal
result.totalMatrix = [endogenousTrials;exdogenousTrials];
[result.p,result.table] = anovan(result.totalMatrix(:,8),...
    {result.totalMatrix(:,2) result.totalMatrix(:,3) result.totalMatrix(:,4)},...
    'model',3,'varnames',...
    strvcat('[endo,exo]','[vertical horizontal]','[match mismatch]'));


function [ ] = endogenous( three,present,arrowPos )
% The funtion takes 3 arguments: [1or2or3] meaning whether the trial is
% vertical, horizontal, or mixed layout. Each category has 30 trials. 
% The second argument is the position of the stimulus
% The third argument is the position of the arrows
waitingTime = randi([50,500],1)/1000;
flashingTime = randi([18,38],1)/1000;
if three ==1 % vertical
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.5 0.2 1 0.7];
    retanglePosition(2,:) = [0.5 1.1 1 0.7];
    arrowPosition(1,:) = [0.3,0.55];
    arrowPosition(2,:) = [0.3, 1.45];
    
    % axices
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    % draw 2 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    % make the stimulus one of the rectangles
    stimulus = retangle(present);
    % set up the existing arrow, and hold its position as a constant cue
    arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\rightarrow');
    set(arrow, 'LineWidth',2,'FontSize',16,'Color',[1,1,1])
    
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)% I test this myself
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    
elseif three == 2 % horizontal
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.1 0.65 0.8 0.7];
    retanglePosition(2,:) = [1.1 0.65 0.8 0.7];
    arrowPosition(1,:) = [0.5,1.45];
    arrowPosition(2,:) = [1.5,1.45];
    
    % axices
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    % draw 2 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    % make the stimulus one of the 2 rectangles
    stimulus = retangle(present); 
    % set up the arrow, and make it a constant cue
    arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\downarrow');
    set(arrow, 'LineWidth',2,'FontSize',16,'Color',[1,1,1])
    
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    
elseif three == 3 % mixed
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.1 0.1 0.8 0.7];
    retanglePosition(2,:) = [1.1 0.1 0.8 0.7];
    retanglePosition(3,:) = [0.1 1.1 0.8 0.7];
    retanglePosition(4,:) = [1.1 1.1 0.8 0.7];
    arrowPosition(1,:) = [0.9,0.95];
    arrowPosition(2,:) = [1,0.95];
    arrowPosition(3,:) = [0.9,1.1];
    arrowPosition(4,:) = [1,1.1];
    
    % axices
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    % draw 4 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(3) = rectangle('Position',retanglePosition(3,:));
    set(retangle(3),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(4) = rectangle('Position',retanglePosition(4,:));
    set(retangle(4),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    % the way to handle arrow directions
    if mod(arrowPos,2)
        arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\leftarrow');
        set(arrow, 'LineWidth',2,'FontSize',16,'Color',[1,1,1])
    else
        arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\rightarrow');
        set(arrow, 'LineWidth',2,'FontSize',16,'Color',[1,1,1])
    end
    % make stimulus one of the rectangles
    stimulus = retangle(present); 
    
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)
    set(stimulus, 'Facecolor', [0,0,0],'EdgeColor',[1,1,1])

end




function [  ] = exdogenous( three,StimulPos,flashing )
%This function also takes 3 arguments:
% 1: [1or2or3] means whether it is vertical, horizontal, or mixed layout
% 2: the position of the stimulus -- yellow flash
% 3: the postion of the red flash
waitingTime = randi([1000,1500],1)/1000;% time between the cue and the flash
flashingTime = randi([18,38],1)/1000;% time of each of the flash
if three ==1% vertical
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.5 0.2 1 0.7];
    retanglePosition(2,:) = [0.5 1.1 1 0.7];
    
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    ExdoCue = retangle(flashing);
    stimulus = retangle(StimulPos);
    pause(waitingTime+rand/10)
    set(ExdoCue, 'Facecolor', 'r')
    pause(flashingTime)
    set(ExdoCue,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus,'Facecolor',[1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)
    set(stimulus,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    
        
elseif three ==2% horizontal
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.1 0.65 0.8 0.7];
    retanglePosition(2,:) = [1.1 0.65 0.8 0.7];
    
    
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    
    ExdoCue = retangle(flashing);
    stimulus = retangle(StimulPos);
    pause(waitingTime+rand/10)
    set(ExdoCue, 'Facecolor', 'r','EdgeColor',[1,1,1])
    pause(flashingTime)
    set(ExdoCue,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus,'Facecolor',[1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)
    set(stimulus,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    
elseif three == 3% mixed
    FixationPoint = plot(1,1,'r*');hold on
    set(FixationPoint,'Marker','+','MarkerSize',12,'LineWidth',3)
    % position coordinates
    retanglePosition(1,:) = [0.1 0.1 0.8 0.7];
    retanglePosition(2,:) = [1.1 0.1 0.8 0.7];
    retanglePosition(3,:) = [0.1 1.1 0.8 0.7];
    retanglePosition(4,:) = [1.1 1.1 0.8 0.7];
   
   
    xlim([0,2]); ylim([0,2]);
    set(gcf,'Color',[0,0,0]);axis off;hold off
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(3) = rectangle('Position',retanglePosition(3,:));
    set(retangle(3),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    retangle(4) = rectangle('Position',retanglePosition(4,:));
    set(retangle(4),'Facecolor', [0,0,0],'EdgeColor',[1,1,1])
    
    ExdoCue = retangle(flashing);
    stimulus = retangle(StimulPos);
    pause(waitingTime+rand/10)
    set(ExdoCue, 'Facecolor', 'r','EdgeColor',[1,1,1])
    pause(flashingTime)
    set(ExdoCue,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    pause(waitingTime)
    set(stimulus,'Facecolor',[1,1,0],'EdgeColor',[1,1,1])
    pause(flashingTime)
    set(stimulus,'Facecolor',[0,0,0],'EdgeColor',[1,1,1])
    
end



















