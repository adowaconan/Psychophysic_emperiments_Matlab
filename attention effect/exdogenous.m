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