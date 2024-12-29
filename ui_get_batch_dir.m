function varargout = ui_get_batch_dir(varargin)
% UI_GET_BATCH_DIR MATLAB code for ui_get_batch_dir.fig
%      UI_GET_BATCH_DIR by itself, creates a new UI_GET_BATCH_DIR or raises the
%      existing singleton*.
%
%      H = UI_GET_BATCH_DIR returns the handle to a new UI_GET_BATCH_DIR or the handle to
%      the existing singleton*.
%
%      UI_GET_BATCH_DIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI_GET_BATCH_DIR.M with the given input arguments.
%
%      UI_GET_BATCH_DIR('Property','Value',...) creates a new UI_GET_BATCH_DIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_get_batch_dir_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_get_batch_dir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui_get_batch_dir

% Last Modified by GUIDE v2.5 29-Dec-2017 16:33:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_get_batch_dir_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_get_batch_dir_OutputFcn, ...
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

% --- Executes just before ui_get_batch_dir is made visible.
function ui_get_batch_dir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui_get_batch_dir (see VARARGIN)

% Choose default command line output for ui_get_batch_dir
handles.output = 'Ok';

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.dirdlg,'WindowStyle','modal')

% UIWAIT makes ui_get_batch_dir wait for user response (see UIRESUME)
uiwait(handles.dirdlg);

% --- Outputs from this function are returned to the command line.
function varargout = ui_get_batch_dir_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = get(handles.edit_src_dir,'String');
varargout{3} = get(handles.edit_dst_dir,'String');

% The figure can be deleted now
delete(handles.dirdlg);

% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);


% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.dirdlg);

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.dirdlg);


% --- Executes when user attempts to close dirdlg.
function dirdlg_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to dirdlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over dirdlg with no controls selected.
function dirdlg_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to dirdlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'Cancel';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.dirdlg);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.dirdlg);
end    


% --- Executes on button press in btn_open_src.
function btn_open_src_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
src_dir = uigetdir;
set(handles.edit_src_dir,'String',src_dir);


function edit_src_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_src_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_src_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_src_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_src_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_src_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_open_dst.
function btn_open_dst_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dst_dir = uigetdir;
set(handles.edit_dst_dir, 'String',dst_dir );


function edit_dst_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dst_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dst_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_dst_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_dst_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dst_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
