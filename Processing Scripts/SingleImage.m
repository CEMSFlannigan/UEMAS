function varargout = SingleImage(varargin)
% SINGLEIMAGE MATLAB code for SingleImage.fig
%      SINGLEIMAGE, by itself, creates a new SINGLEIMAGE or raises the existing
%      singleton*.
%
%      H = SINGLEIMAGE returns the handle to a new SINGLEIMAGE or the handle to
%      the existing singleton*.
%
%      SINGLEIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLEIMAGE.M with the given input arguments.
%
%      SINGLEIMAGE('Property','Value',...) creates a new SINGLEIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SingleImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SingleImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SingleImage

% Last Modified by GUIDE v2.5 22-Aug-2017 11:38:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SingleImage_OpeningFcn, ...
                   'gui_OutputFcn',  @SingleImage_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SingleImage is made visible.
function SingleImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SingleImage (see VARARGIN)

% Choose default command line output for SingleImage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SingleImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SingleImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[File, Path] = uigetfile('*.dm3', 'Select .dm3 image', 'C:\Users\reisb005\Documents');
if isequal(File, 0)
    return
end
    
[Data, Mult, Unit] = ReadDMFile(strcat(Path, File));
Display_Image(medfilt2(Data));

set(handles.Curr, 'String', ['Current Image: ', File]);             set(handles.ImInt, 'Enable', 'on');
set(handles.Low, 'Enable', 'on');                                   set(handles.High, 'Enable', 'on');
set(handles.LowText, 'String', 'Low Percentile: 1');                set(handles.HighText, 'String', 'High Percentile: 99');
set(handles.NumSpts, 'Enable', 'on', 'String', 'Number of Spots');  set(handles.Dist, 'Enable', 'off');
set(handles.Ang, 'Enable', 'off');                                  set(handles.LW, 'Enable', 'on', 'String', 'Line Width');
set(handles.IntLine, 'Enable', 'off');                              set(handles.DLW, 'Enable', 'on');
set(handles.DInt, 'Enable', 'off');                                 set(handles.DLW, 'Enable', 'on', 'String', 'Line Width');
set(handles.IntBut, 'Enable', 'off');                               set(handles.SurfFit, 'Enable', 'on');
set(handles.Raw, 'Enable', 'off');

handles.Data = Data;
handles.Mult = Mult;
handles.Unit = Unit;
guidata(hObject, handles);


% --- Executes on slider movement.
function Low_Callback(hObject, eventdata, handles)
% hObject    handle to Low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if get(hObject, 'Value') >= get(handles.High, 'Value')
    errordlg('The low percentile must be smaller than the high percentile');
    return
end

Display_Image(medfilt2(handles.Data), get(hObject, 'Value'), get(handles.High, 'Value'));

set(handles.LowText, 'String', ['Low Percentile: ', num2str(round(get(hObject, 'Value')))]);


% --- Executes during object creation, after setting all properties.
function Low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function High_Callback(hObject, eventdata, handles)
% hObject    handle to High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if get(hObject, 'Value') <= get(handles.Low, 'Value')
    errordlg('The low percentile must be smaller than the high percentile');
    return
end

Display_Image(medfilt2(handles.Data), get(handles.Low, 'Value'), get(hObject, 'Value'));

set(handles.HighText, 'String', ['High Percentile: ', num2str(round(get(hObject, 'Value')))]);


% --- Executes during object creation, after setting all properties.
function High_CreateFcn(hObject, eventdata, handles)
% hObject    handle to High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Fits.
function Fits_Callback(hObject, eventdata, handles)
% hObject    handle to Fits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Display_Image(medfilt2(handles.Data), get(handles.Low, 'Value'), get(handles.High, 'Value'));
Num = str2double(get(handles.NumSpts, 'String'));

rectArr = zeros(Num, 4);            fits = zeros(Num, 6);           R_Sq = zeros(Num, 1);   

h = helpdlg('Place rectangle around spots of interest');
waitfor(h);
for i = 1:Num
    rectArr(i, :) = round(getrect());
    rectangle('Position', rectArr(i, :), 'EdgeColor', 'r');
    text(rectArr(i, 1), rectArr(i, 2)-45, num2str(i), 'FontSize', 24);
    [fit, xys] = Fit_2DGauss(double(medfilt2(handles.Data)), rectArr(i, :));
    curPosition = rectArr(i,:);
    largestLength = max(curPosition(:,3:4));
    newPosition = round([fit(1)-largestLength./2, fit(2) - largestLength./2, largestLength, largestLength]);
    rectArr(i,:) = newPosition;
    
    [fit, xys] = Fit_2DGauss(double(medfilt2(handles.Data)), rectArr(i, :));
    
    fits(i, :) = fit(:);
    
    %CData = Cut_Data(handles.Data, rectArr(i, :));
    
    %R_Sq(i) = Calc_R_Squared(CData, Gauss_2D(fit, xys));
end

set(handles.IntBut, 'Enable', 'on');            set(handles.Raw, 'Enable', 'on');
if Num > 1
    set(handles.Dist, 'Enable', 'on');
end
if Num > 2
    set(handles.Ang, 'Enable', 'on');
end

handles.fits = fits;
handles.rectArr = rectArr;
guidata(hObject, handles);

assignin('base', 'Fits', fits);
assignin('base', 'R_Sq', R_Sq);
assignin('base', 'rects', rectArr);

    
    



