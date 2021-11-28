% Create the critical slowing down's graphs

wipe_all
addpath('..\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_critical_slowing_down_combined';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
% ySize = 1.3*xSize;
ySize = 1.2*xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

data_before = load('Critical.mat');
data_after = load('Critical_after.mat');

% Estimate critical points
crit_b = 4/data_before.spec_rad;        % V2
crit_a = 4/data_after.spec_rad;         % V2

% Scaling factor parameters
sig_max_over_crit   = 1.3;                                      % V2
sigma_min_b         = min(data_before.sigma);
% sigma_max_b         = max(data_before.sigma);                 % V1
sig_ind_b           = data_before.sigma < ...                    % V2
                    (sig_max_over_crit*crit_b);
sigma_max_b         = max(data_before.sigma(sig_ind_b));         % V2
sigma_min_a         = min(data_after.sigma);
% sigma_max_a         = max(data_after.sigma);                  % V1
% sigma_max_a         = max(data_after.sigma)/2;                % V2
sig_ind_a           = data_after.sigma < ...                    % V2
                    (sig_max_over_crit*crit_a);
sigma_max_a         = max(data_after.sigma(sig_ind_a));         % V2

% Axes Display
% x_title     = '$$\sigma$$';
x_title     = 'Scaling Factor, $$\sigma$$';
x_lim_b     = [sigma_min_b, sigma_max_b];
% x_tick_b    = sigma_min_b:1:sigma_max_b;      % V1
x_tick_b    = [sigma_min_b, 1, crit_b];         % V2
x_lim_a     = [sigma_min_a, sigma_max_a];
% x_tick_a    = sigma_min_a:1:sigma_max_a;      % V1
x_tick_a    = [sigma_min_a, 1, crit_a];         % V2

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
obj_b = subplot(4,2,1);   % V1
% obj_b = subplot(3,3,1:2);   % V2
% plot(data_before.sigma, data_before.obj_func_reg, lws, lw, lcs, lc2);  % V2
hold on;                                                               % V2
plot(data_before.sigma, data_before.obj_func, lws, lw, lcs, lc1);
hold off                                                               % V2
% set(gca,'XLim',x_lim_b,'XTick',x_tick_b,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_b,'XTick',x_tick_b);                   % V2
yl_b = ylim;
xticklabels({});

obj_a = subplot(4,2,2);   % V1
% obj_a = subplot(3,3,3);     % V2
% plot(data_after.sigma, data_after.obj_func_reg, lws, lw, lcs, lc2);    % V2
hold on;                                                               % V2
plot(data_after.sigma, data_after.obj_func, lws, lw, lcs, lc1);
hold off                                                               % V2
% set(gca,'XLim',x_lim_a,'XTick',x_tick_a,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_a,'XTick',x_tick_a);                   % V2
yl_a = ylim;
xticklabels({});

obj_ylim = [min(yl_b(1), yl_a(1)), max(yl_b(2), yl_a(2))];
obj_ylim = [obj_ylim(1) - 0.1*(obj_ylim(2) - obj_ylim(1)), obj_ylim(2)];
axes(obj_b);
% ylim(obj_ylim);   % V1
SetGraphDisplay(' ', {'Objective Function', '(Unregularized)'}, 'A');
yl = ylim; xl = xlim;
text(obj_b, xl(2)/2, yl(2), {'Before', 'Sensory Deprivation'}, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
axes(obj_a);
% ylim(obj_ylim);   % V1
% SetGraphDisplay(' ', ' ', 'E');
% SetGraphDisplay(' ', ' ', 'E');
SetGraphDisplay(' ', ' ', ' ');
yl = ylim; xl = xlim;
text(obj_a, xl(2)/2, yl(2), {'After', 'Sensory Deprivation'}, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

% The convergence time vs. the scaling factor
conv_b = subplot(4,2,3);  % V1
% conv_b = subplot(3,3,4:5);  % V2
plot(data_before.sigma, data_before.conv_time, lws, lw, lcs, lc1);
yyaxis right;
conv_der_b = diff(smooth(data_before.conv_time, 0.05, 'lowess'))/diff(data_before.sigma(1:2));
plot(data_before.sigma(1:(end - 1)), conv_der_b, ...
    lws, lw, lcs, lc2);
set(gca, 'YColor', lc2);
ax = gca;
ax.YAxis(2).Exponent = floor(log10(max(abs(conv_der_b))));
% ylabel('Derivative');
yyaxis left;
% set(gca,'XLim',x_lim_b,'XTick',x_tick_b,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_b,'XTick',x_tick_b);                   % V2
yl_b = ylim;
xticklabels({});

conv_a = subplot(4,2,4);  % V1
% conv_a = subplot(3,3,6);    % V2
plot(data_after.sigma, data_after.conv_time, lws, lw, lcs, lc1);
yyaxis right;
conv_der_a = diff(smooth(data_after.conv_time, 0.05, 'lowess'))/diff(data_after.sigma(1:2));
plot(data_after.sigma(1:(end - 1)), conv_der_a, ...
    lws, lw, lcs, lc2);
set(gca, 'YColor', lc2);
ax = gca;
ax.YAxis(2).Exponent = floor(log10(max(abs(conv_der_a))));
ylabel('Derivative');
yyaxis left;
% set(gca,'XLim',x_lim_a,'XTick',x_tick_a,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_a,'XTick',x_tick_a);                   % V2
yl_a = ylim;
xticklabels({});

conv_ylim = [min(yl_b(1), yl_a(1)), max(yl_b(2), yl_a(2))];
conv_ylim = [0, conv_ylim(2)];
axes(conv_b);
% ylim(conv_ylim);  % V1
SetGraphDisplay(' ', {'Convergence', 'Time'}, 'B');
axes(conv_a);
% ylim(conv_ylim);  % V1
% SetGraphDisplay(' ', ' ', 'F');
% SetGraphDisplay(' ', ' ', 'F');
SetGraphDisplay(' ', ' ', ' ');

% The population vector vs. the scaling factor
popvec_b = subplot(4,2,5);    % V1
% popvec_b = subplot(3,3,7:8);    % V2
plot(data_before.sigma, data_before.pop_vec, lws, lw, lcs, lc1);
yyaxis right;
plot(data_before.sigma(1:(end-1)), ...
    diff(smooth(data_before.pop_vec, 0.05, 'lowess'))/diff(data_before.sigma(1:2)), ...
    lws, lw, lcs, lc2);
set(gca, 'YColor', lc2);
yyaxis left;
% set(gca,'XLim',x_lim_b,'XTick',x_tick_b,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_b,'XTick',x_tick_b);                   % V2
xtickformat('%.2g');                                        % V2
xtickangle(-30);                                            % V2
yl_b = ylim;
% xticklabels({});
xticklabels({});

popvec_a = subplot(4,2,6);    % V1
% popvec_a = subplot(3,3,9);      % V2
% plot(data_after.sigma, data_after.pop_vec, lws, lw, lcs, lc1);       % V1
ind = data_after.sigma > x_lim_a(1) & data_after.sigma < x_lim_a(2);   % V2
plot(data_after.sigma(ind), data_after.pop_vec(ind), ...
    lws, lw, lcs, lc1);                                                % V2
yyaxis right;
sig_tmp = data_after.sigma(ind);
plot(sig_tmp(1:(end - 1)), ...
    diff(smooth(data_after.pop_vec(ind), 0.05, 'lowess'))/diff(data_after.sigma(1:2)), ...
    lws, lw, lcs, lc2);
set(gca, 'YColor', lc2);
ylabel('Derivative');
yyaxis left;
% set(gca,'XLim',x_lim_a,'XTick',x_tick_a,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_a,'XTick',x_tick_a);                   % V2
xtickformat('%.2g');                                        % V2
xtickangle(-30);                                            % V2
yl_a = ylim;
% xticklabels({});
xticklabels({});

popvec_ylim = [min(yl_b(1), yl_a(1)), max(yl_b(2), yl_a(2))];
popvec_ylim = [obj_ylim(1) - 0.1*(obj_ylim(2) - obj_ylim(1)), obj_ylim(2)];
axes(popvec_b);
% ylim(obj_ylim);   % V1
SetGraphDisplay(' ', {'Population Vector', '(Magnitude)'}, 'C');
axes(popvec_a);
% ylim(obj_ylim);   % V1
% SetGraphDisplay(' ', ' ', 'E');
% SetGraphDisplay(' ', ' ', 'G');
SetGraphDisplay(' ', ' ', ' ');

% The correlation vs. the scaling factor
corr_b = subplot(4,2,7);    % V1
% popvec_b = subplot(3,3,7:8);    % V2
plot(data_before.sigma, data_before.corr, lws, lw, lcs, lc1);
% yyaxis right;
% plot(data_before.sigma(1:(end-1)), ...
%     diff(smooth(data_before.corr, 0.05, 'lowess'))/diff(data_before.sigma(1:2)), ...
%     lws, lw, lcs, lc2);
% set(gca, 'YColor', lc2);
% yyaxis left;
% set(gca,'XLim',x_lim_b,'XTick',x_tick_b,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_b,'XTick',x_tick_b);                   % V2
xtickformat('%.2g');                                        % V2
xtickangle(-30);                                            % V2
yl_b = ylim;
% xticklabels({});

corr_a = subplot(4,2,8);    % V1
% popvec_a = subplot(3,3,9);      % V2
% plot(data_after.sigma, data_after.pop_vec, lws, lw, lcs, lc1);       % V1
ind = data_after.sigma > x_lim_a(1) & data_after.sigma < x_lim_a(2);   % V2
plot(data_after.sigma(ind), data_after.corr(ind), ...
    lws, lw, lcs, lc1);                                                % V2
% yyaxis right;
% sig_tmp = data_after.sigma(ind);
% plot(sig_tmp(1:(end - 1)), ...
%     diff(smooth(data_after.corr(ind), 0.05, 'lowess'))/diff(data_after.sigma(1:2)), ...
%     lws, lw, lcs, lc2);
% set(gca, 'YColor', lc2);
% ylabel('Derivative');
% yyaxis left;
% set(gca,'XLim',x_lim_a,'XTick',x_tick_a,'YTick',[ ]);     % V1
set(gca,'XLim',x_lim_a,'XTick',x_tick_a);                   % V2
xtickformat('%.2g');                                        % V2
xtickangle(-30);                                            % V2
yl_a = ylim;
% xticklabels({});

% popvec_ylim = [min(yl_b(1), yl_a(1)), max(yl_b(2), yl_a(2))];
% popvec_ylim = [0, popvec_ylim(2)];
axes(corr_b);
% ylim(popvec_ylim);
% ylim([0, yl_b(2)]);
ylim([yl_b(1), yl_b(2)]);
hold on;
set(gca, 'Clipping', 'off');
% [~, i] = min(data_before.obj_func);
% vert_pos = data_before.sigma(i);
% vert_pos = 4/data_before.spec_rad;        % V1
vert_pos = crit_b;                          % V2
yl = ylim;
% yl_top = 3.8*yl(2);
yl_top = yl(1) + fullscale*(yl(2) - yl(1));
plot(vert_pos.*[1, 1], [yl(1), yl_top], '--', lcs, lc2);
text(vert_pos, yl(1) + crit_point_height*(yl_top - yl(1)), crit_point_text, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
    'Color', lc2, 'Rotation', 90);
plot([1, 1], [yl(1), yl_top], '--', lcs, lc3);
text(1, yl(1) + op_point_height*(yl_top - yl(1)), op_point_text, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
    'Color', lc3, 'Rotation', 90);
% SetGraphDisplay(' ', {'Population Vector', '(Magnitude)'}, 'C');
SetGraphDisplay(x_title, {'Average Squared', 'Correlation Coefficient'}, 'D');

axes(corr_a);
% ylim(popvec_ylim);
% ylim([0, yl_a(2)]);
ylim([yl_a(1), yl_a(2)]);
hold on;
set(gca, 'Clipping', 'off');
% [~, i] = min(data_after.obj_func);
% vert_pos = data_after.sigma(i);
% vert_pos = 4/data_after.spec_rad;         % V1
vert_pos = crit_a;                          % V2
yl = ylim;
% yl_top = 3.8*yl(2);
yl_top = yl(1) + fullscale*(yl(2) - yl(1));
plot(vert_pos.*[1, 1], [yl(1), yl_top], '--', lcs, lc2);
text(vert_pos, yl(1) + crit_point_height*(yl_top - yl(1)), crit_point_text, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
    'Color', lc2, 'Rotation', 90);
plot([1, 1], [yl(1), yl_top], '--', lcs, lc3);
text(1, yl(1) + op_point_height*(yl_top - yl(1)), op_point_text, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
    'Color', lc3, 'Rotation', 90);
% SetGraphDisplay(' ', ' ', 'G');
% SetGraphDisplay(x_title, ' ', 'H');
SetGraphDisplay(x_title, ' ', ' ');

% axes(corr_b);
% ylim(corr_ylim);
% SetGraphDisplay(x_title, {'Average Squared', 'Correlation Coefficient'}, 'D');
% hold on;
% set(gca, 'Clipping', 'off');
% [~, i] = min(data_before.obj_func);
% vert_pos = data_before.sigma(i);
% yl = ylim;
% plot(vert_pos.*[1, 1], [yl(1), 3.95*yl(2)], '--', lcs, lc3);
% 
% axes(corr_a);
% ylim(corr_ylim);
% SetGraphDisplay(x_title, ' ', 'H');
% hold on;
% set(gca, 'Clipping', 'off');
% [~, i] = min(data_after.obj_func);
% vert_pos = data_after.sigma(i);
% yl = ylim;
% plot(vert_pos.*[1, 1], [yl(1), 3.95*yl(2)], '--', lcs, lc3);

% % The correlation vs. the scaling factor
% corr_b = subplot(4,2,7);
% plot(data_before.sigma, data_before.corr, lws, lw, lcs, lc1);
% set(gca,'XLim',x_lim_b,'XTick',x_tick_b,'YTick',[ ]);
% yl_b = ylim;
% 
% corr_a = subplot(4,2,8);
% plot(data_after.sigma, data_after.corr, lws, lw, lcs, lc1);
% set(gca,'XLim',x_lim_a,'XTick',x_tick_a,'YTick',[ ]);
% yl_a = ylim;
% 
% corr_ylim = [min(yl_b(1), yl_a(1)), max(yl_b(2), yl_a(2))];
% corr_ylim = [corr_ylim(1) - 0.1*(corr_ylim(2) - corr_ylim(1)), corr_ylim(2)];
% 
% axes(corr_b);
% ylim(corr_ylim);
% SetGraphDisplay(x_title, {'Average Squared', 'Correlation Coefficient'}, 'D');
% hold on;
% set(gca, 'Clipping', 'off');
% [~, i] = min(data_before.obj_func);
% vert_pos = data_before.sigma(i);
% yl = ylim;
% plot(vert_pos.*[1, 1], [yl(1), 3.95*yl(2)], '--', lcs, lc3);
% 
% axes(corr_a);
% ylim(corr_ylim);
% SetGraphDisplay(x_title, ' ', 'H');
% hold on;
% set(gca, 'Clipping', 'off');
% [~, i] = min(data_after.obj_func);
% vert_pos = data_after.sigma(i);
% yl = ylim;
% plot(vert_pos.*[1, 1], [yl(1), 3.95*yl(2)], '--', lcs, lc3);


%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-dtiff','-r300',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
