% Load previous results
function [SimParams] = LoadResults(Files, filenameend)
    
    if nargin == 1
        filenameend = '';
    end
    
    SimParams = 0;
    
    %checking if previous file results exist
    D = dir (Files.path);
    fullname = [Files.path '\' Files.filename date filenameend '.mat'];
    %if yes loading results from previous run of simulation
    if(~isempty(D))
        % checking current filename
        if(exist(fullname, 'file'))
            load (fullname);
            % else search for previous results file from the specified duration
        else
            tempname = [Files.path '\' Files.filename date filenameend '.mat'];
            day = floor(datenum(date));
            datei = 0;
            while ((~exist(tempname, 'file')) && datei < Files.duration)
                day = day - 1;
                datei = datei + 1;
                tempname = [Files.path '\' Files.filename datestr(day) filenameend '.mat'];
            end
            % load the most recent results file only if one was found
            if (datei < Files.duration)
                load (tempname);
            end
        end
    end
    
end