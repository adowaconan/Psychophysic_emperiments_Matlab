function [  ] = projectXO(setSize, CvsF, presentAbsent)
%say something
FontSize = 12;
if CvsF ==1
    if presentAbsent ==1
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        target = datasample([circles;Xs],1,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        if unique(ismember(target,circles))
            htarget = plot(target(1),target(2),'bo');hold on
            set(htarget,'MarkerSize',FontSize,'LineWidth',4)
            circles = circles((circles(:,1) ~= target(:,1)),:);
            h1 = plot(circles(:,1),circles(:,2),'ro');
            set(h1, 'MarkerSize', FontSize,'LineWidth',4)
            h2 = plot(Xs(:,1), Xs(:,2),'bx');
            set(h2,'MarkerSize',FontSize,'LineWidth',4)
        else
            htarget = plot(target(1),target(2),'rx');hold on
            set(htarget,'MarkerSize',FontSize,'LineWidth',4)
            Xs = Xs((Xs(:,1) ~= target(:,1)),:);
            h1 = plot(circles(:,1),circles(:,2),'ro');
            set(h1, 'MarkerSize', FontSize,'LineWidth',4)
            h2 = plot(Xs(:,1), Xs(:,2),'bx');
            set(h2,'MarkerSize',FontSize,'LineWidth',4)
        end
        
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
        figure
        data = rand(100,2);
        [objectLocations,idx] = datasample(data,setSize*2,'Replace',false, 'Weights', ...
            ones(100,1)./100);
        [circles, ciridx] = datasample(objectLocations,setSize,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        Xs = objectLocations((ismember(idx,idx(ciridx)) ==0),:);
        target = datasample([circles;Xs],1,'Replace',false,'Weights',...
            ones(setSize*2,1)./(setSize*2));
        h1 = plot(circles(:,1),circles(:,2),'bo');hold on
        set(h1, 'MarkerSize', FontSize,'LineWidth',4)
        h2 = plot(Xs(:,1), Xs(:,2),'bx');
        set(h2,'MarkerSize',FontSize,'LineWidth',4)
        if unique(ismember(target,circles))
            htarget = plot(target(1),target(2),'ro');
            set(htarget,'MarkerSize',FontSize,'LineWidth',4)
        else
            htarget = plot(target(1),target(2),'rx','LineWidth',4);
            set(htarget,'MarkerSize',FontSize,'LineWidth',4)
        end
        set(gcf,'Color',[1,1,1])
        axis off
        hold off
    elseif presentAbsent == 0
        figure
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
end