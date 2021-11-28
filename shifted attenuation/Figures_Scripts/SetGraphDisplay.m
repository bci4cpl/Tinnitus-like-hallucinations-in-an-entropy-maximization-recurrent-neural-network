function [hp] = SetGraphDisplay( x_label, y_label, caption, hp1)
    %SETGRAPHDISPLAY Set a Graph's Display
    %   Detailed explanation goes here
    
    SetConstants;
    
    set(gca, fss, fs, 'FontName', 'timesnewroman');
    set(gca, 'Color', 'none');
    set(gca, 'XColor', 'black');
    set(gca, 'YColor', 'black');
    box off
    xlabel(x_label);
    h_ylabel = ylabel(y_label);
%     h = title(caption, 'Interpreter', 'tex');
    h = title(caption);
    hp = get(h, 'Position');
    if ~exist('hp1', 'var') || isempty(hp1)
        hp_ylabel = get(h_ylabel, 'Position');
        hp(1) = hp_ylabel(1);
    else
        hp(1) = hp1(1);
    end
    set(h, 'Position', hp);
    set(h, 'FontWeight', 'bold', fss, fs_letter, ...
        'HorizontalAlignment', 'left');
    
end