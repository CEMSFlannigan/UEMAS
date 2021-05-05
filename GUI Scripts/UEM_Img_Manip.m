function UEM_Img_Manip()

%% Establishing aspect ratio
Monitors = groot; % I AM GROOT
PrimaryMonitor = Monitors.MonitorPositions(1,:);
Primary_x_res = PrimaryMonitor(3);
Primary_y_res = PrimaryMonitor(4);
AspectRatio = Primary_x_res/Primary_y_res;

%% Initialized Values
GUI_Size = 0.85;
Img_x_pos = 0.05/AspectRatio;
Img_y_pos = 0.23;
Img_x_res = 0.75/AspectRatio;
Img_y_res = 0.75;

Button_x_res = 0.05;
Button_y_res = 0.05;
Prctle_x_res = 0.05;
Prctle_y_res = 0.025;

%% Establish the GUI
GUI_Handle = figure('Visible','off','Units','Normalized','Position',[0.5-GUI_Size/2,0.5-GUI_Size/2,GUI_Size,GUI_Size]);
GUI_Pos = get(GUI_Handle,'Position');

%% Establish the data fields
guidata(GUI_Handle, struct('curScan',1,'scanNum',1,'curTime',0,...
    'TimeIncr',1,'ULGData',[],'ulgpath',[],'dm3path','',...
    'cur_img_data',[],'lowprc_cutoff',1,'highprc_cutoff',99,...
    'prcToggle',0,'degRot',0,'rotToggle',0, 'dm3files',[],...
    'scanPop',[], 'frames',1,'Img_Box',[],'frameSetReq',[],...
    'frameSetSlide',[],'jframeSetSlide',[],'hframeSetSlide',[],...
    'curFrame',1, 'drift_correct',[1,0,0], 'driftToggle',0,'ordered',0,...
    'rectROI',[], 'rectROIx',-1,'rectROIy',-1,...
    'rectROIxRes',-1,'rectROIyRes',-1,'lineROI',[],'lineROIx1',-1,...
    'lineROIx2',-1,'lineROIy1',-1,'lineROIy2',-1,'lineWidth',-1,'scale',...
    1,'width',1,'backToggle',0,'backData',[],'vToggle',0,'hToggle',...
    0,'degVar',-1,'normToggle',0,'misalLineToggle',0,'misalLineROI',...
    [],'misalLineROIx1',-1,'misalLineROIx2',-1,'misalLineROIy1',-1,...
    'misalLineROIy2',-1,'FolderPath',[], 'FolderStitchPaths',[],...
    'num_stitched',1,'full_path_data',[], 'InSituToggle',0, 'ROIToggle',...
    0, 'drift_correct_path','','back_data_path','','inSituButton',[],...
    'driftCorrectButton',[],'backgroundButton',[],'normButton',[],...
    'percentileButton',[],'rotateButton',[],'vLineSubButton',[],...
    'hLineSubButton',[],'misalLineButton',[],'setScaleText',[],...
    'back_first_frame',-1,'back_last_frame',1));
data = guidata(GUI_Handle);

%% Establish the Image Box
Img_Box = axes('Parent', GUI_Handle,'Units','Normalized','Position',[Img_x_pos,Img_y_pos,Img_x_res,Img_y_res]);
set(gca,'xcolor',get(gcf,'color'));
set(gca,'ycolor',get(gcf,'color'));
set(Img_Box,'xtick',[]);
set(Img_Box,'ytick',[]);

%% Establish whether old script or in-situ script
inSituToggle = uicontrol('Style', 'togglebutton', 'String', 'InSitu Mode','Units','Normalized','Position', [Img_x_pos,Img_y_pos - Button_y_res*1.5,Button_x_res,Button_y_res],'Callback', @inSituActivate_callback);

