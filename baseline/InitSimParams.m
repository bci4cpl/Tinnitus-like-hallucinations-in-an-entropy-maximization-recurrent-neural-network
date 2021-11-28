% Initialize the simulation's parameters

% Neural Network
SimParams.Net.eta_W	= 0.1;      % Feed-Forward learning rate
SimParams.Net.eta_K	= 0.001; 	% Recurrent learning rate
threshold           = 1;        % Use threshold?
FF_ridge            = 0.001;  	% Feed-Forward ridge regression coefficient
Rec_ridge           = 0.209;	% Recurrent ridge regression coefficient
beta                = 0;        % PCA term coefficient (irrelevant)
niter               = 10000;    % Number of iterations for the euler method
alpha               = 0.2;      % Euler method's parameter
tolfun              = 1e-8;    	% Euler method's tolerance

% The Infomax neural network:
SimParams.net = Infomax(inputs, outputs, threshold, ...
                        SimParams.Net.eta_W, SimParams.Net.eta_K, ...
                        FF_ridge, Rec_ridge, beta, ...
                        niter, alpha, tolfun);
% Samples
SimParams.Samples.step_samples  = 1; % Number of samples per learning step

% Simulation
SimParams.Steps.ilearn          = 1;       	% Current learning step
SimParams.Steps.finalWilearn    = 50000;	% Maximal W learn learning step
SimParams.Steps.tinnitusilearn  = 1050000;	% Tinnitus simulation start ilearn
SimParams.Steps.nlearn          = 2050000;	% Maximal learning step
    
% Cost history
SimParams.Cost.n_samp   = 10;   % Number of first samples to calculate the cost with
SimParams.Cost.n_calc   = 100;  % Number of learning steps for cost calculation
SimParams.Cost.last     = Inf;  % The last cost calculated
SimParams.Cost.maxdiff  = 100;  % Max positive cost difference allowed
SimParams.Cost.err      = zeros(SimParams.Steps.nlearn, 1);	% Cost graph

% Time estimation
SimParams.Time.n_mean_time = 100; % Number of samples for time est.
SimParams.Time.dur = zeros(1, SimParams.Time.n_mean_time);  % Samples for time est.

% Display
SimParams.Display.disp      = 0;    % Display results?
SimParams.Display.n_disp    = 10;   % Number of learning steps for display
SimParams.Display.write     = 1;    % Write progress details at the command window?
SimParams.Display.n_write   = 10;	% Number of learning steps for writing progress

% Save
SimParams.Files.n_save = 100; % Number of learning steps for save

% Attenuation
SimParams.Attenuate.beta    = 10;                   % Attenuation smoothness factor
SimParams.Attenuate.f_0     = floor(inputs / 2);    % Attenuation mean index
SimParams.Attenuate.minval  = 0;                    % Attenuation minimal value

% Clear unneeded data
clear threshold FF_ridge Rec_ridge beta niter alpha tolfun;
