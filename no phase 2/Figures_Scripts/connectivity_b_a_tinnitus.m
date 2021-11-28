% Create the connectivities graphs

wipe_all
addpath('..\');
SetConstants;
cm = 'gray';    % Colormap

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_connectivity_avg_prof';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = 0.35*xSize;
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
f_min       = 20;
f_max       = 20000;
freq        = logspace(log10(f_min), log10(f_max), inputs);
df_r        = 10;
df          = 1/log10(f_max/f_min);
% i_o_title   = 'Neuron No.';       % V1
i_title     = 'Input Neuron No.';   % V2
o_title     = 'Output Neuron No.';  %V2
i_lim       = [1, inputs];
i_tick      = [1, inputs/2, inputs];
di          = round((inputs - 1)*df);
di_lim      = [-di, di];
di_tick     = [-di, 0, di];
di_tick_lbl = [-1, 0, 1];
% di_tick_lbl = cellfun(@num2str, di_tick_lbl, 'UniformOutput', false);
o_lim       = [1, outputs];
o_tick      = [1, outputs/2, outputs];
do          = round((outputs - 1)*df);
do_lim      = [-do, do];
do_tick     = [-do, 0, do];
do_tick_lbl = di_tick_lbl;
y_title     = 'Connectivity';
y_W_lim     = [-2, 22];
y_W_tick    = [0, 10, 20];
% y_K_lim     = [-0.1, 0.6];    % V1
% y_K_tick    = [0, 0.2, 0.4];  % V1
y_K_lim     = [-0.05, 0.3];     % V2
y_K_tick    = [0, 0.1, 0.2];    % V2
x_title     = '$\Delta\log_{10}\!{\left(\mathrm{PF}\right)}$';
zones_fs    = 8;

% Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;

%   Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;

tmp = LoadResults(SimParams.Files);
if (isstruct(tmp))
    
    SimParams = tmp;
    clear tmp;
    
    % Cutoff frequencies
    f1 = round(SimParams.Attenuate.f_0*...
        SimParams.net.Outputs/SimParams.net.Inputs);
    f2 = SimParams.net.Outputs - f1;
    
    % Recurrent connections matrix after tinnitus
    subplot(1,2,1)
    imagesc(SimParams.net.K);
    colormap(cm); % colorbar;
    set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',o_lim,'YTick',o_tick);
    axis square;
    hold on;
    plot([1, SimParams.net.Outputs], f1.*[1, 1], ...
        '--', lws, lw/2, lcs, lc2);
    text(SimParams.net.Outputs + 1, f1/2, 'Non-dep.', ...
        'Color', lc2, ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'center', ...
        'Rotation', 90, ...
        'FontSize', zones_fs);
    text(SimParams.net.Outputs + 1, f1 + f2/2, 'Dep.', ...
        'Color', lc2, ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'center', ...
        'Rotation', 90, ...
        'FontSize', zones_fs);
    plot(f1.*[1, 1], [1, SimParams.net.Outputs], ...
        '--', lws, lw/2, lcs, lc2);
    text(f1/2, 0, 'Non-dep.', ...
        'Color', lc2, ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center', ...
        'FontSize', zones_fs);
    text(f1 + f2/2, 0, 'Dep.', ...
        'Color', lc2, ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center', ...
        'FontSize', zones_fs);
    hold off;
    %         SetGraphDisplay(i_o_title, ' ', 'E'); % V1
    SetGraphDisplay(o_title, o_title, 'A');     % V2
    sfig_e = gca;                           % V2
    
    % Recurrent connections matrix profile after tinnitus
    subplot(1,2,2)
    %         tmp = SimParams.net.K(SimParams.net.Outputs / 2,:);
    %         tmp(SimParams.net.Outputs / 2) = NaN;
    %         plot(1:SimParams.net.Outputs, tmp, lws, lw, lcs, lc1);
    %         set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',y_K_lim,'YTick',y_K_tick);
    prof1 = zeros(1, 2*f1 - 1);
    for i = 1:f1
        prof1((1:f1) + f1 - i) = ...
            prof1((1:f1) + f1 - i) + SimParams.net.K(i, 1:f1);
    end
    prof1 = prof1./f1;
    prof1(f1) = NaN;
    prof2 = zeros(1, 2*f2 - 1);
    for i = 1:f2
        prof2((1:f2) + f2 - i) = ...
            prof2((1:f2) + f2 - i) + SimParams.net.K(f1 + i, f1 + (1:f2));
    end
    prof2 = prof2./f2;
    prof2(f2) = NaN;
    %         f3 = min(f1, f2);
    %         prof_diff = prof2((f2 - f3 + 1):(f2 + f3 - 1)) - ...
    %             prof1((f1 - f3 + 1):(f1 + f3 - 1));
    p(2) = plot(-(f2 - 1):(f2 - 1), prof2, lws, lw, lcs, lc2);
    hold on;
    p(1) = plot(-(f1 - 1):(f1 - 1), prof1, lws, lw, lcs, lc1);
    %         p(3) = plot(-(f3 - 1):(f3 - 1), prof_diff, '--', lws, lw, lcs, lc3);
    hold off;
    set(gca,'XLim',do_lim,'XTick',do_tick,'XTickLabels',do_tick_lbl,'YLim',y_K_lim,'YTick',y_K_tick);
    ax = gca;
%     lx = axes('position', [ax.Position(1:2), 0.3, 0.4],'Box','on','XTick',[],'YTick',[]);
%     [leg, objs] = legend(lx, p, {'Non-deprived', 'Deprived'}, ...
%         'Interpreter', 'latex', 'Location', 'north');
%     %         leg.Position(4) = 1.1*leg.Position(4);
%     for i = 1:numel(objs)
%         if strcmp(get(objs(i), 'Type'), 'line')
%             set(objs(i), 'XData', [0.03, 0.15]);
%         else
%             text_pos = get(objs(i), 'Position');
%             text_pos(1) = 0.15 + 0.02;
%             set(objs(i), 'Position', text_pos);
%         end
%     end
%     lx.Position = [ax.Position(1) + 0.01, 0.9*leg.Position(2), ...
%         0.75*leg.Position(3), leg.Position(4)];
%     leg.Position(1:2) = lx.Position(1:2);
%     leg.Box = 'off';
%     leg.EdgeColor = 'k';
%     lx.XColor = 'k';
%     lx.YColor = 'k';
%     axes(ax);
    leg = legend(p, {'Non-deprived Region', 'Deprived Region'}, ...
        'Interpreter', 'latex', 'Location', 'north');
    leg.EdgeColor = 'k';
    SetGraphDisplay(x_title, y_title, 'B');
    
    % Squash the plots
    fig = gcf;
    for c = fig.Children'
        if ~isa(c, 'matlab.graphics.axis.Axes')
            continue;
        end
        c.Position(2) = 0.1 + c.Position(2);
        c.Position(4) = 0.83*c.Position(4);
    end
    leg.Position(2) = ax.Position(2) + ax.Position(4) - leg.Position(4);
end

%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-dtiff','-r300',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