function NumSpts_Callback(hObject, eventdata, handles)
% hObject    handle to NumSpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumSpts as text
%        str2double(get(hObject,'String')) returns contents of NumSpts as a double

value = str2double(get(hObject, 'String'));
if or(isempty(value), rem(value, 1) ~= 0)
    errordlg('Please Enter and Integer Value');
    set(hObject, 'String', 'Number of Spots ');
    set(handles.Fits, 'Enable', 'off');
    return
else
    set(handles.Fits, 'Enable', 'on');
end

% --- Executes during object creation, after setting all properties.
function NumSpts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumSpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Dist.
function Dist_Callback(hObject, eventdata, handles)
% hObject    handle to Dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fits = handles.fits;
Mult = handles.Mult;

[rows, ~] = size(fits);

dist = zeros(rows);

for i = 1:rows
    x = fits(i, 1);
    y = fits(i, 2);
    for j = 1:rows
        x1 = fits(j, 1);
        y1 = fits(j, 2);
        dist(i, j) = sqrt(power(x1-x, 2)+power(y1-y, 2));
    end
end
SCdist = dist.*Mult(1);

assignin('base', 'dist', dist);
assignin('base', 'SCdist', SCdist);

        
    
    

% --- Executes on button press in Ang.
function Ang_Callback(hObject, eventdata, handles)
% hObject    handle to Ang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in IntLine.
function IntLine_Callback(hObject, eventdata, handles)
% hObject    handle to IntLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Data = medfilt2(handles.Data);

Display_Image(Data, get(handles.Low, 'Value'), get(handles.High, 'Value'));

[x, y] = ginput(2);
x = round(x);
y = round(y);
line(x, y , 'Color', 'r');

Int = GetLineInt(Data, x, y, handles.width);
assignin('base', 'Int', Int);

figure;
plot(Int);



function LW_Callback(hObject, eventdata, handles)
% hObject    handle to LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LW as text
%        str2double(get(hObject,'String')) returns contents of LW as a double

try 
    value = str2double(get(hObject, 'String'));
    if and(isequal(rem(value, 1), 0), isequal(rem(value, 2), 1)) ;
        set(handles.IntLine, 'Enable', 'on');
        handles.width = value;
        guidata(hObject, handles);
    else
        set(handles.IntLine, 'Enable', 'off');
    end
catch
    errordlg('Please enter an integer');
    return
end

% --- Executes during object creation, after setting all properties.
function LW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DInt.
function DInt_Callback(hObject, eventdata, handles)
% hObject    handle to DInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Data = handles.Data;

Display_Image(medfilt2(Data), get(handles.Low, 'Value'), get(handles.High, 'Value'));

[x, y] = ginput(2);
x = round(x);
y = round(y);
line(x, y , 'Color', 'r');

Int = GetLineInt(Data, x, y, handles.Dwidth);
assignin('base', 'Int', Int);

figure;
plot(Int);


function DLW_Callback(hObject, eventdata, handles)
% hObject    handle to DLW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DLW as text
%        str2double(get(hObject,'String')) returns contents of DLW as a double

try 
    value = str2double(get(hObject, 'String'));
    if and(isequal(rem(value, 1), 0), isequal(rem(value, 2), 1)) ;
        set(handles.DInt, 'Enable', 'on');
        handles.Dwidth = value;
        guidata(hObject, handles);
    else
        set(handles.DInt, 'Enable', 'off');
    end
catch
    errordlg('Please enter an integer');
    return
end


% --- Executes during object creation, after setting all properties.
function DLW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DLW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in IntBut.
function IntBut_Callback(hObject, eventdata, handles)
% hObject    handle to IntBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fits = handles.fits;
[rows, ~] = size(fits);

Int = zeros(rows, 1);

for i = 1:rows
    xpart = linspace(round(fits(i, 1)-(fits(i, 3))), round(fits(i, 1)+(fits(i, 3))), 1000);
    ypart = linspace(round(fits(i, 2)-(fits(i, 4))), round(fits(i, 2)+(fits(i, 4))), 1000);
    [xMesh, yMesh] = meshgrid(xpart, ypart);
    %disp(fits(i, :));
    f = Gauss_2D(fits(i, :), cat(3, xMesh, yMesh));
    
    Int(i) = sum(sum(f));
end

assignin('base', 'Int', Int);


% --- Executes on button press in ImInt.
function ImInt_Callback(hObject, eventdata, handles)
% hObject    handle to ImInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Data = handles.Data;
Int = sum(sum(Data));
assignin('base', 'I', Int);
disp(Int);


% --- Executes on button press in SurfFit.
function SurfFit_Callback(hObject, eventdata, handles)
% hObject    handle to SurfFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap('Parula')
Display_Image(medfilt2(handles.Data), get(handles.Low, 'Value'), get(handles.High, 'Value'));
rect = round(getrect());

rectangle('Position', rect, 'EdgeColor', 'r');

[fit, xys] = Fit_2DGauss(double(medfilt2(handles.Data)), rect);
fit
CData = Cut_Data(medfilt2(handles.Data), rect);
R_Sq = Calc_R_Squared(CData, Gauss_2D(fit, xys))

f = figure;
get(f, 'Color')
surf(CData, 'EdgeColor', 'none', 'FaceColor', 'r');
hold on
surf(Gauss_2D(fit, xys), 'EdgeColor', 'none', 'FaceColor', 'g');


% --- Executes on button press in Raw.
function Raw_Callback(hObject, eventdata, handles)
% hObject    handle to Raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fits = handles.fits;

