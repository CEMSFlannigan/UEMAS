function cumulative_colorbar(hObject, eventdata, handles)

data = guidata(hObject);

if data.prcToggle == 1
    backData = RMOuts(data.backData,data.highprc_cutoff,data.lowprc_cutoff);
else
    data.backData = RMOuts(data.backData);
end

if data.normToggle == 1 && data.backToggle == 1
    backData = (backData - ones(size(backData)).*min(min(backData)))./(max(max(backData)) - min(min(backData)));
end
   
if ~isempty(data.degRot) && data.rotToggle == 1 && data.backToggle == 1
    backData = imrotate(backData,data.degRot);
end

width = data.width;

ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));

RectPos = getPosition(data.rectROI);

curmin = 1e99;
curmax = -1e99;
construct_img = zeros(1000,1000);

w = waitbar(0,'Constructing value array');
%h1 = figure;
%h2 = figure;
for i = 1:length(data.ULGData(:,3))
    
    curFile = [ULGTime{i,6} '.dm3'];
    dm3path = [data.dm3path '\' curFile];
    dm3Data = DM3Import(dm3path);
    assignin('base','analysis_dm3',dm3path);
    cur_img_data = dm3Data.image_data';
    
    if data.prcToggle == 1
        cur_img_data = RMOuts(cur_img_data,data.highprc_cutoff,data.lowprc_cutoff);
    else
        cur_img_data = RMOuts(cur_img_data);
    end
    
    if data.normToggle == 1
        cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
    end
    
    if ~isempty(data.degRot) && data.rotToggle == 1
        cur_img_data = imrotate(cur_img_data,data.degRot);
    end
    
    if data.driftToggle == 1
        cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
    end
    
    if data.backToggle == 1
        cur_img_data = cur_img_data - backData;
    end
    
    if data.ROIToggle == 1
        cur_img_data = cur_img_data(RectPos(2):RectPos(2) + RectPos(4),RectPos(1):RectPos(1) + RectPos(3));
    end
    
    min_img = min(min(cur_img_data));
    max_img = max(max(cur_img_data));

    if (min_img < curmin)
        curmin = min_img;
    end
    
    if (max_img > curmax)
        curmax = max_img;
    end
    
    waitbar(i/length(data.ULGData(:,3)));
end

close(w);

count = 0;
color_scale = (max_img - min_img)/(1000^2);
for i = 1:1000
    for j = 1:1000
        construct_img(i,j) = min_img + count*color_scale;
        count = count + 1;
    end
end

assignin('base','construct_img', construct_img);

h3 = figure;
imagesc(construct_img);
hold on;
colorMap = gray(512);
colormap(colorMap);

set(gcf,'Position', [0 0 1500 1000]);
set(gca,'FontSize', 50, 'LineWidth', 1);
pbaspect([1 1 1]);

yticks([]);
xticks([]);

ticks = linspace(curmin,curmax,5);
ticks = round(ticks*100)/100;
ticks(1) = ticks(1) + 0.031;
ticks(end) = ticks(end) - 0.05;
ticks
%
cbh = colorbar('Ticks', ticks, 'TickLabels', {'0.05', '0.24', '0.46', '0.67', '0.84'},'LineWidth',5,'TickDirection','out','Position',[0.8, .118, .03, .8]);
%AxesH = axes('CLim', [curmin curmax]);

end