%% Establish the query for dm3 Data
dm3Request = uicontrol('Parent', GUI_Handle, 'Style', 'pushbutton', 'String', 'Load .dm3','Units','Normalized','Position', [Img_x_pos+Button_x_res*2,Img_y_pos - Button_y_res*1.5,Button_x_res,Button_y_res],'Callback', @loaddm3_callback);
ulgRequest = uicontrol('Style', 'pushbutton', 'String', 'Load ULG','Units','Normalized','Position', [Img_x_pos+Button_x_res*3,Img_y_pos - Button_y_res*1.5,Button_x_res,Button_y_res],'Callback', @loadulg_callback);
stitchRequest = uicontrol('Style', 'pushbutton', 'String', 'Stitch ULGs','Units','Normalized','Position', [Img_x_pos+Button_x_res*4,Img_y_pos - Button_y_res*1.5,Button_x_res,Button_y_res],'Callback', @stitchulg_callback);

%% Establish image index counters
frameSetReq = uicontrol('Style', 'edit', 'String', '1','Units','Normalized','Position', [Img_x_pos+Button_x_res,Img_y_pos - Button_y_res*2.8,Prctle_x_res,Prctle_y_res],'Callback', @frameSetReq_callback);
frameSetReqText = uicontrol('Style', 'text', 'String', 'Image Index','Units','Normalized','Position', [Img_x_pos+Button_x_res,Img_y_pos - Button_y_res*2.25,Button_x_res,Prctle_y_res],'Callback', '');

frameSetSlide = javax.swing.JSlider;
[jframeSetSlide, hframeSetSlide] = javacomponent(frameSetSlide);
set(hframeSetSlide,'unit','norm','position',[Img_x_pos+Button_x_res*2.25,Img_y_pos - Button_y_res*2.8,Img_x_res - Img_x_pos - Button_x_res*3 + 0.05,Button_y_res]);
set(jframeSetSlide, 'Value',1,'minimum',1,'maximum',1, 'MajorTickSpacing',1,'StateChangedCallback', @(hObject, SetReq) frameSetSlider_callback(frameSetSlide, frameSetReq));

%% Scan Number
scanPop = uicontrol('Style', 'popup', 'String', {''},'Units','Normalized','Position', [Img_x_pos,Img_y_pos - Button_y_res*2.2,Prctle_x_res,Prctle_y_res],'Callback', @scanPop_callback);

%% Order Image
orderApply = uicontrol('Style', 'popup', 'String', {'Sequence','Time'},'Units','Normalized','Position', [Img_x_pos,Img_y_pos - Button_y_res*2.8,Prctle_x_res,Prctle_y_res],'Callback', @orderApply_callback);

