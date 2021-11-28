% Auditory Model - Simulation
% by Aviv Dotan

wipe_all;

%% Set the network's size
SetSize;

%% Get input samples
GetSamples;

%% Initialize

% Initialize the simulation's parameters
RidgeK.filename = 'RidgeK.mat';
% 	RidgeK.values = [0.0001:0.00005:0.001, ...
%                      0.001:0.0005:0.01, ...
%                      0.01:0.005:0.1, ...
%                      0.1:0.05:0.4];
RidgeK.values = [0.025:0.0001:0.055, ...
                 0.056:0.001:0.06, ...
                 0.065:0.005:0.1];
RidgeK.ind = 1;
save(RidgeK.filename, 'RidgeK');

SimParams.Files.duration    = 1000; % Duration to check for previous results (in days)
SimParams.Files.path        = 'Results'; % Results directory
SimParams.Files.filenamebeg = ['Auditory_' num2str(inputs) 'x' ...
    num2str(outputs) '_']; % Results file name beginning

%% Simulate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while RidgeK.ind < length(RidgeK.values) + 1
		
	% Results file name
	SimParams.Files.filename = [SimParams.Files.filenamebeg ...
		'RidgeK_' num2str(RidgeK.values(RidgeK.ind)) '_'];
	
	% Load results
	tmp = LoadResults(SimParams.Files);
	if (isstruct(tmp))
		SimParams = tmp;
		is_loaded = 1;
	else
		is_loaded = 0;
	end
	
	clear tmp;
	
	if (is_loaded)
		
		% Here you can force changes on the loaded parameters
		
	else
		
		% Initialize the simulation's parameters
		Files = SimParams.Files;
		clear SimParams;
		SimParams.Files = Files;
		clear Files;
		InitSimParams;
		SimParams.Files.filename    = [SimParams.Files.filenamebeg 'RidgeK_' ...
									   num2str(RidgeK.values(RidgeK.ind)) '_']; % Results file name
		SimParams.net.Rec_ridge		= RidgeK.values(RidgeK.ind);
		save([SimParams.Files.path '\' SimParams.Files.filename date '.mat'], 'SimParams');
		
	end

	% Start the simulation with the current parameters
	AuditoryModel(SimParams, Samples);
	
	is_loaded	= 0;
	RidgeK.ind	= RidgeK.ind + 1;
	save(RidgeK.filename, 'RidgeK');
	
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
