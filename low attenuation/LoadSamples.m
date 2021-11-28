% Load previous results
function [Samples, isLoaded] = LoadSamples(filename)

fullname = [filename '.mat'];

Samples = 0;

if(exist(fullname, 'file'))
    load(fullname);
end

if(isstruct(Samples))
    isLoaded = 1;
else
    isLoaded = 0;
end

end