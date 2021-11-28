% Create the neetwork's responses graphs

wipe_all
addpath('..\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_response';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

% Loading's Parameters
SetSize
dur             = 1000; % Duration to check for previous results (in days)
path            = '..\Results'; % Results directory
% ridgeKval       = 0.182;  % V1
ridgeKval       = 0.226;
filename        = ['Auditory_' num2str(inputs) 'x' num2str(outputs) ...
    '_RidgeK_' num2str(ridgeKval) '_']; % Results file name

% Axes Display
x_title     = 'Neuron No.';
x_lim       = [0, outputs];
x_tick      = [0, outputs/2, outputs];
% y_title     = 'Activity';         % V1
i_y_title   = 'Input Activity';     % V2
o_y_title   = 'Output Activity';    % V2
y_lim       = [0, 1.05];
y_tick      = [0, 0.5, 1];
x_lim_inp   = [0, inputs];
x_tick_inp  = [0, inputs/2, inputs];
y_lim_inp   = [-0.01, 0.25];
y_tick_inp  = [0, 0.1, 0.2];
x_sig       = linspace(1, inputs, outputs);
sig_title   = {'Atten.', 'Profile'};
sig_y_lim   = [0, 1.05];
sig_y_tick  = [0, 1];

% Get Samples
if(~exist('Samples', 'var') == 1)
    GetSamples;
end

% Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;
isloaded = 0;

% Load results before tinnitus
tmp = LoadResults(SimParams.Files, '_K_learned');
if (isstruct(tmp))
    
    isloaded = 1;
    SimParams = tmp;
    clear tmp;
    
    % Generate inputs
    ind1 = 655478;%randi(size(Samples.x, 2))
    x_typical1 = Samples.x(:, ind1);
    ind2 = 171187;%randi(size(Samples.x, 2))
    x_typical2 = Samples.x(:, ind2);
    x_silence = zeros(SimParams.net.Inputs,1);
    
    % Spontaneous activity      % V2
    spon_act = mean(SimParams.net.Evaluate(x_silence));
    
    % A typical network response to a combination of tones before tinnitus
    subplot(3,3,1)
    plot(1:SimParams.net.Inputs, x_typical1, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
    SetGraphDisplay(' ', i_y_title, 'A');
    
    % A typical network response to a combination of tones before tinnitus
    subplot(3,3,2)
    plot(1:SimParams.net.Inputs, x_typical2, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to silence before tinnitus
    subplot(3,3,3)
    plot(1:SimParams.net.Inputs, x_silence, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to a combination of tones before tinnitus
    s = SimParams.net.Evaluate(x_typical1);
    subplot(3,3,4)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
    SetGraphDisplay(' ', o_y_title, 'B');
    
    % A typical network response to a combination of tones before tinnitus
    s = SimParams.net.Evaluate(x_typical2);
    subplot(3,3,5)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to silence before tinnitus
    s = SimParams.net.Evaluate(x_silence);
    subplot(3,3,6)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
    SetGraphDisplay(' ', ' ', ' ');
    
end

% Load tinnitus results
if (isloaded)
    
    %   Load the Network
    SimParams.Files.duration    = dur;
    SimParams.Files.path        = path;
    SimParams.Files.filename    = filename;
    
    tmp = LoadResults(SimParams.Files);
    if (isstruct(tmp))
        
        SimParams = tmp;
        clear tmp;
        
        sig = SimParams.Attenuate.minval + ...
            (1 - SimParams.Attenuate.minval) * ...
            (1 ./ (1 + exp(- SimParams.Attenuate.beta .* ...
            (SimParams.Attenuate.f_0 - x_sig))));
        
        % Generate Attenuated Inputs
        x_typical1_a = Attenuate(x_typical1, SimParams.Attenuate);
        x_typical2_a = Attenuate(x_typical2, SimParams.Attenuate);
        x_silence_a = Attenuate(x_silence, SimParams.Attenuate);
        
        % A typical network response to pure tone after tinnitus
        s = SimParams.net.Evaluate(x_typical1_a);
        subplot(3,3,7)
        plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
            '--', lws, lw, lcs, lc3);
        yyaxis right;
        plot(1:SimParams.net.Outputs, sig, lws, lw, lcs, lc2);
        set(gca, 'YColor', lc2);
%       ylabel(sig_title);
        set(gca,'YLim',sig_y_lim,'YTick',sig_y_tick);
        yyaxis left;
        hold on;                                                % V2
        plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
        hold off;                                               % V2
        set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
        SetGraphDisplay(x_title, o_y_title, 'C');
        
        % typical network response to a combination of tones after tinnitus
        s = SimParams.net.Evaluate(x_typical2_a);
        subplot(3,3,8)
        plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
            '--', lws, lw, lcs, lc3);
        yyaxis right;
        plot(1:SimParams.net.Outputs, sig, lws, lw, lcs, lc2);
        set(gca, 'YColor', lc2);
%       ylabel(sig_title);
        set(gca,'YLim',sig_y_lim,'YTick',sig_y_tick);
        yyaxis left;
        hold on;                                                % V2
        plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
        hold off;                                               % V2
        set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
        SetGraphDisplay(x_title, ' ', ' ');
        
        % A typical network response to silence after tinnitus
        s = SimParams.net.Evaluate(x_silence_a);
        subplot(3,3,9)
        plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
            '--', lws, lw, lcs, lc3);
        yyaxis right;
        plot(1:SimParams.net.Outputs, sig, lws, lw, lcs, lc2);
        set(gca, 'YColor', lc2);
        ylabel(sig_title);
        set(gca,'YLim',sig_y_lim,'YTick',sig_y_tick);
        yyaxis left;
        hold on;                                                % V2
        plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
        hold off;                                               % V2
        set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
        SetGraphDisplay(x_title, ' ', ' ');
        
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
