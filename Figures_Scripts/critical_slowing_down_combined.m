% Create the critical slowing down's graphs

wipe_all
SetConstants;

fold = 'A';
% fold = 'B';
% fold = 'Z';

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = ['Fig_critical_slowing_down_combined_' fold];

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
% ySize = 1.2*xSize;
ySize = 1.2*xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

% Directory per attenuation profile
all_dirs = {'shifted attenuation', ...
    'soft attenuation', ...
    'band attenuation', ...
    'low attenuation'};

% Take a pair of atten. profiles
if strcmp(fold, 'Z')
    dirs = {'no phase 2'};
else
    fold_size = 2;
    dirs = all_dirs(fold_size*(fold - 'A') + (1:fold_size));
end

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

% Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;

% Get results
curr_dir = pwd;
for d = 1:length(dirs)
    addpath(['..\' dirs{d} '\Figures_Scripts']);
    data_tmp = load('Critical_after.mat');
    rmpath(['..\' dirs{d} '\Figures_Scripts']);
    
    % Get attenuation profiles
    cd(['..\' dirs{d}]);
    Results = LoadResults(SimParams.Files);
    cd(curr_dir);
    if ~isfield(Results.Attenuate, 'f_1')
        beta = Results.Attenuate.beta;
        if startsWith(dirs{d}, 'low')
            beta = -beta;
        end
        data_tmp.title = ['$$k_0 = ' num2str(Results.Attenuate.f_0) '$$' ...
            newline ...
            '$$\beta = ' num2str(beta) '$$'];
    else
        data_tmp.title = ['$$k_1 = ' num2str(Results.Attenuate.f_1) ', ' ...
            'k_2 = ' num2str(Results.Attenuate.f_2)  '$$' newline ...
            '$$\beta = ' num2str(Results.Attenuate.beta) '$$'];
    end
    
    % Estimate critical points
    data_tmp.crit = 4/data_tmp.spec_rad;
        
    % Scaling factor parameters
    data_tmp.sig_max_over_crit  = 1.3;
    data_tmp.sigma_min          = min(data_tmp.sigma);
    data_tmp.sig_ind            = data_tmp.sigma < ...
                                  (data_tmp.sig_max_over_crit*data_tmp.crit);
    data_tmp.sigma_max          = max(data_tmp.sigma(data_tmp.sig_ind));

    % Axes Display
    data_tmp.x_title = 'Scaling Factor, $$\sigma$$';
    data_tmp.x_lim   = [data_tmp.sigma_min, data_tmp.sigma_max];
    data_tmp.x_tick  = [data_tmp.sigma_min, 1, data_tmp.crit];
    
    data(d) = data_tmp;
end


% Special points text
fullscale           = 5.15;
op_point_text       = 'Operating Point';
% op_point_height     = 0.58;                       % V1
op_point_height     = 0.515;                         % V2
% crit_point_text     = 'Critical Point';           % V1
crit_point_text     = 'Critical Point (Est.)';      % V2
% crit_point_height   = 0.38;                       % V1
crit_point_height   = 0.185;                         % V2

% The objective function vs. the scaling factor
for d = 1:length(dirs)
    obj(d) = subplot(4, length(dirs),  d);
    plot(data(d).sigma, data(d).obj_func, lws, lw, lcs, lc1);
    set(gca,'XLim',data(d).x_lim,'XTick',data(d).x_tick);
    yyaxis right;
    plot(NaN, NaN);
    ax = gca;
    ax.YAxis(2).Exponent = 1;
    ax.YAxis(2).Visible = false;
    yyaxis left;
    yls{d} = ylim;
    xticklabels({});
end
obj_ylim = [min(cellfun(@(l) l(1), yls)), max(cellfun(@(l) l(2), yls))];
obj_ylim = [obj_ylim(1) - 0.1*(obj_ylim(2) - obj_ylim(1)), obj_ylim(2)];
for d = 1:length(dirs)
    axes(obj(d));
    if d == 1
        y_title     = {'Objective Function', '(Unregularized)'};
        sfig_title  = 'A';
    else
        y_title     = ' ';
        sfig_title  = ' ';
    end
    SetGraphDisplay(' ', y_title, sfig_title);
    yl = ylim; xl = xlim;
    text(obj(d), xl(2)/2, yl(2), data(d).title, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

% The convergence time vs. the scaling factor
for d = 1:length(dirs)
    conv(d) = subplot(4, length(dirs), length(dirs) + d);
    plot(data(d).sigma, data(d).conv_time, lws, lw, lcs, lc1);
    yyaxis right;
    conv_der = diff(smooth(data(d).conv_time, 0.05, 'lowess'))/diff(data(d).sigma(1:2));
    plot(data(d).sigma(1:(end - 1)), conv_der, ...
        lws, lw, lcs, lc2);
    set(gca, 'YColor', lc2);
    ax = gca;
    ax.YAxis(2).Exponent = floor(log10(max(abs(conv_der))));
    if d == length(dirs)
        ylabel('Derivative');
    end
    yyaxis left;
    set(gca,'XLim',data(d).x_lim,'XTick',data(d).x_tick);                   % V2
    yls{d} = ylim;
    xticklabels({});
end
conv_ylim = [min(cellfun(@(l) l(1), yls)), max(cellfun(@(l) l(2), yls))];
conv_ylim = [0, conv_ylim(2)];
for d = 1:length(dirs)
    axes(conv(d));
    if d == 1
        y_title     = {'Convergence', 'Time'};
        sfig_title  = 'B';
    else
        y_title     = ' ';
        sfig_title  = ' ';
    end
    SetGraphDisplay(' ', y_title, sfig_title);
end

% The population vector vs. the scaling factor
for d = 1:length(dirs)
    popvec(d) = subplot(4, length(dirs), 2*length(dirs) + d);
    plot(data(d).sigma, data(d).pop_vec, lws, lw, lcs, lc1);
    yyaxis right;
    popvec_der = diff(smooth(data(d).pop_vec, 0.05, 'lowess'))/diff(data(d).sigma(1:2));
    plot(data(d).sigma(1:(end - 1)), popvec_der, ...
        lws, lw, lcs, lc2);
    set(gca, 'YColor', lc2);
    ax = gca;
    ax.YAxis(2).Exponent = floor(log10(max(abs(popvec_der))));
    if d == length(dirs)
        ylabel('Derivative');
    end
    yyaxis left;
    set(gca,'XLim',data(d).x_lim,'XTick',data(d).x_tick);
    yls{d} = ylim;
    xticklabels({});
end
for d = 1:length(dirs)
    axes(popvec(d));
    if d == 1
        y_title     = {'Population Vector', '(Magnitude)'};
        sfig_title  = 'C';
    else
        y_title     = ' ';
        sfig_title  = ' ';
    end
    SetGraphDisplay(' ', y_title, sfig_title);
end

% The correlation vs. the scaling factor
for d = 1:length(dirs)
    corr(d) = subplot(4, length(dirs), 3*length(dirs) + d);
    ind = data(d).sigma > data(d).x_lim(1) & data(d).sigma < data(d).x_lim(2);
    plot(data(d).sigma(ind), data(d).corr(ind), ...
        lws, lw, lcs, lc1);
    set(gca,'XLim',data(d).x_lim,'XTick',data(d).x_tick);
    xtickformat('%.2g');
    xtickangle(-30);
    yyaxis right;
    plot(NaN, NaN);
    ax = gca;
    ax.YAxis(2).Exponent = 1;
    ax.YAxis(2).Visible = false;
    yyaxis left;
    yls{d} = ylim;
end

for d = 1:length(dirs)
   axes(corr(d));
   ylim(yls{d});
   hold on;
   set(gca, 'Clipping', 'off');
   vert_pos = data(d).crit;
   yl = ylim;
   yl_top = yl(1) + fullscale*(yl(2) - yl(1));
   plot(vert_pos.*[1, 1], [yl(1), yl_top], '--', lcs, lc2);
   text(vert_pos, yl(1) + crit_point_height*(yl_top - yl(1)), crit_point_text, ...
       'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
       'Color', lc2, 'Rotation', 90);
   plot([1, 1], [yl(1), yl_top], '--', lcs, lc3);
   text(1, yl(1) + op_point_height*(yl_top - yl(1)), op_point_text, ...
       'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
       'Color', lc3, 'Rotation', 90);
   if d == 1
       y_title     = {'Average Squared', 'Correlation Coefficient'};
       sfig_title  = 'D';
   else
       y_title     = ' ';
       sfig_title  = ' ';
   end
   SetGraphDisplay(data(d).x_title, y_title, sfig_title);
end

sfig_width = corr(length(dirs)).Position(3);
for d = 1:length(dirs)
    obj(d).Position(3)      = sfig_width;
    conv(d).Position(3)     = sfig_width;
    popvec(d).Position(3)   = sfig_width;
    corr(d).Position(3)     = sfig_width;
end


%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-dtiff','-r300',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');