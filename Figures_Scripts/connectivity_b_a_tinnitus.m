% Create the connectivities graphs

wipe_all
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
ySize = xSize*1.3;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

% Directory per attenuation profile
dirs = {'shifted attenuation', ...
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
y_K_lim     = [-0.05, 0.32];     % V2
y_K_tick    = [0, 0.1, 0.2];    % V2
x_title     = '$\Delta\log_{10}\!{\left(\mathrm{PF}\right)}$';
zones_fs    = 8;
n_rows   = length(dirs);

% Load the Network
SimParams.Files.duration    = dur;
SimParams.Files.path        = path;
SimParams.Files.filename    = filename;
isloaded = 0;

curr_dir = pwd;

% Load results before tinnitus
cd(['..\' dirs{1}]);
tmp = LoadResults(SimParams.Files, '_K_learned');
cd(curr_dir);
if (isstruct(tmp))
    
    isloaded = 1;
    SimParams = tmp;
    clear tmp;
    
%     % FF connections matrix
%     subplot(2,3,1)
%     
%     % Turn subfig A into a rectangle                % V2
% %     imagesc(SimParams.net.W);                     % V1
%     W_pad = 0.3*(i_lim(2) - i_lim(1));              % V2
%     W_i_lim = [i_lim(1), i_lim(2) + W_pad];         % V2
%     plot([i_lim(2), W_i_lim(2), W_i_lim(2)], ...    % V2
%         [o_lim(2), o_lim(2), o_lim(1)], ...
%         'Color', get(gca, 'Color'), 'LineWidth', 5);
%     set(gca, 'Layer', 'Bottom');                    % V2
%     hold on;                                        % V2
%     imagesc(SimParams.net.W(:, 1:(end - SimParams.net.Threshold)));    % V2
%     hold off;                                       % V2
%     colormap(cm); % colorbar;
% %     set(gca,'XLim',i_lim,'XTick',i_tick,'YLim',o_lim,'YTick',o_tick);% V1
%     set(gca,'XLim',W_i_lim,'XTick',i_tick,'YLim',o_lim,'YTick',o_tick);% V2
%     axis square;
%     axis ij;                                        % V2
% %     set(gca, 'YAxisLocation', 'origin');          % V2
% %     SetGraphDisplay(i_o_title, i_o_title, 'A');   % V1
%     SetGraphDisplay(i_title, o_title, 'A');         % V2
    
%     % FF connections matrix profile
%     subplot(2,3,4)
% %     plot(1:SimParams.net.Inputs, SimParams.net.W(SimParams.net.Outputs/2, 1:SimParams.net.Inputs), lws, lw, lcs, lc1);
% %     set(gca,'XLim',i_lim,'XTick',i_tick,'YLim',y_W_lim,'YTick',y_W_tick);
%     prof = zeros(1, 2*SimParams.net.Inputs - 1);
%     frac = SimParams.net.Inputs/SimParams.net.Outputs;
%     for i = 1:SimParams.net.Outputs
%         prof((1:SimParams.net.Inputs) + floor(frac*(SimParams.net.Outputs - i))) = ...
%             prof((1:SimParams.net.Inputs) + floor(frac*(SimParams.net.Outputs - i))) ...
%             + SimParams.net.W(i, 1:SimParams.net.Inputs);
%     end
%     prof = prof./SimParams.net.Outputs;
% %     prof = prof(ceil(SimParams.net.Inputs/2 + 1):floor(3*SimParams.net.Inputs/2 - 1));
% %     hi = floor(SimParams.net.Inputs/2 - 1);
%     plot(-(SimParams.net.Inputs-1):(SimParams.net.Inputs-1), prof, lws, lw, lcs, lc1);
%     set(gca,'XLim',di_lim,'XTick',di_tick,'XTickLabels',di_tick_lbl,'YLim',y_W_lim,'YTick',y_W_tick);
%     SetGraphDisplay(x_title, y_title, 'B');
    
%     % Recurrent connections matrix before tinnitus
%     subplot(2,n_columns,1)
%     imagesc(SimParams.net.K);
%     colormap(cm); % colorbar;
%     set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',o_lim,'YTick',o_tick);
%     axis square;
% %     SetGraphDisplay(i_o_title, ' ', 'C'); % V1
%     SetGraphDisplay(o_title, o_title, 'A');     % V2
%     sfig_c = gca;                           % V2
%     
%     % Recurrent connections matrix profile before tinnitus
%     subplot(2,n_columns,n_columns + 1)
% %     tmp = SimParams.net.K(SimParams.net.Outputs / 2,:);
% %     tmp(SimParams.net.Outputs / 2) = NaN;
% %     plot(1:SimParams.net.Outputs, tmp, lws, lw, lcs, lc1);
% %     set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',y_K_lim,'YTick',y_K_tick);
%     prof = zeros(1, 2*SimParams.net.Outputs - 1);
%     for i = 1:SimParams.net.Outputs
%         prof((1:SimParams.net.Outputs) + SimParams.net.Outputs - i) = ...
%             prof((1:SimParams.net.Outputs) + SimParams.net.Outputs - i) ...
%             + SimParams.net.K(i, 1:SimParams.net.Outputs);
%     end
%     prof = prof./SimParams.net.Outputs;
%     prof(SimParams.net.Outputs) = NaN;
% %     prof = prof(ceil(SimParams.net.Outputs/2 + 1):floor(3*SimParams.net.Outputs/2 - 1));
% %     ho = floor(SimParams.net.Outputs/2 - 1);
%     plot(-(SimParams.net.Outputs-1):(SimParams.net.Outputs-1), prof, lws, lw, lcs, lc1);
%     set(gca,'XLim',do_lim,'XTick',do_tick,'XTickLabels',do_tick_lbl,'YLim',y_K_lim,'YTick',y_K_tick);
%     SetGraphDisplay(x_title, y_title, 'B');
    
end

% Load tinnitus results
if (isloaded)
    
    for d = 1:length(dirs)
        
        cd(['..\' dirs{d}]);
        
        %   Load the Network
        SimParams.Files.duration    = dur;
        SimParams.Files.path        = path;
        SimParams.Files.filename    = filename;
        
        tmp = LoadResults(SimParams.Files);
        
        inputs = tmp.net.Inputs;
        outputs = tmp.net.Outputs;
        K = tmp.net.K;
        
        cd(curr_dir);
        
        if (isstruct(tmp))
            
            SimParams = tmp;
            clear tmp;
            
            % Cutoff frequencies
            if isfield(SimParams.Attenuate, 'f_1')
                f1 = round(SimParams.Attenuate.f_1*...
                    outputs/inputs);
                f2 = round(SimParams.Attenuate.f_2*...
                    outputs/inputs) - f1;
            else
                f1 = round(SimParams.Attenuate.f_0*...
                    outputs/inputs);
                f2 = outputs - f1;
            end
            f3 = outputs - f2 - f1;
            f4 = max(f1, f3);
            
            % Recurrent connections matrix after tinnitus
            subplot(n_rows,2,2*d - 1)
            imagesc(K);
            colormap(cm); % colorbar;
            set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',o_lim,'YTick',o_tick);
            axis square;
            hold on;
            plot([1, outputs], f1.*[1, 1], ...
                '--', lws, lw/2, lcs, lc2);
            plot([1, outputs], (f1 + f2).*[1, 1], ...
                '--', lws, lw/2, lcs, lc2);
            if f1 >= 200
                dnd_text1 = 'Non-dep.';
            else
                dnd_text1 = 'N.D.';
            end
            dnd_text2 = 'Dep.';
            if startsWith(dirs{d}, 'low')
                [dnd_text1, dnd_text2] = deal(dnd_text2, dnd_text1);
            end
            if f3 == 0
                dnd_text3 = '';
            elseif f3 >= 200
                dnd_text3 = 'Non-dep.';
            else
                dnd_text3 = 'N.D.';
            end
            text(outputs + 1, f1/2, dnd_text1, ...
                'Color', lc2, ...
                'VerticalAlignment', 'top', ...
                'HorizontalAlignment', 'center', ...
                'Rotation', 90, ...
                'FontSize', zones_fs);
            text(outputs + 1, f1 + f2/2, dnd_text2, ...
                'Color', lc2, ...
                'VerticalAlignment', 'top', ...
                'HorizontalAlignment', 'center', ...
                'Rotation', 90, ...
                'FontSize', zones_fs);
            text(outputs + 1, f1 + f2 + f3/2, dnd_text3, ...
                'Color', lc2, ...
                'VerticalAlignment', 'top', ...
                'HorizontalAlignment', 'center', ...
                'Rotation', 90, ...
                'FontSize', zones_fs);
            plot(f1.*[1, 1], [1, outputs], ...
                '--', lws, lw/2, lcs, lc2);
            plot((f1 + f2).*[1, 1], [1, outputs], ...
                '--', lws, lw/2, lcs, lc2);
            text(f1/2, 0, dnd_text1, ...
                'Color', lc2, ...
                'VerticalAlignment', 'bottom', ...
                'HorizontalAlignment', 'center', ...
                'FontSize', zones_fs);
            text(f1 + f2/2, 0, dnd_text2, ...
                'Color', lc2, ...
                'VerticalAlignment', 'bottom', ...
                'HorizontalAlignment', 'center', ...
                'FontSize', zones_fs);
            text(f1 + f2 + f3/2, 0, dnd_text3, ...
                'Color', lc2, ...
                'VerticalAlignment', 'bottom', ...
                'HorizontalAlignment', 'center', ...
                'FontSize', zones_fs);
            hold off;
            %         SetGraphDisplay(i_o_title, ' ', 'E'); % V1
            if d == length(dirs)
                tmp_x_title = o_title;
            else
                tmp_x_title = ' ';
            end
            SetGraphDisplay(tmp_x_title, o_title, ...
                char(double('A') + d - 1));     % V2
%                 char(double('A') + 2*(d - 1)));     % V2
            sfig_e = gca;                           % V2
            
            % Recurrent connections matrix profile after tinnitus
            subplot(n_rows,2,2*d)
            %         tmp = SimParams.net.K(SimParams.net.Outputs / 2,:);
            %         tmp(SimParams.net.Outputs / 2) = NaN;
            %         plot(1:SimParams.net.Outputs, tmp, lws, lw, lcs, lc1);
            %         set(gca,'XLim',o_lim,'XTick',o_tick,'YLim',y_K_lim,'YTick',y_K_tick);
            prof1 = zeros(1, 2*f1 - 1);
            for i = 1:f1
                prof1((1:f1) + f1 - i) = ...
                    prof1((1:f1) + f1 - i) + K(i, 1:f1);
            end
            prof1 = prof1./f1;
            prof1(f1) = NaN;
            prof2 = zeros(1, 2*f2 - 1);
            for i = 1:f2
                prof2((1:f2) + f2 - i) = ...
                    prof2((1:f2) + f2 - i) + K(f1 + i, f1 + (1:f2));
            end
            prof2 = prof2./f2;
            prof2(f2) = NaN;
            if f3 == 0
                prof4 = prof1;
            else
                prof3 = zeros(1, 2*f3 - 1);
                for i = 1:f3
                    prof3((1:f3) + f3 - i) = ...
                        prof3((1:f3) + f3 - i) + K(f2 + i, f2 + (1:f3));
                end
                prof3 = prof3./f3;
                prof3(f3) = NaN;
                prof4 = zeros(1, 2*f4 - 1);
                prof4((f4-f1+1):(f4+f1-1)) = prof4((f4-f1+1):(f4+f1-1)) + (f1 - 1).*prof1;
                prof4((f4-f3+1):(f4+f3-1)) = prof4((f4-f3+1):(f4+f3-1)) + (f3 - 1).*prof3;
                prof4 = prof4./(f1 + f3);
            end
            if startsWith(dirs{d}, 'low')
                [f2,    f4]    = deal(f4,    f2);
                [prof2, prof4] = deal(prof4, prof2);
            end
            p(2) = plot(-(f2 - 1):(f2 - 1), prof2, lws, lw, lcs, lc2);
            hold on;
            p(1) = plot(-(f4 - 1):(f4 - 1), prof4, lws, lw, lcs, lc1);
            set(gca,'XLim',do_lim,'XTick',do_tick,'XTickLabels',do_tick_lbl,'YLim',y_K_lim,'YTick',y_K_tick);
            ax = gca;
%             lx = axes('position', [ax.Position(1:2), 0.3, 0.4],'Box','on','XTick',[],'YTick',[]);
%             [leg, objs] = legend(lx, p, {'Non-deprived', 'Deprived'}, ...
%                 'Interpreter', 'latex', 'Location', 'north');
%             %         leg.Position(4) = 1.1*leg.Position(4);
%             for i = 1:numel(objs)
%                 if strcmp(get(objs(i), 'Type'), 'line')
%                     set(objs(i), 'XData', [0.03, 0.15]);
%                 else
%                     text_pos = get(objs(i), 'Position');
%                     text_pos(1) = 0.15 + 0.02;
%                     set(objs(i), 'Position', text_pos);
%                 end
%             end
%             lx.Position = [ax.Position(1) + 0.01, 0.9*leg.Position(2), ...
%                 0.75*leg.Position(3), leg.Position(4)];
%             leg.Position(1:2) = lx.Position(1:2);
%             leg.Box = 'off';
%             leg.EdgeColor = 'k';
%             lx.XColor = 'k';
%             lx.YColor = 'k';
%             axes(ax);
            if d == 1
                leg = legend(p, {'Non-deprived Region', 'Deprived Region'}, ...
                    'Interpreter', 'latex', 'Location', 'north');
                leg.EdgeColor = 'k';
                leg.Position(2) = ax.Position(2) + ax.Position(4) - leg.Position(4);
            end
            if d == length(dirs)
                tmp_x_title = x_title;
            else
                tmp_x_title = ' ';
            end
            SetGraphDisplay(tmp_x_title, y_title, ...
                char(double('A') + length(dirs) + d - 1));
%                 char(double('A') + 2*(d - 1) + 1));
            
        end
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
