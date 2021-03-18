function [fanoFactor_stim,fanoFactor_goCue,fanoFactor_resp] = spike_train_variability(beh, spikes)
%Find the Fano Factor for MOs's spike count 
%50 ms before audio go-cue, 50 ms after stimulus,
%50 ms before visual go-cue, and 50 ms after go-cue,
%50 ms before response, and 50 ms after response.
%This is for subject 1.


fprintf("Find the Fano Factor of 50 ms before audio go-cue, 50 ms after audio go-cue, 50 ms before visual go-cue, and 50 ms after visual go-cue.")

subject1_beh = beh(17);
nunits = length(spikes.MOsTimes);
num_trials = length(subject1_beh.goCue);
startTime = -50;
endTime = 200;
window = 10;
startTime_windows = [startTime:window:endTime-window];
endTime_windows = [startTime+window:window:endTime];
nwindows = length(startTime_windows);
spikeCounts_stim = zeros([nunits,num_trials,nwindows]);
spikeCounts_cue = zeros([nunits,num_trials,nwindows]);
spikeCounts_resp = zeros([nunits,num_trials,nwindows]);

for iunit = 1:nunits
    unitTimes = spikes.MOsTimes(iunit);
    for trial_index = 1:num_trials
        stimTime = subject1_beh.stimTimes(trial_index);
        goCue = subject1_beh.goCue(trial_index);
        respTime = subject1_beh.respTimes(trial_index);
        for iwin = 1:nwindows
            spikeCounts_stim(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-stimTime<endTime_windows(iwin) & spikes.MOsTimes{iunit}-stimTime>startTime_windows(iwin));
            spikeCounts_cue(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-goCue<endTime_windows(iwin) & spikes.MOsTimes{iunit}-goCue>startTime_windows(iwin));
            spikeCounts_resp(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-respTime<endTime_windows(iwin) & spikes.MOsTimes{iunit}-respTime>startTime_windows(iwin));
        end
    end
end

%find fano factor of each neuron for each condition
leftTrial = find(beh(17).contrastLeft>beh(17).contrastRight);
rightTrial = find(beh(17).contrastLeft<beh(17).contrastRight);
neutralTrial = find(beh(17).contrastLeft==beh(17).contrastRight);
fanoFactor_stim(:,1,:) = var(spikeCounts_stim(:,leftTrial,:),0,2)./mean(spikeCounts_stim(:,leftTrial,:),2);
fanoFactor_stim(:,2,:) = var(spikeCounts_stim(:,rightTrial,:),0,2)./mean(spikeCounts_stim(:,rightTrial,:),2);
fanoFactor_stim(:,3,:) = var(spikeCounts_stim(:,neutralTrial,:),0,2)./mean(spikeCounts_stim(:,neutralTrial,:),2);
fanoFactor_goCue(:,1,:) = var(spikeCounts_cue(:,leftTrial,:),0,2)./mean(spikeCounts_cue(:,leftTrial,:),2);
fanoFactor_goCue(:,2,:) = var(spikeCounts_cue(:,rightTrial,:),0,2)./mean(spikeCounts_cue(:,rightTrial,:),2);
fanoFactor_goCue(:,3,:) = var(spikeCounts_cue(:,neutralTrial,:),0,2)./mean(spikeCounts_cue(:,neutralTrial,:),2);
fanoFactor_resp(:,1,:) = var(spikeCounts_resp(:,leftTrial,:),0,2)./mean(spikeCounts_resp(:,leftTrial,:),2);
fanoFactor_resp(:,2,:) = var(spikeCounts_resp(:,rightTrial,:),0,2)./mean(spikeCounts_resp(:,rightTrial,:),2);
fanoFactor_resp(:,3,:) = var(spikeCounts_resp(:,neutralTrial,:),0,2)./mean(spikeCounts_resp(:,neutralTrial,:),2); 

%get tuned neurons
tunedUnits_stim = find_tuned_neurons(spikeCounts_stim,beh,2);
tunedUnits_cue = find_tuned_neurons(spikeCounts_cue,beh,2);
tunedUnits_resp = find_tuned_neurons(spikeCounts_resp,beh,2);

figure;
color = ['b';'r';'g'];
%plot fano factor in from -50 to 200 ms of stim time
subplot(3,1,1);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_stim(4,i,:)),'color',color(i));
    end
end
%legend([p],{'left','right','neutral'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);

subplot(3,1,2);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_goCue(4,i,:)),'color',color(i));
    end
end
%legend([p],{'left','right','neutral'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);

subplot(3,1,3);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_resp(4,i,:)),'color',color(i));
    end
end
%legend([p],{'left','right','neutral'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);

%plot FF for each condition

% % generate synthetic data to test pvalues
% fake_data_before_stimulus = mean(num_spikes_before_stimulus)+std(num_spikes_before_stimulus)*randn(size(num_spikes_before_stimulus));
% fake_data_after_stimulus = mean(num_spikes_after_stimulus)+std(num_spikes_after_stimulus)*randn(size(num_spikes_after_stimulus));
% fake_data_before_goCue = mean(num_spikes_before_go_cue)+std(num_spikes_before_go_cue)*randn(size(num_spikes_before_go_cue));
% fake_data_after_goCue = mean(num_spikes_after_go_cue)+std(num_spikes_after_go_cue)*randn(size(num_spikes_after_go_cue));
% fake_data_before_resp = mean(num_spikes_before_response)+std(num_spikes_before_response)*randn(size(num_spikes_before_response));
% fake_data_after_resp = mean(num_spikes_after_response)+std(num_spikes_after_response)*randn(size(num_spikes_after_response));
% Fano Factors
% fprintf("MOs Fano Factor for spike count 50 ms before stimulus")
% var(num_spikes_before_stimulus) / mean(num_spikes_before_stimulus)
% p = pval(num_spikes_before_stimulus,fake_data_before_stimulus)
% fprintf("MOs Fano Factor for spike count 50 ms after stimulus")
% var(num_spikes_after_stimulus) / mean(num_spikes_after_stimulus)
% p = pval(num_spikes_after_stimulus,fake_data_after_stimulus)
% fprintf("MOs Fano Factor for spike count 50 ms before go cue")
% var(num_spikes_before_go_cue) / mean(num_spikes_before_go_cue)
% p = pval(num_spikes_before_go_cue,fake_data_before_goCue)
% fprintf("MOs Fano Factor for spike count 50 ms after go cue")
% var(num_spikes_after_go_cue) / mean(num_spikes_after_go_cue)
% p = pval(num_spikes_after_go_cue,fake_data_after_goCue)
% fprintf("MOs Fano Factor for spike count 50 ms before response")
% var(num_spikes_before_response) / mean(num_spikes_before_response)
% p = pval(num_spikes_before_response,fake_data_before_resp)
% fprintf("MOs Fano Factor for spike count 50 ms after response")
% var(num_spikes_after_response) / mean(num_spikes_after_response)
% p = pval(num_spikes_after_response,fake_data_after_resp)

% Interpretation
fprintf("Fano Factor of spike count in MOs is always higher " + ... 
    "(relatively higher spike count variability)" + ...
    "after stimulus / go cue / response than before.")
fprintf("\nFano Factor of spike count in MOs is lowest overall after response -- " + ...
    "there is relatively lower spike count variability after response.")

end

