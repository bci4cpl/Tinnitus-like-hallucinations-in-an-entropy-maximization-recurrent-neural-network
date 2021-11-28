% Plot the Ridge coefficient's effect on the eigenvalues of the recurrent
% connectivity matrix

wipe_all;
addpath('..\');
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
SimParams.Files.path        = '..\Results'; % Results directory
SimParams.Files.filenamebeg = ['Auditory_' num2str(inputs) 'x' ...
    num2str(outputs) '_']; % Results file name beginning

Results = cell(size(RidgeK.values));
droplist = [];
for k = 1:length(RidgeK.values)
    SimParams.Files.filename = [SimParams.Files.filenamebeg 'RidgeK_' ...
        num2str(RidgeK.values(k)) '_']; % Results file name
    
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

% Axes Display
bif1        = 0.183;
bif2        = 0.228;
x_title     = 'Regularization Coefficient, $$\lambda_K$$';
x_lim       = [min(RidgeK.values), max(RidgeK.values)];
x_tick      = [min(RidgeK.values), bif1, bif2, max(RidgeK.values)];
y_title     = 'Spectral Radius, $$\rho\left(K\right)$$';
y_lim       = [-0.1, 4.1];
y_tick      = [0, 2, 4];
leg_s       = {['Before Sensory' newline 'Deprivation'], ...
               ['After Sensory' newline 'Deprivation']};

% Prepare the results
eigenK_after    = cellfun(@(x) max(abs(eig(x.after.net.K))), Results);

p(1) = plot(RidgeK.values, eigenK_after, lws, lw, lcs, lc1);
hold on;
plot(x_lim, 4.*ones(size(x_lim)), '--', lcs, lc3);
% hold on;
% plot(x_lim, 2.*ones(size(x_lim)), '--', lcs, lc3);
hold on;
plot(bif1.*ones(size(y_lim)), y_lim, '--', lcs, lc3);
hold on;
plot(bif2.*ones(size(y_lim)), y_lim, '--', lcs, lc3);
hold off;
xlim(x_lim); xticks(x_tick);
ylim(y_lim); yticks(y_tick);
% xtickangle(-30);
SetGraphDisplay(x_title, y_title, ' ');

%--------------------------------------
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