%% Scalebar Settings
setScale = uicontrol('Style', 'edit', 'String', '1','Units','Normalized','Position', [Img_x_pos,Img_y_pos - Button_y_res*3.9,Prctle_x_res,Prctle_y_res],'Callback', @updateScale);
setScaleText = uicontrol('Style', 'text', 'String', 'px/nm Scale','Units','Normalized','Position', [Img_x_pos,Img_y_pos - Button_y_res*3.4,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Save Time Ordered Images
saveTime = uicontrol('Style','pushbutton','String','Save Time','Units','Normalized','Position',[Img_x_pos+Button_x_res*5,Img_y_pos - Button_y_res*1.5,Button_x_res,Button_y_res],'Callback', @saveTime_callback);

%% Establish query for drift correction
driftCorrectRequest = uicontrol('Style', 'pushbutton', 'String', 'Load Drift Correction','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Button_x_res*2,Button_y_res],'Callback', @driftCorrectReq_callback);

%% Toggle Button to Load Drift Correction Values
driftCorrectToggle = uicontrol('Style', 'togglebutton', 'String', 'Toggle Drift Correction','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*2+0.03,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Button_x_res*2,Button_y_res],'Callback', @driftCorrectToggle_callback);

%% Background Correction
backgroundRequest = uicontrol('Style', 'pushbutton', 'String', 'Load Background','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*4+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Button_x_res*1.5,Button_y_res],'Callback', @backgroundReq_callback);
backgroundToggle = uicontrol('Style', 'togglebutton', 'String', 'Toggle Background','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*5.5+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Button_x_res*1.5,Button_y_res],'Callback', @backgroundToggle_callback);
backFirstFrameReq = uicontrol('Style', 'edit', 'String', '-1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*7+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Prctle_x_res,Prctle_y_res],'Callback', @backFirstFrameReq_callback);
backLastFrameReq = uicontrol('Style', 'edit', 'String', '1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*7+Prctle_x_res+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05,Prctle_x_res,Prctle_y_res],'Callback', @backLastFrameReq_callback);
backFrameText = uicontrol('Style', 'text', 'String', 'Background Range','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*7+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05 + 0.025,Prctle_x_res*2,Prctle_y_res],'Callback', '');

%% Normalize
normToggle = uicontrol('Style', 'togglebutton', 'String', 'Normalize','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res*3 + Button_x_res*4+0.12,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Button_x_res,Button_y_res],'Callback', @normToggle_callback);

%% Set up imagesc percentile queries
imgLowPrcReq = uicontrol('Style', 'edit', 'String', '1','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Prctle_x_res,Prctle_y_res],'Callback', @imgLowPrcReq_callback);
imgHighPrcReq = uicontrol('Style', 'edit', 'String', '99','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res+0.03,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Prctle_x_res,Prctle_y_res],'Callback', @imgHighPrcReq_callback);
imgPrcReqText = uicontrol('Style', 'text', 'String', 'Imagesc Percentile Cutoffs','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - Prctle_y_res - Button_y_res - 0.02,Prctle_x_res*2,Prctle_y_res],'Callback', '');

%% Toggle Button to Apply Percentile Cutoffs
percentileToggle = uicontrol('Style', 'togglebutton', 'String', 'Toggle Percentiles','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res*2+0.05,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Button_x_res*2,Button_y_res],'Callback', @percentileToggle_callback);

%% Set up rotation query
imgRotReq = uicontrol('Style', 'edit', 'String', '0','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res*2 + Button_x_res*2+0.1,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Prctle_x_res,Prctle_y_res],'Callback', @imgRotReq_callback);
imgRotReqText = uicontrol('Style', 'text', 'String', 'Image Rotation','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res*2 + Button_x_res*2+0.1,Img_y_pos + Img_y_res - Prctle_y_res - Button_y_res - 0.02,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Toggle Button to Apply Image Rotation
rotateToggle = uicontrol('Style', 'togglebutton', 'String', 'Toggle Rotation','Units','Normalized','Position', [Img_x_pos+Img_x_res+Prctle_x_res*3 + Button_x_res*2+0.12,Img_y_pos + Img_y_res - Prctle_y_res*2.05 - Button_y_res - 0.02,Button_x_res*1,Button_y_res],'Callback', @rotateToggle_callback);

%% Region of Interest Selectors
acquireROI = uicontrol('Style','pushbutton','String','Rectangle ROI','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res*2.05 - 0.10,Button_x_res,Button_y_res],'Callback', @acquireROI_callback);

%% ROI Edit Boxes
rectROIx = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateRectROI);
rectROIy = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateRectROI);
rectROIxRes = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*2+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateRectROI);
rectROIyRes = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*3+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateRectROI);
rectROIxText = uicontrol('Style', 'text', 'String', 'x Pos','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
rectROIyText = uicontrol('Style', 'text', 'String', 'y Pos','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
rectROIxResText = uicontrol('Style', 'text', 'String', 'x Res','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*2+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
rectROIyResText = uicontrol('Style', 'text', 'String', 'y Res','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*3+0.05,Img_y_pos + Img_y_res - Button_y_res - Prctle_y_res - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Linescan ROI
acquireLineROI = uicontrol('Style','pushbutton','String','Line ROI','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Button_x_res,Button_y_res],'Callback', @linescan_callback);

%% Line Background Subtract
%lineBackground = uicontrol('Style','pushbutton','String','Subtract Lines','Units','Normalized','Position', ,'Callback', @subtract_lines);

%% Linescan Edit Boxes
lineROIx1 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateLineROI);
lineROIy1 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateLineROI);
lineROIx2 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*2+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateLineROI);
lineROIy2 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*3+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateLineROI);
lineROIx1Text = uicontrol('Style', 'text', 'String', 'x 1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*1.5 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
lineROIy1Text = uicontrol('Style', 'text', 'String', 'y 1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*1.5 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
lineROIx2Text = uicontrol('Style', 'text', 'String', 'x 2','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*2+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*1.5 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
lineROIy2Text = uicontrol('Style', 'text', 'String', 'y 2','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*3+0.05,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*1.5 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Width of Line ROI
lineWidth = uicontrol('Style', 'edit', 'String', '1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*4+0.07,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*2.55 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateLineROI);
lineWidthText = uicontrol('Style', 'text', 'String', 'Width','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+Prctle_x_res*4+0.07,Img_y_pos + Img_y_res - 2*Button_y_res - Prctle_y_res*1.5 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Plasma Lens Fitting
plasmaLensIntensity = uicontrol('Style','pushbutton','String','Intensity Lens','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @intensitylens_callback);
plasmaLensWidth = uicontrol('Style','pushbutton','String','Width Lens','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - 4*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @linelens_callback);

%% Line Summing
lineSum = uicontrol('Style','pushbutton','String','Line Sum','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - 6*Button_y_res - Prctle_y_res*3.10 - 0.12,Button_x_res,Button_y_res],'Callback', @lineSum_Dynamic);
lineSumMulti = uicontrol('Style','pushbutton','String','Line Sum Multi Width','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03+Button_x_res,Img_y_pos + Img_y_res - 6*Button_y_res - Prctle_y_res*3.10 - 0.12,Button_x_res*2,Button_y_res],'Callback', @mult_width_lineSum);

%% Square Summing
squareSumMulti = uicontrol('Style','pushbutton','String','Square Sum Multi Width','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03+Button_x_res,Img_y_pos + Img_y_res - 7*Button_y_res - Prctle_y_res*3.10 - 0.12,Button_x_res*2,Button_y_res],'Callback', @mult_squareSum_Dynamic);

%% FFT_Maps
fftMaps = uicontrol('Style','pushbutton','String','FFT Maps','Units','Normalized','Position', [Img_x_pos+Img_x_res+0.03,Img_y_pos + Img_y_res - 9*Button_y_res - Prctle_y_res*3.10 - 0.12,Button_x_res,Button_y_res],'Callback', @FFTMap);

%% Space Time Plotting
spaceTime = uicontrol('Style','pushbutton','String','SpaceTime Plot','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @spacetime_1D_callback);
vLineSubToggle = uicontrol('Style','togglebutton','String','Vert Subtract','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*2+0.05,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @vLineSubtract_callback);
hLineSubToggle = uicontrol('Style','togglebutton','String','Horiz Subtract','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*3+0.05,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @hLineSubtract_callback);
varDir = uicontrol('Style','pushbutton','String','Var Dir','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - 4*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @var_dir_callback);
degVarReq = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*2+0.05,Img_y_pos + Img_y_res - 4*Button_y_res - Prctle_y_res*3.10 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @degVarReq_callback);
degVarReqText = uicontrol('Style', 'text', 'String', 'Semiangle Var','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*2+0.05,Img_y_pos + Img_y_res - 4*Button_y_res - Prctle_y_res*2.1 - 0.10,Prctle_x_res,Prctle_y_res*0.75],'Callback', '');
% Misalignment for Width Calculation
misalLineToggle = uicontrol('Style','togglebutton','String','Misalign Toggle','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @misalLineToggle_callback);
misalLineAcq = uicontrol('Style','pushbutton','String','Misalign Dir','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*2+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @misalLine_callback);
misalLineROIx1 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*3+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateMisalLine);
misalLineROIy1 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*4+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateMisalLine);
misalLineROIx2 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*5+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateMisalLine);
misalLineROIy2 = uicontrol('Style', 'edit', 'String', '','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*6+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*3.10 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', @updateMisalLine);
misalLineROIx1Text = uicontrol('Style', 'text', 'String', 'x 1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*3+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
misalLineROIy1Text = uicontrol('Style', 'text', 'String', 'y 1','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*4+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
misalLineROIx2Text = uicontrol('Style', 'text', 'String', 'x 2','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*5+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');
misalLineROIy2Text = uicontrol('Style', 'text', 'String', 'y 2','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*6+0.05,Img_y_pos + Img_y_res - 5*Button_y_res - Prctle_y_res*2.05 - 0.10,Prctle_x_res,Prctle_y_res],'Callback', '');

%% Cumulative Colorbar
cumul_colorbar = uicontrol('Style','pushbutton','String','Cumulative Colorbar','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*4+0.1,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @cumulative_colorbar);
ROI_Toggle = uicontrol('Style','togglebutton','String','Toggle ROI Only','Units','Normalized','Position', [Img_x_pos+Img_x_res+Button_x_res*5+0.1,Img_y_pos + Img_y_res - 3*Button_y_res - Prctle_y_res*3.10 - 0.10,Button_x_res,Button_y_res],'Callback', @ROIToggle_callback);

%% Save/Load UI Data
savestate = uicontrol('Style','pushbutton','String','Save State','Units','Normalized','Position', [0.99 - Button_x_res*2,0.01,Button_x_res,Button_y_res],'Callback', @save_state);
loadstate = uicontrol('Style','pushbutton','String','Load State','Units','Normalized','Position', [0.99 - Button_x_res,0.01,Button_x_res,Button_y_res],'Callback', @load_state);

%% Initialize GUI data for handles
GUI_Data = guidata(GUI_Handle);
GUI_Data.Img_Box = Img_Box;
GUI_Data.frameSetReq = frameSetReq;
GUI_Data.frameSetSlide = frameSetSlide;
GUI_Data.jframeSetSlide = jframeSetSlide;
GUI_Data.hframeSetSlide = hframeSetSlide;
GUI_Data.inSituButton = inSituToggle;
GUI_Data.driftCorrectButton = driftCorrectToggle;
GUI_Data.backgroundButton = backgroundToggle;
GUI_Data.normButton = normToggle;
GUI_Data.percentileButton = percentileToggle;
GUI_Data.rotateButton = rotateToggle;
GUI_Data.vLineSubButton = vLineSubToggle;
GUI_Data.hLineSubButton = hLineSubToggle;
GUI_Data.misalLineButton = misalLineToggle;
GUI_Data.setScaleText = setScale;
GUI_Data.lprcText = imgLowPrcReq;
GUI_Data.hprcText = imgHighPrcReq;
GUI_Data.rotText = imgRotReq;
GUI_Data.rectxPosText = rectROIx;
GUI_Data.rectyPosText = rectROIy;
GUI_Data.rectxResText = rectROIxRes;
GUI_Data.rectyResText = rectROIyRes;
GUI_Data.linex1Text = lineROIx1;
GUI_Data.linex2Text = lineROIx2;
GUI_Data.liney1Text = lineROIy1;
GUI_Data.liney2Text = lineROIy2;
GUI_Data.widthText = lineWidth;
GUI_Data.semiText = degVarReq;
GUI_Data.misallinex1Text = misalLineROIx1;
GUI_Data.misallinex2Text = misalLineROIx2;
GUI_Data.misalliney1Text = misalLineROIy1;
GUI_Data.misalliney2Text = misalLineROIy2;

guidata(GUI_Handle, GUI_Data);

%% Show the GUI
GUI_Handle.Visible = 'on';

end