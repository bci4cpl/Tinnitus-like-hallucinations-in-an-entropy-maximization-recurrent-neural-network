% Create the neetwork's responses graphs

wipe_all
addpath('..\');
SetConstants;
ls_b = 'b-';  % Line Spec
ls_a = 'r-';  % Line Spec

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_K_eigen';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
xSize = 5;
ySize = 5;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,lcs,'w');

% Loading's Parameters
SetSize
dur             = 1000; % Duration to check for previous results (in days)
path            = '..\Results'; % Results directory
ridgeKval       = 0.182;
filename        = ['Auditory_' num2str(inputs) 'x' num2str(outputs) ...
    '_RidgeK_' num2str(ridgeKval) '_']; % Results file name

% Axes Display
x_title     = '$i$';
x_lim       = [0, outputs];
if (inputs < outputs)
    x_tick	= [0, inputs, outputs];
else
    x_tick	= [0, outputs];
end
y_title     = '$\Re\{\lambda_i\}$';
y_lim       = [-1, 4.5];
y_tick      = [0, 2, 4];

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
    
    % Recurrent eigenvalues before tinnitus
    eig_b = real(eig(SimParams.net.K));
    
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
        
        % Recurrent eigenvalues after tinnitus
        eig_a = real(eig(SimParams.net.K));
        
    end
end

% Recurrent eigenvalues before and after tinnitus
plot(1:SimParams.net.Outputs, eig_b, ls_b, lws, lw);
hold on;
plot(1:SimParams.net.Outputs, eig_a, ls_a, lws, lw);
hold off;
legend({'Before sensory deprivation', 'After sensory deprivation'});
set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
SetConstants;
set(gca,fss,fs);
box off;
xlabel(x_title, 'Interpreter', 'latex');
ylabel(y_title, 'Interpreter', 'latex');
h = title(['$\lambda_K$=' num2str(SimParams.net.Rec_ridge)], ...
    'Interpreter', 'latex');
set(h,fss,fs_letter);

%--------------------------------------
print(gcf,'-dpng','-r300',[fig_path fig_name]);
