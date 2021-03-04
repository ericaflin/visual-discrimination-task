function [] = raster_subject1_directional(beh, spikes)
%RASTER Provide raster for subject 1's motor neurons
%       -0.5 to 1 s relative to response times to direction (left, right,
%       neutral stimuli)

fprintf("MOs neuron activity during response to left vs right vs neutral trials:")

subject1_beh = beh(1);
subject1_spikes = spikes(1).MOsTimes;

% MOs response to left stimuli
figure
title({'MOs neuron activity at response time for','left stimuli (for subject 1)'},'fontsize',18)
xlabel('Spike time (ms)','FontSize',14)
ylabel('Trial','FontSize',14)
hold on 

left_trial_indices = find(subject1_beh.contrastLeft > subject1_beh.contrastRight);
num_left_trials = length(left_trial_indices);

for cur_array_idx = 1:num_left_trials
    trial_index = left_trial_indices(cur_array_idx);
    resp_time = subject1_beh.respTimes(trial_index);
    responses_s = subject1_spikes(subject1_spikes >= resp_time - 0.5 & subject1_spikes <= resp_time + 1);
    responses_s = responses_s - resp_time; % Align data to resp_time
    responses_ms = responses_s * 1000;
    for response = responses_ms
        y  = num_left_trials - cur_array_idx;
        line([response response],[y, y + 0.8],'color','black','LineWidth',1)
    end
end
set(gca,'YTick',(1:8:num_left_trials)-0.5,'YTickLabel',num_left_trials:-8:1)
hold off

% MOs response to right stimuli
figure
title({'MOs neuron activity at response time for','right stimuli (for subject 1)'},'fontsize',18)
xlabel('Spike time (ms)','FontSize',14)
ylabel('Trial','FontSize',14)
hold on 

right_trial_indices = find(subject1_beh.contrastLeft < subject1_beh.contrastRight);
num_right_trials = length(right_trial_indices);

for cur_array_idx = 1:num_right_trials
    trial_index = right_trial_indices(cur_array_idx);
    resp_time = subject1_beh.respTimes(trial_index);
    responses_s = subject1_spikes(subject1_spikes >= resp_time - 0.5 & subject1_spikes <= resp_time + 1);
    responses_s = responses_s - resp_time; % Align data to resp_time
    responses_ms = responses_s * 1000;
    for response = responses_ms
        y  = num_right_trials - cur_array_idx;
        line([response response],[y, y + 0.8],'color','black','LineWidth',1)
    end
end
set(gca,'YTick',(1:8:num_right_trials)-0.5,'YTickLabel',num_right_trials:-8:1)
hold off

% MOs response to neutral stimuli
figure
title({'MOs neuron activity at respoonse time for','neutral stimuli (for subject 1)'},'fontsize',18)
xlabel('Spike time (ms)','FontSize',14)
ylabel('Trial','FontSize',14)
hold on 

neutral_trial_indices = find(subject1_beh.contrastLeft == subject1_beh.contrastRight);
num_neutral_trials = length(neutral_trial_indices);

for cur_array_idx = 1:num_neutral_trials
    trial_index = neutral_trial_indices(cur_array_idx);
    resp_time = subject1_beh.respTimes(trial_index);
    responses_s = subject1_spikes(subject1_spikes >= resp_time - 0.5 & subject1_spikes <= resp_time + 1);
    responses_s = responses_s - resp_time; % Align data to resp_time
    responses_ms = responses_s * 1000;
    for response = responses_ms
        y  = num_neutral_trials - cur_array_idx;
        line([response response],[y, y + 0.8],'color','black','LineWidth',1)
    end
end
set(gca,'YTick',(1:8:num_neutral_trials)-0.5,'YTickLabel',num_neutral_trials:-8:1)
hold off

fprintf("For the neutral stimuli, there is more neural activity at the response time, compared to when there was a clear left or right stimuli.")

end

