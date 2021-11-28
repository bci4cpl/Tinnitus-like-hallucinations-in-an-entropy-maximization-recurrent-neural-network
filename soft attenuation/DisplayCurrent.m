% Display the last results

wipe_all;

SetSize;

GetSamples;

[~, SimParams, isloaded] = LoadCurrent();

if (isloaded)
    % displaly results
	fprintf('Recurrent ridge: %g\n', SimParams.net.Rec_ridge);
    SimParams.Steps.ilearn = SimParams.Steps.ilearn - 1;
    DisplayResults(SimParams, Samples);
else
    disp('Loading failed');
end