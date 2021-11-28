% Create the neetwork's responses graphs

wipe_all
addpath('.\export_fig\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_response';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
% ySize = 1.3*xSize;
ySize = 1.5*xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

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

% Axes Display
x_title     = 'Neuron No.';
x_lim       = [0, outputs];
x_tick      = [0, outputs/2, outputs];
% y_title     = 'Activity';         % V1
i_y_title   = {'Input', 'Activity'};     % V2
o_y_title   = {'Output', 'Activity'};    % V2
y_lim       = [0, 1.05];
y_tick      = [0, 0.5, 1];
x_lim_inp   = [0, inputs];
x_tick_inp  = [0, inputs/2, inputs];
% y_lim_inp   = [-0.01, 0.25];  % V1
y_lim_inp   = [-0.01, 0.205];   % V2
y_tick_inp  = [0, 0.1, 0.2];
x_sig       = linspace(1, inputs, outputs);
sig_title   = {'Atten.', 'Profile'};
sig_y_lim   = [0, 1.05];
sig_y_tick  = [0, 1];

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
n_plot_rows = 2 + length(dirs);

% Load results before tinnitus

cd(['..\' dirs{1}]);
addpath('Figures_Scripts')
tmp = LoadResults(SimParams.Files, '_K_learned');
if (isstruct(tmp))
    
    isloaded = 1;
    SimParams = tmp;
    clear tmp;
    
    % Generate inputs
    ind1 = 655478;%randi(size(Samples.x, 2))
    x_typical1 = Samples.x(:, ind1);
%     ind2 = 171187;%randi(size(Samples.x, 2))  % V1
    ind2 = 773072;%randi(size(Samples.x, 2))    % V2
    x_typical2 = Samples.x(:, ind2);
%     x_typical2 = 0.05*ones(SimParams.net.Inputs,1);
%     x_typical2(SimParams.net.Inputs*2/5:SimParams.net.Inputs*3/5) = 0;
    x_silence = zeros(SimParams.net.Inputs,1);
    
    % Spontaneous activity      % V2
    spon_act = mean(SimParams.net.Evaluate(x_silence));
    
    % A typical network response to a combination of tones before tinnitus
    subplot(n_plot_rows,3,1)
    plot(1:SimParams.net.Inputs, x_typical1, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
    SetGraphDisplay(' ', i_y_title, 'A');
    
    % A typical network response to a combination of tones before tinnitus
    subplot(n_plot_rows,3,2)
    plot(1:SimParams.net.Inputs, x_typical2, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
%     SetGraphDisplay(' ', ' ', 'B');
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to silence before tinnitus
    subplot(n_plot_rows,3,3)
    plot(1:SimParams.net.Inputs, x_silence, lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim_inp,'XTick',x_tick_inp,'YLim',y_lim_inp,'YTick',y_tick_inp);
%     SetGraphDisplay(' ', ' ', 'C');
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to a combination of tones before tinnitus
    s = SimParams.net.Evaluate(x_typical1);
    subplot(n_plot_rows,3,4)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
%     SetGraphDisplay(' ', o_y_title, 'D');
    SetGraphDisplay(' ', o_y_title, 'B');
    
    % A typical network response to a combination of tones before tinnitus
    s = SimParams.net.Evaluate(x_typical2);
    subplot(n_plot_rows,3,5)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
%     SetGraphDisplay(' ', ' ', 'E');
    SetGraphDisplay(' ', ' ', ' ');
    
    % A typical network response to silence before tinnitus
    s = SimParams.net.Evaluate(x_silence);
    subplot(n_plot_rows,3,6)
    plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
        '--', lws, lw, lcs, lc3);
    hold on;                                                % V2
    plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
    hold off;                                               % V2
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
%     SetGraphDisplay(' ', ' ', 'F');
    SetGraphDisplay(' ', ' ', ' ');
    
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

            % Generate Attenuated Inputs
            x_typical1_a = Attenuate(x_typical1, SimParams.Attenuate);
            x_typical2_a = Attenuate(x_typical2, SimParams.Attenuate);
            x_silence_a = Attenuate(x_silence, SimParams.Attenuate);
            if ~isfield(SimParams.Attenuate, 'f_1')
                if ~startsWith(dirs{d}, 'low')
                    sig = SimParams.Attenuate.minval + ...
                        (1 - SimParams.Attenuate.minval) * ...
                        (1 ./ (1 + exp(- SimParams.Attenuate.beta .* ...
                        (SimParams.Attenuate.f_0 - x_sig))));
                else
                    sig = SimParams.Attenuate.minval + ...
                        (1 - SimParams.Attenuate.minval) * ...
                        (1 ./ (1 + exp(- SimParams.Attenuate.beta .* ...
                        (x_sig - SimParams.Attenuate.f_0))));
                end
            else
                sig = SimParams.Attenuate.minval + ...
                    (1 - SimParams.Attenuate.minval) .* ...
                    (1 - ...
                    (1 - 1 ./ (1 + exp(- SimParams.Attenuate.beta * ...
                    (SimParams.Attenuate.f_1 - x_sig)))) .* ...
                    (1 - 1 ./ (1 + exp(- SimParams.Attenuate.beta * ...
                    (x_sig - SimParams.Attenuate.f_2)))));
            end

            % A typical network response to pure tone after tinnitus
            s = SimParams.net.Evaluate(x_typical1_a);
            subplot(n_plot_rows,3,3*(1+d)+1)
            plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
                '--', lws, lw, lcs, lc3);
            yyaxis right;
            plot(1:SimParams.net.Outputs, sig, lws, lw, lcs, lc2);
            set(gca, 'YColor', lc2);
%             ylabel(sig_title);
            set(gca,'YLim',sig_y_lim,'YTick',sig_y_tick);
            yyaxis left;
            hold on;                                                % V2
            plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
            hold off;                                               % V2
            set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
%             SetGraphDisplay(x_title, o_y_title, 'G');
            if d == length(dirs)
                tmp_x_title = x_title;
            else
                tmp_x_title = ' ';
            end
%             subfig = char(double('C') + 3*d + 1);
            subfig = char(double('A') + d + 1);
            SetGraphDisplay(tmp_x_title, o_y_title, subfig);

            % typical network response to a combination of tones after tinnitus
            s = SimParams.net.Evaluate(x_typical2_a);
            subplot(n_plot_rows,3,3*(1+d)+2)
            plot([1, SimParams.net.Outputs], spon_act*[1, 1], ...   % V2
                '--', lws, lw, lcs, lc3);
            yyaxis right;
            plot(1:SimParams.net.Outputs, sig, lws, lw, lcs, lc2);
            set(gca, 'YColor', lc2);
%             ylabel(sig_title);
            set(gca,'YLim',sig_y_lim,'YTick',sig_y_tick);
            yyaxis left;
            hold on;                                                % V2
            plot(1:SimParams.net.Outputs, s, lws, lw, lcs, lc1);
            hold off;                                               % V2
            set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
%             SetGraphDisplay(x_title, ' ', 'H');
            if d == length(dirs)
                tmp_x_title = x_title;
            else
                tmp_x_title = ' ';
            end
%             subfig = char(double('C') + 3*d + 2);
%             SetGraphDisplay(tmp_x_title, ' ', subfig);
            SetGraphDisplay(tmp_x_title, ' ', ' ');

            % A typical network response to silence after tinnitus
            s = SimParams.net.Evaluate(x_silence_a);
            subplot(n_plot_rows,3,3*(1+d)+3)
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
%             SetGraphDisplay(x_title, ' ', 'I');
            if d == length(dirs)
                tmp_x_title = x_title;
            else
                tmp_x_title = ' ';
            end
%             subfig = char(double('C') + 3*d + 3);
%             SetGraphDisplay(tmp_x_title, ' ', subfig);
            SetGraphDisplay(tmp_x_title, ' ', ' ');

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
