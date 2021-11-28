% Create the stimuli's graphs

wipe_all;
addpath('.\export_fig\');
SetConstants;
with_architecture = false;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_stimuli';
image_name  = 'OCRecArchGray.tif';

% This does not have any meaning, the results file simply has to exist. 
ridgeKval   = 0.226;

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
% ySize = xSize;
ySize = 1.1*xSize;
% ySize = 8.75;
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

% Get Samples
addpath(['..\' dirs{1}]);
if(~exist('Samples', 'var') == 1)
    GetSamples;
end
rmpath(['..\' dirs{1}]);
inputs = size(Samples.x, 1);

% Axes Normalization
f_min = 20;
f_max = 20000;
f_inp = logspace(log10(f_min), log10(f_max), inputs);
Nf = 10*inputs;
x_sig = linspace(1, inputs, Nf);
f_sig = logspace(log10(f_min), log10(f_max), Nf);

% Axes Display
if with_architecture
    arch_height = 4;
else
    arch_height = 0;
end
x_title     = 'Frequency (Hz)';
x_lim       = [f_min, f_max];
x_tick      = [f_min, f_min*10, f_max/10, f_max];
y_title     = 'Activity';
% y_lim       = [0, 0.15];
y_lim       = [0, 0.2];
y_tick      = [ ];
y2_title     = {' ', 'Atten.', 'Profile'};
y2_lim       = [0, 1.01];
y2_tick      = [0, 1];

if with_architecture
    % Read network architecture image
    im_org = imread([fig_path image_name]);
    % im_new(:,:,1) = im_org(:,:,4);
    % im_new(:,:,2) = im_org(:,:,4);
    % im_new(:,:,3) = im_org(:,:,4);
    % im_new = 255 - im_new;
    im_new = im_org(:, :, 1:(end-1));
    % if length(size(im_new)) < 3
    %     im_new = repmat(im_new, [1, 1, 3]);
    % end
    im_alpha = im_org(:, :, end);
end

% Generate inputs
% % ind = randi(size(Samples.x, 2))
% % x_typical = Samples.x(:, 171187); % V1
% x_typical = Samples.x(:, 773072);   % V2
inds = [171187, 655478, 773072];%randi(size(Samples.x, 2))
x_typical = Samples.x(:, inds);

% Generate Attenuated Inputs
x_typical_a = zeros([size(x_typical), length(dirs)]);
sig = zeros(Nf, length(dirs));
curr_dir = pwd;
for d = 1:length(dirs)
    cd(['..\' dirs{d}]);
    SetSize;
    [~, SimParams, ~]   = LoadCurrent(ridgeKval);
    AttenuateParams     = SimParams.Attenuate;
    for i = 1:size(x_typical, 2)
        x_typical_a(:, i, d) = Attenuate(x_typical(:, i), AttenuateParams);
    end
    if ~isfield(AttenuateParams, 'f_1')
        if ~startsWith(dirs{d}, 'low')
            sig(:, d) = AttenuateParams.minval + ...
                (1 - AttenuateParams.minval) * ...
                (1 ./ (1 + exp(- AttenuateParams.beta .* ...
                (AttenuateParams.f_0 - x_sig))));
        else
            sig(:, d) = AttenuateParams.minval + ...
                (1 - AttenuateParams.minval) * ...
                (1 ./ (1 + exp(- AttenuateParams.beta .* ...
                (x_sig - AttenuateParams.f_0))));
        end
    else
        sig(:, d) = AttenuateParams.minval + ...
            (1 - AttenuateParams.minval) .* ...
            (1 - ...
            (1 - 1 ./ (1 + exp(- AttenuateParams.beta * ...
            (AttenuateParams.f_1 - x_sig)))) .* ...
            (1 - 1 ./ (1 + exp(- AttenuateParams.beta * ...
            (x_sig - AttenuateParams.f_2)))));
    end
    cd(curr_dir);
end

% % Network Architecture
% subplot(3,2,1:4)
% h = imshow(im_new);
% set(h, 'AlphaData', im_alpha, 'AlphaDataMapping', 'scaled');
% axis off;
% SetGraphDisplay(' ', ' ', 'A');

for i = 1:size(x_typical, 2)
    
    % A typical input
    subplot(arch_height + length(dirs) + 1, size(x_typical, 2), ...
        arch_height*size(x_typical, 2) + i);
    semilogx(f_inp, x_typical(:, i), lws, lw, lcs, lc1);
    set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
    if i == 1
        sfig_title  = char(double('A') + with_architecture);
        hp = SetGraphDisplay(' ', y_title, sfig_title);
    else
        SetGraphDisplay(' ', ' ', ' ');
    end
    
    for d = 1:length(dirs)
        
        % A typical attenuated input
        subplot(arch_height + length(dirs) + 1, size(x_typical, 2), ...
            (arch_height + d)*size(x_typical, 2) + i);
        semilogx(f_inp, x_typical_a(:, i, d), lws, lw, lcs, lc1);
        yyaxis right;
        semilogx(f_sig, sig(:, d), lws, lw, lcs, lc2);
        set(gca, 'YColor', lc2);
        if i == size(x_typical, 2)
            ylabel(y2_title);
        end
        set(gca,'YLim',y2_lim,'YTick',y2_tick);
        yyaxis left;
        set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
        if i == 1
            y_title_tmp = y_title;
            sfig_title  = char(double('A') + d + with_architecture);
        else
            y_title_tmp = ' ';
            sfig_title  = ' ';
        end
        if d == length(dirs)
            x_title_tmp = x_title;
        else
            x_title_tmp = ' ';
        end
        SetGraphDisplay(x_title_tmp, y_title_tmp, sfig_title);
        
    end
    
end

if with_architecture
    % Network Architecture
    subplot(arch_height + length(dirs) + 1, size(x_typical, 2), ...
        1:(arch_height*size(x_typical, 2)));
    h = imshow(im_new);
    set(h, 'AlphaData', im_alpha, 'AlphaDataMapping', 'scaled');
    axis off;
    SetGraphDisplay(' ', ' ', 'A', hp);
end


%--------------------------------------
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-eps')
% export_fig('../Fig_alpha_sigma_NIH',gcf,'-tif')
% export_fig('../Fig_alpha_sigma',gcf,'-tif','-r300','-nocrop')
% print(gcf,'-depsc','-r300','../Fig_alpha_sigma');
% print(gcf,'-depsc2','-r600',[fig_path fig_name]);
% print(gcf,'-dtiff','-r600',[fig_path fig_name]);
export_fig([fig_path fig_name], gcf, '-eps');
export_fig([fig_path fig_name], gcf, '-tif', '-r600');
% export_fig([fig_path fig_name], gcf, '-pdf');
