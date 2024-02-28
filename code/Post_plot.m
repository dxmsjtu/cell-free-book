function Post_plot
h  =gcf;     
% Post_plot 获得当前figure句柄，大家需要用这个模板来画图，仔细调整画图规范;下面的参数可以根据具体显示器尺寸就行调整 MagRatio；
dd = get(0,'ScreenSize');
if dd(3)>1500;    
    MarkerSize=15;  LineWidth =2; LineMethod =1; PlotMethod =1; FontSize=25; FontSize= 25 ; LineWidth = 3;
    TitleFontSize =25; LegendFontSize =25; axis_ratio=1.5; YLabelFontSize =25;
    MagRatio = 1.5;
else
    MarkerSize=9;  LineWidth =2; LineMethod =1; PlotMethod =1; FontSize=22; FontSize= 24 ; LineWidth = 3;
    TitleFontSize =20; LegendFontSize =24; axis_ratio=1.5; YLabelFontSize =24;
     MagRatio = 1;
end
myboldify(h,MagRatio,MarkerSize,YLabelFontSize,FontSize,LineWidth,LegendFontSize,TitleFontSize)
function myboldify(h,MagRatio,MarkerSize,YLabelFontSize,FontSize,LineWidth,LegendFontSize,TitleFontSize)
%% Default value for figures.
% MarkerSize=9;  LineWidth =2; LineMethod =1; PlotMethod =1; FontSize=22; FontSize= 24 ; LineWidth = 3;
% TitleFontSize =20; LegendFontSize =24; axis_ratio=1.5; YLabelFontSize =24;
% myboldify: make lines and text bold;  boldifies the current figure; applies to the figure with the handle h
if nargin < 1
    dd = get(0,'ScreenSize');
    if dd(3)>1500;
        h = gcf;
        MarkerSize=12; YLabelFontSize =30; FontSize= 30 ;
        LineWidth = 2;TitleFontSize =30; LegendFontSize =36; axis_ratio=2;        MagRatio =4;
    else
        h = gcf;
        MarkerSize=12; YLabelFontSize =26; FontSize= 26;
        LineWidth = 3;TitleFontSize =26; LegendFontSize =36; axis_ratio=1.5;       MagRatio=1;
    end
    %myboldify(h,FontSize,LineWidth,LegendFontSize,TitleFontSize);
end
ha = get(h, 'Children'); % the handle of each axis
for i = 1:length(ha)
    if strcmp(get(ha(i),'Type'), 'axes') % axis format
        set(ha(i), 'FontSize', round(MagRatio*LegendFontSize));      % tick mark and frame format
        set(ha(i), 'LineWidth', LineWidth);
        set(get(ha(i),'XLabel'), 'FontSize', round(MagRatio*YLabelFontSize));
        %set(get(ha(i),'XLabel'), 'VerticalAlignment', 'top');
        set(get(ha(i),'YLabel'), 'FontSize', round(MagRatio*YLabelFontSize));
        %set(get(ha(i),'YLabel'), 'VerticalAlignment', 'baseline');
        set(get(ha(i),'ZLabel'), 'FontSize', round(MagRatio*FontSize));
        %set(get(ha(i),'ZLabel'), 'VerticalAlignment', 'baseline');
        set(get(ha(i),'Title'), 'FontSize', round(MagRatio*TitleFontSize));
        %set(get(ha(i),'Title'), 'FontWeight', 'Bold');
    end
    hc = get(ha(i), 'Children'); % the objects within an axis
    for j = 1:length(hc)
        chtype = get(hc(j), 'Type');
        if strcmp(chtype(1:length(chtype)), 'text')
            set(hc(j), 'FontSize', round(MagRatio*LegendFontSize)); % 14 pt descriptive labels
        elseif strcmp(chtype(1:length(chtype)), 'line')
            set(hc(j), 'LineWidth', LineWidth);
            set(hc(j), 'MarkerSize', round(MagRatio*MarkerSize));
        elseif strcmp(chtype, 'hggroup')
            hcc = get(hc(j), 'Children');
            if strcmp(get(hcc, 'Type'), 'hggroup')
                hcc = get(hcc, 'Children');
            end
            for k = 1:length(hcc) % all elements are 'line'
                set(hcc(k), 'LineWidth', LineWidth);
                set(hcc(k), 'MarkerSize', LegendFontSize);
            end
        end
    end
end
set(gcf,'outerposition',get(0,'screensize')); shg;
end
end