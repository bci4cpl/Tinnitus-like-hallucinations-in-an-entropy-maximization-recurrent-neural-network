% Get samples from file or generate new ones

Samples.filename = 'Samples'; % Samples file name

[Samples, isLoaded] = LoadSamples(Samples.filename);

if(~isLoaded)
    
    clear Samples;
    Samples.filename = 'Samples'; % Samples file name
    
    % Inputs generation
    Samples.n_samples       = 1000000;  % Number of samples
    InputGen.n_tones_max	= 5;        % Max number of  tones
    InputGen.a_min          = 7;        % Min amplitude
    InputGen.a_max          = 10;       % Max amplitude
    InputGen.noise_fac      = 0.5;      % Noise factor
    InputGen.white_noise    = 0.5;      % Constant noise
    
    % Generate inputs matrix
    Samples.x = GenInput(inputs, Samples.n_samples, InputGen);
    Samples.n_samples = size(Samples.x, 2);
    
    % Clear unneeded data
    clear f_num InputGen;
    
    % Save the samples
    save(Samples.filename, 'Samples');
    
end

clear isLoaded;