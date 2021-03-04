%% helper to plot gaze position after stimulus appearance

figure;
for isubj = 1:1
    ntrials = length(beh(isubj).stimTimes);
    x = [];
    y = [];
    for itrial = 1:ntrials
        %lock to stimulus appearance
        startTimeBeh = beh(isubj).stimTimes(itrial);
        %find closest timestamp (they have 0.01 s resolution)
        startInd = find(abs(eye(isubj).times(:,2)-startTimeBeh)<0.01,1);
        %get timestamps from eye data
        startTime = eye(isubj).times(startInd,2);
        endTime = startTime(1) + 0.05;
        %find closest timestamp to end
        endInd = find(abs(eye(isubj).times(:,2)-endTime)<0.01,1);
        %add to array
        x = [x,eye(isubj).xypos(startInd:endInd,1)];
        y = [y,eye(isubj).xypos(startInd:endInd,2)];  
    end
    %select out left vs right trials
    leftTrial = find(beh(isubj).contrastLeft>beh(isubj).contrastRight);
    rightTrial = find(beh(isubj).contrastLeft<beh(isubj).contrastRight);
    %plot
    plot(mean(x(:,leftTrial)),mean(y(:,leftTrial)),'color','r');
    hold on;
    plot(mean(x(:,rightTrial)),mean(y(:,rightTrial)),'color','b');
    xlabel('x coordinate');
    ylabel('y coordinate');
    legend('leftTrial','rightTrial');
end