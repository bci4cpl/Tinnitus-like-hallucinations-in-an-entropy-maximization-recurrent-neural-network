% Plot the Ridge coefficient's effect on the eigenvalues of the recurrent
% connectivity matrix

wipe_all;
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_ridge';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = xSize*2/3;
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

% Conditions (before/after sensory deprivation)
conds = {'before', 'after'};

spec_rads = cell(size(dirs));

curr_dir = pwd;
for d = 1:length(dirs)
    cd(['..\' dirs{d}]);
    
    % Set Size
    SetSize;
    
    % Load results
    
    RidgeK.filename = 'RidgeK.mat';
    if(exist(RidgeK.filename, 'file'))
        tmp = load(RidgeK.filename);
        RidgeK = tmp.RidgeK;
    else
        isloaded	= 0;
        return;
    end
    
    RidgeK.values = sort(unique(RidgeK.values));
    
    SimParams.Files.duration    = 1000; % Duration to check for previous results (in days)
    SimParams.Files.path        = '.\Results'; % Results directory
    SimParams.Files.filenamebeg = ['Auditory_' num2str(inputs) 'x' ...
        num2str(outputs) '_']; % Results file name beginning
    
    Results = cell(size(RidgeK.values));
    droplist = [];
    for k = 1:length(RidgeK.values)
        SimParams.Files.filename = [SimParams.Files.filenamebeg 'RidgeK_' ...
            num2str(RidgeK.values(k)) '_']; % Results file name
        
        tmp = LoadResults(SimParams.Files, '_K_learned');
        if (isstruct(tmp))
            Results{k}.before = tmp;
        else
            droplist = [droplist, k];
            continue;
        end
        clear tmp;
        
        tmp = LoadResults(SimParams.Files);
        if (isstruct(tmp))
            Results{k}.after = tmp;
        else
            droplist = [droplist, k];
            continue;
        end
        clear tmp;
    end
    
    RidgeK.values(droplist) = [];
    Results(droplist) = [];
    
    % Prepare the results
    spec_rads{d}.lambdaK = RidgeK.values;
    for c = 1:length(conds)
        spec_rads{d}.eigenK.(conds{c}) = ...
            cellfun(@(x) max(abs(eig(x.(conds{c}).net.K))), Results);
    end
    if ~isfield(Results{1}.after.Attenuate, 'f_1')
        beta = Results{1}.after.Attenuate.beta;
        if startsWith(dirs{d}, 'low')
            beta = -beta;
        end
        spec_rads{d}.leg = ['$$k_0 = ' num2str(Results{1}.after.Attenuate.f_0) ', ' ...
            '\beta = ' num2str(beta) '$$'];
    else
        spec_rads{d}.leg = ['$$k_1 = ' num2str(Results{1}.after.Attenuate.f_1) ', ' ...
            'k_2 = ' num2str(Results{1}.after.Attenuate.f_2)  ', $$' newline ...
            '$$\beta = ' num2str(Results{1}.after.Attenuate.beta) '$$'];
    end
    
    cd(curr_dir);
end

% Axes Display
bif.before  = 0.183;
bif.after   = 0.228;
bifs        = cellfun(@(x) bif.(x), conds);
x_title     = 'Regularization Coefficient, $$\lambda_K$$';
x_lim       = [min(RidgeK.values), max(RidgeK.values)];
% x_tick      = [min(RidgeK.values), bif1, bif2, max(RidgeK.values)];
x_tick      = sort([x_lim, bifs]);
y_title     = 'Spectral Radius, $$\rho\left(K\right)$$';
y_lim       = [-0.1, 4.1];
y_tick      = [0, 2, 4];
leg_s       = {['Before Sensory' newline 'Deprivation'], ...
               ['After Sensory' newline 'Deprivation']};

    
%     p(1) = plot(RidgeK.values, eigenK_before, lws, lw, lcs, lc1);
%     hold on;
%     p(2) = plot(RidgeK.values, eigenK_after, lws, lw, lcs, lc2);
%     hold on;
plot(x_lim, 4.*ones(size(x_lim)), '--', lcs, lc3);
hold on;
p(1) = plot(spec_rads{1}.lambdaK, spec_rads{1}.eigenK.before, ...
        lws, lw, lcs, lc1);
for d = 1:length(dirs)
    colw = (d - 1)/(length(dirs) - 1);
    col = colw*lc3 + (1 - colw)*lc2;
    p(d + 1) = plot(spec_rads{d}.lambdaK, spec_rads{d}.eigenK.after, ...
        lws, lw, lcs, col);
end
hold off;
xlim(x_lim); xticks(x_tick);
ylim(y_lim); yticks(y_tick);
% xtickangle(-30);
%     set(gca, 'Clipping', 'off');
%     vert_len = 2.4;
vert_len = 1;
hold on;
for b = 1:length(bifs)
    plot(bifs(b).*ones(size(y_lim)), ...
        [y_lim(1), y_lim(1) + (y_lim(2) - y_lim(1))*vert_len], ...
        '--', lcs, lc3);
end
hold off;
leg = legend(p, ...
    [leg_s(1), cellfun(@(x) x.leg, spec_rads, 'UniformOutput', false)], ...
    'Location', 'southwest', 'Interpreter', 'latex');
    leg.Position(4) = 1.1*leg.Position(4);
    leg.EdgeColor = 'k';
SetGraphDisplay(x_title, y_title, ' ');


%--------------------------------------
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
