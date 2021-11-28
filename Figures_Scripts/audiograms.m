% Create the neetwork's audiograms plots

wipe_all
addpath('.\export_fig\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_audiograms';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = 0.7*xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

% Audiogram parameters
threshold = 1e-2;
tol = 1e-6;
p_norm = Inf;
max_val = 100;

% Directory per attenuation profile
dirs = {'baseline', ...
    'shifted attenuation', ...
    'soft attenuation', ...
    'band attenuation', ...
    'low attenuation'};

% Loading's Parameters
addpath(['..\' dirs{1}]);
SetSize
rmpath(['..\' dirs{1}]);
dur             = 1000; % Duration to check for previous results (in days)
path            = '.\Results'; % Results directory
% ridgeKval       = 0.182;  % V1
ridgeKval       = 0.226;
filename        = ['Auditory_' num2str(inputs) 'x' num2str(outputs) ...
    '_RidgeK_' num2str(ridgeKval) '_']; % Results file name

% Frequency axis
f_min = 20;
f_max = 20000;
f_inp = logspace(log10(f_min), log10(f_max), inputs);

% Axes Display
x_title     = 'Frequency (Hz)';
% x_lim       = [0, outputs];
% x_tick      = [0, outputs/2, outputs];
x_lim       = [f_min, f_max];
x_tick      = [f_min, f_min*10, f_max/10, f_max];
% y_title     = 'Activity';         % V1
y_title     = 'Threshold (dB)';
% y_lim       = [0, 1.05];
% y_tick      = [0, 0.5, 1];
y_lim       = 10.*([log10(tol) - 0.5, log10(max_val) - 0.5] - log10(tol));

% Get Samples
addpath(['..\' dirs{1}]);
if(~exist('Samples', 'var') == 1)
    GetSamples;
end
rmpath(['..\' dirs{1}]);

% Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;
isloaded = 0;

curr_dir = pwd;
n_plot_cols = 3;
n_plot_rows = ceil((1 + length(dirs))/n_plot_cols);

% Load results before tinnitus

cd(['..\' dirs{1}]);
addpath('Figures_Scripts')
tmp = LoadResults(SimParams.Files, '_K_learned');
if (isstruct(tmp))
    
    isloaded = 1;
    SimParams = tmp;
    clear tmp;
    
    audiogram = 10.*log10(get_audiogram(SimParams.net, ...
        threshold, tol, p_norm, max_val));
    normal_hearing = mean(audiogram);
    audiogram = audiogram - normal_hearing;
    
    y_lim = [-0.5, 10.*log10(max_val) - normal_hearing + 10.5];
    
    subplot(n_plot_rows,n_plot_cols,1)
    semilogx(f_inp, audiogram, lws, lw, lcs, lc1);
    axis ij;
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim);
    SetGraphDisplay(' ', y_title, 'A');
    
end

rmpath('Figures_Scripts')
cd(curr_dir);

% Reset sigmoid y-axis
% sig_y_lim(1) = spon_act/(spon_act - 1);

% Load tinnitus results
if (isloaded)
    
    %   Load the Network
    SimParams.Files.duration    = dur;
    SimParams.Files.path        = path;
    SimParams.Files.filename    = filename;
    
    for d = 1:length(dirs)
        
        cd(['..\' dirs{d}]);
        addpath('Figures_Scripts')
    
        tmp = LoadResults(SimParams.Files);
        if (isstruct(tmp))

            SimParams = tmp;
            clear tmp;

            audiogram = 10.*log10(get_audiogram(SimParams.net, ...
                threshold, tol, p_norm, max_val, ...
                @Attenuate, SimParams.Attenuate)) - normal_hearing;
            
            subplot(n_plot_rows,n_plot_cols,1+d)
            semilogx(f_inp, audiogram, lws, lw, lcs, lc1);
            axis ij;
            set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim);
            if ceil((d + 1)/n_plot_cols) == n_plot_rows
                tmp_x_title = x_title;
            else
                tmp_x_title = ' ';
            end
            if rem(d + 1, n_plot_cols) == 1
                tmp_y_title = y_title;
            else
                tmp_y_title = ' ';
            end
            SetGraphDisplay(tmp_x_title, tmp_y_title, char(double('A') + d ));

        end
        
        rmpath('Figures_Scripts')
        cd(curr_dir);
        
    end
end

%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-dtiff','-r300',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');

function audiogram = get_audiogram(net, threshold, tol, p_norm, max_val, ...
    AttenuateFunc, AttenuateParams)

atten = exist('AttenuateFunc', 'var') && ~isempty(AttenuateFunc) && ...
    exist('AttenuateParams', 'var') && ~isempty(AttenuateParams);

audiogram = zeros(net.Inputs, 1);
silence = zeros(size(audiogram));
if atten
    silence = AttenuateFunc(silence, AttenuateParams);
end
baseline = net.Evaluate(silence);
for i = 1:length(audiogram)
    base_input = zeros(size(audiogram));
    base_input(i) = 1;
    brackets = [0, max_val];
    b_inputs = brackets .* base_input;
    if atten
        for b = 1:2
            b_inputs(:, b) = AttenuateFunc(b_inputs(:, b), AttenuateParams);
        end
    end
    norms = vecnorm(net.Evaluate(b_inputs) - baseline, p_norm);
    if norms(1) >= threshold || norms(2) <= threshold
        audiogram(i) = max_val;
        continue;
    end
    while norms(1) < threshold && norms(2) > threshold && ...
            abs(diff(brackets)) > tol
        middle_point = mean(brackets);
        m_input = middle_point .* base_input;
        if atten
            m_input = AttenuateFunc(m_input, AttenuateParams);
        end
        middle_norm = vecnorm(net.Evaluate(m_input) - baseline, p_norm);
        ind = 1 + (middle_norm > threshold);
        brackets(ind) = middle_point;
        norms(ind) = middle_norm;
    end
    audiogram(i) = middle_point;
end

end
