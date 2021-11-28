% Load the current results
function [RidgeK, SimParams, isloaded] = LoadCurrent()
    
    SetSize
	
    SimParams.Files.duration    = 1000; % Duration to check for previous results (in days)
    SimParams.Files.path        = 'Results'; % Results directory
	SimParams.Files.filenamebeg = ['Auditory_' num2str(inputs) 'x' ...
									num2str(outputs) '_']; % Results file name beginning
	
	RidgeK.filename = 'RidgeK.mat';
	if(exist(RidgeK.filename, 'file'))
		tmp = load(RidgeK.filename);
		RidgeK = tmp.RidgeK;
	else
		isloaded	= 0;
		return;
	end
    
    SimParams.Files.filename    = [SimParams.Files.filenamebeg 'RidgeK_' ...
								   num2str(RidgeK.values(RidgeK.ind)) '_']; % Results file name
        
    %Load results
    tmp = LoadResults(SimParams.Files);
    if (isstruct(tmp))
        SimParams = tmp;
        isloaded = 1;
    else
        isloaded = 0;
    end
    
    clear tmp;
    
end