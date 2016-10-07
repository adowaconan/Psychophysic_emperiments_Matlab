function [result] = visualsearch(setSize)
% This function will:
% 1. Test the pop-out effect and conjuntion search
% 2. Collect data of reaction time, hit, and correct reject
% 3. Calculate the performance
% 4. Plot the mean of performance in different set size

% The function will run automatically after you press run, or type things
% like: "Result = assignment4" in the command window. 

% If you assign the function to some variable, the variable will be storing
% all the data you will need for analyzing the performance

if nargin<1 % Because I don't have any input for the function, just in case
    % it will crash, this help to put things in line.
   setSize= [4,8,12,16];
end
FontSize = 12;
totalTrial = 200;% In total, subjects are doing 200 trials of mixing: 1)pop-out
% 2)conjunction search
format bank
a = [10,10,10,10];% the criteria for make the stimuli matrix

while a < 40 
    % the experiment has levels: set size in 4,8,12,and 16, and I want to
    % make sure there are at least 30 trials per level when the target is
    % present
    [setSizeVec, SSVidx] = datasample(setSize,totalTrial, 'Weights', ones(4,1)./4);
    % the vector of set size is sampled from [4,8,12,16], and all items
    % have equal chance to be selected (25%)
    [CvsFVec, CVFidx] = datasample([1,0], totalTrial, 'Weights',[.5,.5]);
    % the conjunction vs feacture search vector is sampled from [1,0], 1
    % means conjunction search and 0 means feature search, both item has
    % equal chance to be selected
    [PresentVSAbsent, PVAidx] = datasample([1,0],totalTrial, 'Weights',[.8,.2]);
    % the present vs absent vector is sampled from [1,0], 1 means present,
    % and 0 means absent. I want to make 80% of the target to be present
    % and 20% of time, target is not present
    experimentMatrix = [setSizeVec', CvsFVec', PresentVSAbsent'];
    % put the design vector and asemble them into the design matrix
    k = find(experimentMatrix(:,3) ==1);
    % find the trials that the target is present
    T = experimentMatrix(:,1);
    % look into the four set size, and count how many items in each level
    [a,b] = hist(T(k),setSize);
    % a will be the counting of items in each level, if one of the level
    % has less than 30 items, the whole process will re-run
end
result.experimentMatrix = experimentMatrix;% store the design matrix to the result
% initializing the mother screen
scrSz = get(0,'ScreenSize');
f1 = figure;
set(f1,'Position',scrSz); % full screen the display
set(f1,'ToolBar','none')
set(f1,'MenuBar','none')
% giving the subject some instructions
h(1) = text(0, 0.7, 'You will see X or O in the experiment.');hold on
h(2)= text(0,0.5,'They will be present in different color.');
h(3)=text(0,0.3,'Your task is to tell us whether the red X is present');% adding more texts, you don't need to hold on
h(4)=text(0,0.1,'press 1 when it is present, and press 4 when it is not present');
h(5)=text(0,-0.1,'Press any keys to move on when you are ready');
% be specific of the target, the red X
G=plot(0.7,-0.3,'rx');
set(G,'MarkerSize', FontSize,'LineWidth',4)
set(h,'fontsize',20,'color', 'k')
set(gcf,'Color',[1,1,1])
axis off
hold off
pause
% preallocation for the storing matrices
keyPress = zeros(totalTrial, 1);
reactionTime = zeros(totalTrial,1);
% use another function in this function to test
for ii =1:totalTrial
    % the function XO will read the design matrix and graph the figure
    % according to the variables I define:set size, whether it is
    % conjunction or feature search, whether the target is present or
    % absense
    projectXO(experimentMatrix(ii,1),experimentMatrix(ii,2),experimentMatrix(ii,3))
    tic% start the timer right after the graph is present
    pause% althoug I pause the time, the timer is still running, but it does
    % not matter, because this could be the systematic time that I could
    % subtract at the end of the analysis
    keyPress(ii) = get(f1,'CurrentCharacter');% store the pressed key
    % I choose 1 and 4 for specific reasons
    reactionTime(ii) = toc;% stop the timer for each trial
end
pause
close% close the full screen experiment

% the assigned value for key 1 is always less than the assigned value for
% key 4 in PC and MAC, thus, the mea of all the 1s and 4s will always
% inbetween 1 and 4. So by simply checking whether the pressed key is less
% than the the mean, it is key 1, and vis versa. The response are encoded
% into 0 or 1 in this method
% And by comparing the encoded performance to the design matrix, I could
% easily calculate the hit and correct rejection
correctTrialidx = find(experimentMatrix(:,3) == (keyPress<mean(keyPress)));
correctTrialkeyPress = keyPress(correctTrialidx);
correctTrialreactionTime = reactionTime(correctTrialidx,:);
% First I find the trials that contain what I want: hit and correct
% rejection, and then throw everything away. Then I seperate the
% conjunction and the feature search trials for later computations
correctTrialexperimentMatrix = experimentMatrix(correctTrialidx,:);
conjunctionTrials = find(correctTrialexperimentMatrix(:,2) ==1);
popOutTrials = find(correctTrialexperimentMatrix(:,2) ==0);
result.conjunctionTrialsMatrix = [correctTrialkeyPress(conjunctionTrials),...
    correctTrialreactionTime(conjunctionTrials,:),...
    correctTrialexperimentMatrix(conjunctionTrials,:)];
result.popOutTrialsMatrix = [correctTrialkeyPress(popOutTrials),...
    correctTrialreactionTime(popOutTrials),...
    correctTrialexperimentMatrix(popOutTrials,:)];
% Computation
% By comparing to the particular setsize, the conjunction trials and
% pup-out search trials are diveded to 4 groups. Since the 4 groups of
% trials are not at the same length, I could not make them into one giant
% matrix. So I make a structure thing for them
for ii = 1:length(setSize)
    result.conjReport(ii).R = ...
        result.conjunctionTrialsMatrix(result.conjunctionTrialsMatrix(:,3)==setSize(ii),:);
    result.popoReport(ii).R = ...
        result.popOutTrialsMatrix(result.popOutTrialsMatrix(:,3)==setSize(ii),:);
end
format short g
% compute the correlation between the set size and reaction time
result.conjun.correlationSetSize = corrcoef(result.conjunctionTrialsMatrix(:,2),...
    result.conjunctionTrialsMatrix(:,3));
result.popOut.correlationSetSize = corrcoef(result.popOutTrialsMatrix(:,2),...
    result.popOutTrialsMatrix(:,3));
% compute the mean performance for each set size, and the standard error
 ForConjPlot = [mean(result.conjReport(1).R(:,2)),mean(result.conjReport(2).R(:,2)),...
     mean(result.conjReport(3).R(:,2)),mean(result.conjReport(4).R(:,2))];
 SEForConjPlot = [SER(result.conjReport(1).R(:,2)),SER(result.conjReport(2).R(:,2)),...
     SER(result.conjReport(3).R(:,2)),SER(result.conjReport(4).R(:,2))] ;
 ForPopPlot = [mean(result.popoReport(1).R(:,2)),mean(result.popoReport(2).R(:,2)),...
    mean(result.popoReport(3).R(:,2)),mean(result.popoReport(4).R(:,2))];
SEForPopPlot = [SER(result.popoReport(1).R(:,2)),SER(result.popoReport(2).R(:,2)),...
    SER(result.popoReport(3).R(:,2)),SER(result.popoReport(4).R(:,2))];
% plot the results, the correlation is shown in the figure too
figure;
plot(1:4,ForConjPlot,'b-');hold on
plot(1:4,ForPopPlot,'r--')
legend('conjunction search','pop out search')
errorbar(1:4,ForConjPlot,SEForConjPlot,'b.')
errorbar(1:4,ForPopPlot,SEForPopPlot,'r.')
text(2,ForConjPlot(3),sprintf(' correlation is %f',result.conjun.correlationSetSize(1,2)));
text(2,ForPopPlot(3),sprintf(' correlation is %f',result.popOut.correlationSetSize(1,2)));
xlim([0,5])
ax = gca;
set(gcf,'color',[1,1,1])
set(ax,'XTick',[0 1 2 3 4 5],'XTickLabel',{'x','4','8','12','16','x'})
box off
xlabel('set size from 4 to 16')
ylabel('reaction times by seconds')
title('reaction times against set size: contrasting conjuction search and pop out search')
pause;
close
% standard error function
function [standardError] = SER(data)
standardError = std(data) ./ sqrt(length(data)-1);
% figure making function
function [  ] = projectXO(setSize, CvsF, presentAbsent)
%setSize variable controls the set size
%CvsF variable controls whether it is conjunction or feature search, 1 is
%conjunction, 0 is feature search
%presentVSAbsent variable controls whether the target (red X) is present or
%not
FontSize = 12;% specify the font size
% the struture of the if statement is:
% conjunction block: [present, absent];
% feature block: present, absent];
% the algorism doesn't solve the over lapping problem
if CvsF ==1
    if presentAbsent ==1
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        target = datasample([Xs],1,'Replace',false,'Weights',...
            ones(setSize,1)./(setSize));
        htarget = plot(target(1),target(2),'rx');hold on
        set(htarget,'MarkerSize',FontSize,'LineWidth',4)
        Xs = Xs((Xs(:,1) ~= target(:,1)),:);
        h1 = plot(circles(:,1),circles(:,2),'ro');
        set(h1, 'MarkerSize', FontSize,'LineWidth',4)
        h2 = plot(Xs(:,1), Xs(:,2),'bx');
        set(h2,'MarkerSize',FontSize,'LineWidth',4)
        set(gcf,'Color',[1,1,1])
        axis off
        hold off
    elseif presentAbsent == 0
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        h1 = plot(circles(:,1),circles(:,2),'ro');hold on
        set(h1, 'MarkerSize', FontSize,'LineWidth',4)
        h2 = plot(Xs(:,1), Xs(:,2),'bx');
        set(h2,'MarkerSize',FontSize,'LineWidth',4)
        set(gcf,'Color',[1,1,1])
        axis off
        hold off
    end
elseif CvsF ==0
    if presentAbsent ==1
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        target = datasample([Xs],1,'Replace',false,'Weights',...
            ones(setSize,1)./(setSize));
        h1 = plot(circles(:,1),circles(:,2),'bo');hold on
        set(h1, 'MarkerSize', FontSize,'LineWidth',4)
        h2 = plot(Xs(:,1), Xs(:,2),'bx');
        set(h2,'MarkerSize',FontSize,'LineWidth',4)
        htarget = plot(target(1),target(2),'rx','LineWidth',4);
        set(htarget,'MarkerSize',FontSize,'LineWidth',4)
        set(gcf,'Color',[1,1,1])
        axis off
        hold off
    elseif presentAbsent == 0
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        h1 = plot(circles(:,1),circles(:,2),'bo');hold on
        set(h1, 'MarkerSize', FontSize,'LineWidth',4)
        h2 = plot(Xs(:,1), Xs(:,2),'bx');
        set(h2,'MarkerSize',FontSize,'LineWidth',4)
        set(gcf,'Color',[1,1,1])
        axis off
        hold off
    end
end
