function UEM_Img_Manip()

%% Acquire the size of the GUI that is one size lower than the Monitor resolution on the standard list of 16:9 resolutions
x_res_list = [640,720,854,960,1024,1280,1366,1600,1920,2048,2560,2880,3200,3840,4096,5120,7680,8192];
y_res_list = [360,405,480,540,576,720,768,900,1080,1152,1440,1620,1800,2160,2304,2880,4320,4608];

Monitors = groot; % I AM GROOT
PrimaryMonitor = Monitors.MonitorPositions(1,:);
Primary_x_res = PrimaryMonitor(3);
Primary_y_res = PrimaryMonitor(4);

x_res = x_res_list(1);
y_res = y_res_list(1);

for res_list_index = 1:length(x_res_list)
    if x_res_list(res_list_index) < Primary_x_res
        x_res = x_res_list(res_list_index);
        y_res = y_res_list(res_list_index);
    else
        res_list_index = length(x_res_list);
    end
end

%% Establish the centering of the GUI

x_pos = round(Primary_x_res/2 - x_res/2);
y_pos = round(Primary_y_res/2 - y_res/2);

%% Establish the GUI

%GUI_Handle = figure('Visible','off','Position',[x_pos,y_pos,x_res,y_res]);
GUI_Handle = figure('Visible','off','Units','Normalized','Position',[0.5-0.75/2,0.5-0.75/2,0.75,0.75]);

%% Establish the Image Box

Img_Box = axes('Units','Pixels','Position',[round(y_res*0.03),y_res-round(y_res*0.77),round(y_res*0.75),round(y_res*0.75)]);
set(gca,'xcolor',get(gcf,'color'));
set(gca,'ycolor',get(gcf,'color'));
set(Img_Box,'xtick',[]);
set(Img_Box,'ytick',[]);

GUI_Handle.Visible = 'on';

end