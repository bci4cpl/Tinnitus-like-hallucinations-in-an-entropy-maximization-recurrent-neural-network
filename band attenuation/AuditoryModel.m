% Auditory model using InfoMax approach
function AuditoryModel(SimParams, Samples)

%% Set phase parameters by ilearn
attenuated = 0;
K_learn = 0;

% Attenuate inputs
if(SimParams.Steps.ilearn > SimParams.Steps.tinnitusilearn)
    x = Attenuate(Samples.x, SimParams.Attenuate);
    attenuated = 1;
    K_learn = 1;
else
    x = Samples.x;
    
    % Set learning rates
    if(SimParams.Steps.ilearn > SimParams.Steps.finalWilearn)
        SimParams.net.FF_eta    = 0;
        SimParams.net.Rec_eta   = SimParams.Net.eta_K;
        K_learn = 1;
    else
        SimParams.net.FF_eta    = SimParams.Net.eta_W;
        SimParams.net.Rec_eta   = 0;
    end
end

%% Learning Loop
while (SimParams.Steps.ilearn <= SimParams.Steps.nlearn)
    
    tic;
    
    %% Set phase parameters by ilearn
    % Attenuate inputs
    if (~attenuated && SimParams.Steps.ilearn > SimParams.Steps.tinnitusilearn)
        x = Attenuate(Samples.x, SimParams.Attenuate);
        attenuated = 1;
        save([SimParams.Files.path '\' SimParams.Files.filename date '_K_learned.mat'], 'SimParams');
        % Set learning rates
    elseif (~K_learn && SimParams.Steps.ilearn > SimParams.Steps.finalWilearn)
        SimParams.net.FF_eta    = 0;
        SimParams.net.Rec_eta   = SimParams.Net.eta_K;
        K_learn = 1;
        save([SimParams.Files.path '\' SimParams.Files.filename date '_W_learned.mat'], 'SimParams');
    end
    
    %% Choose samples at random
    x0 = x(:, randperm(Samples.n_samples, SimParams.Samples.step_samples));
    
    %% Learn
    SimParams.net.Learn(x0);
    
    %% Calculate the cost function
    if (rem(SimParams.Steps.ilearn - 1, SimParams.Cost.n_calc) == 0)
        cost = GetCost(SimParams, Samples);
        if (SimParams.Steps.ilearn > SimParams.Steps.tinnitusilearn && cost - SimParams.Cost.last > SimParams.Cost.maxdiff)
            break;
        end
        SimParams.Cost.last = cost;
    end
    SimParams.Cost.err(SimParams.Steps.ilearn) = SimParams.Cost.last;
    
    %% Calculate time left
    SimParams.Time.dur(rem(SimParams.Steps.ilearn - 1, SimParams.Time.n_mean_time) + 1) = toc;
    
    %% Write progress details at the command window
    if (SimParams.Display.write && rem(SimParams.Steps.ilearn, SimParams.Display.n_write) == 0)
		fprintf('Recurrent ridge: %g\n', SimParams.net.Rec_ridge);
        fprintf(1, 'Ilearn = %d:  E = %g\n', SimParams.Steps.ilearn, SimParams.Cost.last);
        N = min(SimParams.Steps.ilearn, SimParams.Time.n_mean_time);
        time_left_s = floor((SimParams.Steps.nlearn - SimParams.Steps.ilearn) * mean(SimParams.Time.dur(1:N))); % seconds
        time_left_m = floor(time_left_s / 60); % minutes
        time_left_s = time_left_s - 60 * time_left_m;
        time_left_h = floor(time_left_m / 60); % hours
        time_left_m = time_left_m - 60 * time_left_h;
        time_left_d = floor(time_left_h / 24); % days
        time_left_h = time_left_h - 24 * time_left_d;
        fprintf(1, 'Time left (est.): %d:%02d:%02d:%02d\n\n', time_left_d, time_left_h, time_left_m, time_left_s);
    end
    
    %% Display results
    if (SimParams.Display.disp && rem(SimParams.Steps.ilearn, SimParams.Display.n_disp) == 0)
        DisplayResults(SimParams);
    end
    
    %% Increment ilearn
    SimParams.Steps.ilearn = SimParams.Steps.ilearn + 1;
    
    %% Save results
    if (rem(SimParams.Steps.ilearn - 1, SimParams.Files.n_save) == 0)
        save([SimParams.Files.path '\' SimParams.Files.filename date '.mat'], 'SimParams');
    end
end

end