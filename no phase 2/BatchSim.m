% Auditory Model - Simulation
% by Aviv Dotan

wipe_all;

%% Set the network's size
SetSize;

%% Get input samples
GetSamples;

%% Load results
load_res = 1; % Try load previous results?
is_loaded = 0;

% if (load_res)
%     
%     [RidgeK, SimParams, is_loaded] = LoadCurrent();
%     
%     if (is_loaded)
%         
%         % Write at the command window
%         if(SimParams.Display.write)
%             disp('Results file loaded. ');
%             disp(' ');
%         end
%         
%         % displaly results
%         if (SimParams.Display.disp)
%             SimParams.Steps.ilearn = SimParams.Steps.ilearn - 1;
%             DisplayResults(SimParams);
%             SimParams.Steps.ilearn = SimParams.Steps.ilearn + 1;
%         end
%     end
% end

%% Initialize

if (is_loaded)
    
    % Here you can force changes on the loaded parameters
    
else
    
    % Initialize the simulation's parameters
	RidgeK.filename = 'RidgeK.mat';
% 	RidgeK.values = [0.1:0.005:0.175, ...
%                      0.176:0.001:0.19, ...
%                      0.195:0.005:0.22, ...
%                      0.221:0.001:0.235, ...
%                      0.24:0.01:0.3];
    RidgeK.values = [0.1:0.05:0.15, ...
        0.17:0.01:0.18, ...
        0.182, 0.185, ...
        0.19:0.01:0.23, ...
        0.225:0.001:0.228, ...
        0.2255, ...
        0.25:0.05:0.3];
	RidgeK.ind = 1;
	save(RidgeK.filename, 'RidgeK');
	
	SimParams.Files.duration    = 1000; % Duration to check for previous results (in days)
    SimParams.Files.path        = 'Results'; % Results directory
	SimParams.Files.filenamebeg = ['Auditory_' num2str(inputs) 'x' ...
									num2str(outputs) '_']; % Results file name beginning
	
end

% Clear unneeded data
clear load_res;

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
