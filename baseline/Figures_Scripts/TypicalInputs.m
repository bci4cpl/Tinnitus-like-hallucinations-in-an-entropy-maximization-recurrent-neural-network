% Create the stimuli's graphs

wipe_all;
addpath('..\');
SetConstants;
ls = 'k-';  % Line Spec

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_normal_stimuli_talk';
% fig_name    = 'Fig_attenuated_stimuli_talk';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
xSize = 3.5;
ySize = 4;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,lcs,'w');

% Set Size
SetSize;

% Attenuation
SimParams.Attenuate.beta    = 10;                   % Attenuation smoothness factor
SimParams.Attenuate.f_0     = floor(inputs / 2);    % Attenuation mean index
SimParams.Attenuate.minval  = 0;                    % Attenuation minimal value

% Axes Normalization
f_num = 30;
f_min = 20;
f_max = f_min + (f_num - 1);
f_inp = linspace(f_min, f_max, inputs);
f_min_log = 20;
f_max_log = 20000;
f_inp_log = logspace(log10(f_min_log), log10(f_max_log), inputs);

% Axes Display
x_title     = 'Frequency (Hz)';
x_lim       = [f_min_log, f_max_log];
x_tick      = [f_min_log, f_min_log*10, f_max_log/10, f_max_log];
y_title     = 'Activity';
y_lim       = [0, 0.2];
y_tick      = [ ];

% Colors
GREEN = [42, 66, 26]./255;

% Get Samples
if(~exist('Samples', 'var') == 1)
    GetSamples;
end

% Generate inputs
% ind = randi(size(Samples.x, 2));
x_typical = Samples.x(:, 171187);

% Generate Attenuated Inputs
x_typical_a = Attenuate(x_typical, SimParams.Attenuate);

% A typical input
h = semilogx(f_inp_log', x_typical, ls, lws, lw);
h.Color = GREEN;
set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
set(gca,'XColor',GREEN,'YColor',GREEN);
SetGraphDisplay(x_title, y_title, '');

% % A typical attenuated input
% h = semilogx(f_inp_log', x_typical_a, ls, lws, lw);
% h.Color = GREEN;
% set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
% set(gca,'XColor',GREEN,'YColor',GREEN);
% SetGraphDisplay(x_title, y_title, '');


%--------------------------------------
print(gcf,'-dpng','-r300',[fig_path fig_name]);
