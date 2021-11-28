% Create the stimuli's graphs

wipe_all;
addpath('..\');
addpath('.\export_fig\');
SetConstants;

% Figure's path and filename
fig_path    = '..\Figures\';
fig_name    = 'Fig_stimuli';
image_name  = 'OCRecArchGray.tif';

% Figure's Size & Display
figure;
set(gcf,'PaperUnits','inches');
set(gcf,'Units','inches');
xSize = 5.25;
ySize = xSize;
xLeft = (8.5 - xSize)/2;
yTop  = (11 - ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
set(gcf,'Position',[1 1 xSize ySize]);
set(gcf,lcs,'w');

% Set Size
SetSize;

% Attenuation
SimParams.Attenuate.beta    = 10;                   % Attenuation smoothness factor
SimParams.Attenuate.f_0     = floor(inputs / 2);    % Attenuation mean index
SimParams.Attenuate.minval  = 0;                    % Attenuation minimal value

% Axes Normalization
% f_num = 30;
% f_min = 20;
% f_max = f_min + (f_num - 1);
% f_inp = linspace(f_min, f_max, inputs);
f_min = 20;
f_max = 20000;
f_inp = logspace(log10(f_min), log10(f_max), inputs);

% Axes Display
x_title     = 'Frequency (Hz)';
x_lim       = [f_min, f_max];
% x_tick      = [f_min, (f_min + f_max)/2, f_max];
x_tick      = [f_min, f_min*10, f_max/10, f_max];
y_title     = 'Activity';
y_lim       = [0, 0.2];
y_tick      = [ ];

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

% Get Samples
if(~exist('Samples', 'var') == 1)
    GetSamples;
end

% Generate inputs
% ind = randi(size(Samples.x, 2));
x_typical = Samples.x(:, 171187);

% Generate Attenuated Inputs
x_typical_a = Attenuate(x_typical, SimParams.Attenuate);

% % Network Architecture
% subplot(3,2,1:4)
% h = imshow(im_new);
% set(h, 'AlphaData', im_alpha, 'AlphaDataMapping', 'scaled');
% axis off;
% SetGraphDisplay(' ', ' ', 'A');

% A typical input
subplot(3,2,5)
semilogx(f_inp, x_typical, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
hp = SetGraphDisplay(x_title, y_title, 'B');

% A typical attenuated input
subplot(3,2,6)
semilogx(f_inp, x_typical_a, lws, lw, lcs, lc1);
set(gca,'XLim',x_lim,'XTick',x_tick,'YLim',y_lim,'YTick',y_tick);
SetGraphDisplay(x_title, y_title, 'C');

% Network Architecture
subplot(3,2,1:4)
h = imshow(im_new);
set(h, 'AlphaData', im_alpha, 'AlphaDataMapping', 'scaled');
axis off;
SetGraphDisplay(' ', ' ', 'A', hp);


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
