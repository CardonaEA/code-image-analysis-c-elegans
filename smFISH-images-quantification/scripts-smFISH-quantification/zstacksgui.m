function varargout = zstacksgui(varargin)
% ZSTACKSGUI MATLAB code for zstacksgui.fig
%      ZSTACKSGUI, by itself, creates a new ZSTACKSGUI or raises the existing
%      singleton*.
%
%      H = ZSTACKSGUI returns the handle to a new ZSTACKSGUI or the handle to
%      the existing singleton*.
%
%      ZSTACKSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZSTACKSGUI.M with the given input arguments.
%
%      ZSTACKSGUI('Property','Value',...) creates a new ZSTACKSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zstacksgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zstacksgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zstacksgui

% Last Modified by GUIDE v2.5 25-Oct-2018 12:35:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zstacksgui_OpeningFcn, ...
                   'gui_OutputFcn',  @zstacksgui_OutputFcn, ...
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


% --- Executes just before zstacksgui is made visible.
function zstacksgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zstacksgui (see VARARGIN)
set(handles.zstackUp,'Enable','on')
set(handles.zstackDown,'Enable','off')
% Retrieve variables from worksapce
Im = evalin('base','toGUI');
nI = length(Im);
%nI = evalin('base','nIm');
n = 1;
% Plot the fist stack
axes(handles.zstacks)
imshow(Im{1},[0 max(Im{1}(:))]), axis off
if isa(Im{1},'double')
    colormap jet
end

% Choose default command line output for zstacksgui
handles.output = hObject;

% Update handles structure
handles.Im = Im;
handles.nI = nI;
handles.n = n;
guidata(hObject, handles);

% UIWAIT makes zstacksgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = zstacksgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function zstackNumber_Callback(hObject, eventdata, handles)
% hObject    handle to zstackNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zstackNumber as text
%        str2double(get(hObject,'String')) returns contents of zstackNumber as a double


% --- Executes during object creation, after setting all properties.
function zstackNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstackNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in zstackUp.
function zstackUp_Callback(hObject, eventdata, handles)
%count
n = handles.n;
n = n+1;
% show Imgage
axes(handles.zstacks)
imshow(handles.Im{n},[0 max(handles.Im{n}(:))]), axis off
if isa(handles.Im{n},'double')
    colormap jet
end
% Current z-stack selected
set(handles.zstackNumber,'String',[num2str(n) '/' num2str(handles.nI)]);
% Z-stack limit
if n == handles.nI
    set(handles.zstackUp,'Enable','off')
    drawnow
end
% Enable previous stack
set(handles.zstackDown,'Enable','on')
% Shared new value of count 
handles.n = n;
guidata(hObject, handles);

% hObject    handle to zstackUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zstackDown.
function zstackDown_Callback(hObject, eventdata, handles)
%count
n = handles.n;
n = n-1;
% show Imgage
axes(handles.zstacks)
imshow(handles.Im{n},[0 max(handles.Im{n}(:))]), axis off
if isa(handles.Im{n},'double')
    colormap jet
end
% Current z-stack selected
set(handles.zstackNumber,'String',[num2str(n) '/' num2str(handles.nI)]);
% Z-stack limit
if n == 1
    set(handles.zstackDown,'Enable','off')
    drawnow
end
% Enable previous stack
set(handles.zstackUp,'Enable','on')
% Shared new value of count 
handles.n = n;
guidata(hObject, handles);

% hObject    handle to zstackDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
