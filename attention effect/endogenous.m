function [ ] = endogenous( three,present,arrowPos )
% The funtion takes 3 arguments: [1or2or3] meaning whether the trial is
% vertical, horizontal, or mixed layout. Each category has 30 trials. 
% The second argument is the position of the stimulus
% The third argument is the position of the arrows

waitingTime = randi([50,250],1)/100;
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
    set(gcf,'Color',[1,1,1]);axis off;hold off
    % draw 2 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [1,1,1])
    % make the stimulus one of the rectangles
    stimulus = retangle(present);
    % set up the existing arrow, and hold its position as a constant cue
    arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\rightarrow');
    set(arrow, 'LineWidth',2,'FontSize',16)
    
    set(stimulus, 'Facecolor', [1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0])
    pause(0.18)% I test this myself
    set(stimulus, 'Facecolor', [1,1,1])
    
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
    set(gcf,'Color',[1,1,1]);axis off;hold off
    % draw 2 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [1,1,1])
    % make the stimulus one of the 2 rectangles
    stimulus = retangle(present); 
    % set up the arrow, and make it a constant cue
    arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\downarrow');
    set(arrow, 'LineWidth',2,'FontSize',16)
    set(stimulus, 'Facecolor', [1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0])
    pause(0.18)
    set(stimulus, 'Facecolor', [1,1,1])
    
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
    set(gcf,'Color',[1,1,1]);axis off;hold off
    % draw 4 rectangles
    retangle(1) = rectangle('Position',retanglePosition(1,:));
    set(retangle(1),'Facecolor', [1,1,1])
    retangle(2) = rectangle('Position',retanglePosition(2,:));
    set(retangle(2),'Facecolor', [1,1,1])
    retangle(3) = rectangle('Position',retanglePosition(3,:));
    set(retangle(3),'Facecolor', [1,1,1])
    retangle(4) = rectangle('Position',retanglePosition(4,:));
    set(retangle(4),'Facecolor', [1,1,1])
    % the way to handle arrow directions
    if mod(arrowPos,2)
        arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\leftarrow');
        set(arrow, 'LineWidth',2,'FontSize',16)
    else
        arrow = text(arrowPosition(arrowPos,1),arrowPosition(arrowPos,2),'\rightarrow');
        set(arrow, 'LineWidth',2,'FontSize',16)
    end
    % make stimulus one of the rectangles
    stimulus = retangle(present); 
    
    set(stimulus, 'Facecolor', [1,1,1])
    pause(waitingTime)
    set(stimulus, 'Facecolor', [1,1,0])
    pause(0.18)
    set(stimulus, 'Facecolor', [1,1,1])

end
end

