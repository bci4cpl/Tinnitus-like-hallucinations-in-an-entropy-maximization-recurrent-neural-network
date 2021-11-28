% Create the critical slowing down's graphs

wipe_all
addpath('..\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_critical_slowing_down_after';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = 1.3*xSize;
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

% Scaling factor parameters
% d_sigma     = 0.01;   % V1
% sigma_min   = 0;      % V1
% sigma_max   = 2;      % V1
d_sigma     = 0.01;
sigma_min   = 0;
sigma_max   = 4;

% Other parameters
n_samples   = 50;
% n_iter      = 10000;    % V1
n_iter      = 1e8;      % V2

% Axes Display
% x_title     = '$$\sigma$$';
x_title     = 'Scaling Factor';
x_lim       = [sigma_min, sigma_max];
x_tick      = sigma_min:1:sigma_max;

is_loaded = 0;
try
    load('Critical_after.mat');
catch
    
    % Get Samples
    if(~exist('Samples', 'var') == 1)
        GetSamples;
    end
    
    % Load the Network
    SimParams.Files.duration    = dur;
    SimParams.Files.path        = path;
    SimParams.Files.filename    = filename;
    
    % Load results before tinnitus
    tmp = LoadResults(SimParams.Files);
    if (isstruct(tmp))
        
        SimParams = tmp;
        clear tmp;
        
        % Temporary variables
        x           = Samples.x(:, 1:n_samples);
        y           = zeros(SimParams.net.Outputs, n_samples);
        C           = zeros(size(y,1),size(y,1));
        cov_mask    = ones(size(C)) - eye(size(C,1));
        K           = SimParams.net.K;
        sigma       = sigma_min:d_sigma:sigma_max;
        obj_func    = zeros(size(sigma));
        obj_func_reg    = zeros(size(sigma));                   % V2
        W_reg           = SimParams.net.FF_ridge * ...
                            sum(abs(SimParams.net.W(:)));       % V2
        conv_time   = zeros(size(sigma));
        niter       = SimParams.net.niter;
        corr        = zeros(size(sigma));
        pop_vec     = zeros(size(sigma));
        spec_rad    = max(abs(eig(SimParams.net.K)));
        
        for i = 1:length(sigma)
            
            % Rescale the recurrent matrix
            SimParams.net.K = sigma(i) * K;
            
            % Calculate the objective function
            obj_func(i)     = SimParams.net.GetCost(x);
            K_reg           = (SimParams.net.Rec_ridge) * ...
                                sum((SimParams.net.K(:)).^2);                 % V2
            obj_func_reg(i) = obj_func(i) + W_reg + K_reg;      % V2
            
            % Calculate the convergence time
            SimParams.net.niter = n_iter;
            conv_time(i)        = 0;
            for k = 1:n_samples
                t               = SimParams.net.GetNIter(x(:,k));
                conv_time(i)    = conv_time(i) + t;
            end
            conv_time(i)            = conv_time(i) / n_samples;
            SimParams.net.niter     = niter;
            
            % Calculate the correlation
            for k = 1:n_samples
                y(:,k) = SimParams.net.Evaluate(x(:,k));
            end
            C       = corrcoef(y') .* cov_mask;
            corr(i) = (1/(size(C,1)*(size(C,1) - 1))) * trace(C^2);
            
            pop_vec(i) = SimParams.net.GetPopulationVector(n_samples);
            
            disp(['sigma ' num2str(sigma(i)) ' done. ']);
            
        end
        
        clc
        
        save('Critical_after.mat', ...
            'sigma', 'obj_func', 'conv_time', 'corr', 'pop_vec', ...
            'spec_rad', ...
            'obj_func_reg');                                    % V2
        
    end
end


% The objective function vs. the scaling factor
subplot(4,1,1)
plot(sigma, obj_func, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YTick',[ ]);
yl = ylim;
ylim([yl(1) - 0.1*(yl(2) - yl(1)), yl(2)]);
xticklabels({});
SetGraphDisplay(' ', {'Objective Function', '(Unregularized)'}, 'A');

% The convergence time vs. the scaling factor
subplot(4,1,2)
plot(sigma, conv_time, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YTick',[ ]);
ylim([0, max(ylim)]);
xticklabels({});
SetGraphDisplay(' ', {'Convergence', 'Time'}, 'B');

% The population vector vs. the scaling factor
subplot(4,1,3)
plot(sigma, pop_vec, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YTick',[ ]);
ylim([0, max(ylim)]);
xticklabels({});
SetGraphDisplay(' ', {'Population Vector', '(Magnitude)'}, 'C');

% The correlation vs. the scaling factor
subplot(4,1,4)
plot(sigma, corr, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YTick',[ ]);
yl = ylim;
ylim([yl(1) - 0.1*(yl(2) - yl(1)), yl(2)]);
yl = ylim;
SetGraphDisplay(x_title, {'Average Squared', 'Correlation Coefficient'}, 'D');
hold on;
set(gca, 'Clipping', 'off');
% [~, i] = min(obj_func);
% vert_pos = sigma(i);
vert_pos = 4/spec_rad;
plot(vert_pos.*[1, 1], [yl(1), 3.85*yl(2)], '--', lcs, lc3);


%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-dtiff','-r300',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
