function varargout = sipp(varargin)
% SIPP MATLAB code for sipp.fig
%      SIPP, by itself, creates a new SIPP or raises the existing
%      singleton*.
%
%      H = SIPP returns the handle to a new SIPP or the handle to
%      the existing singleton*.
%
%      SIPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIPP.M with the given input arguments.
%
%      SIPP('Property','Value',...) creates a new SIPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sipp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sipp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sipp

% Last Modified by GUIDE v2.5 09-Dec-2024 16:07:22

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sipp_OpeningFcn, ...
                   'gui_OutputFcn',  @sipp_OutputFcn, ...
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

if nargin == 0  % LAUNCH GUI

	global filter_path;	
	filter_path = fullfile(fileparts(mfilename('fullpath')),'filters');
	mount_filter(filter_path);
		
	fig = openfig(mfilename,'reuse');
	
	handles = guihandles(fig);
	guidata(fig, handles);
	
	%config filter menu	
	filter_handle = handles.Menu_Filter;
	children = get(filter_handle,'Children');
	if isempty(children) == 1
		global spl_list;
		batch_handle = handles.Menu_Batch;
		for idx = 1:length(spl_list)
			ui_name = spl_list(idx).ui_name;
			if isempty(ui_name)
				continue;
			end
			config_Menu(filter_handle, ui_name, {'filter_callback',idx, handles.MainForm} );
 			config_Menu(batch_handle, ui_name, {'batch_callback',idx, handles.MainForm} );
		end		
	end	
	
	
	%set some menu items invisible    
    hAxes=get(handles.MainForm,'CurrentAxes');
    if isempty(hAxes)
        set(handles.Menu_Filter,'Visible','Off');
        set(handles.Menu_File_SaveAs,'Visible','Off');
	end
	
	if nargout > 0
		varargout{1} = fig;
	end
end


% End initialization code - DO NOT EDIT


% --- Executes just before sipp is made visible.
function sipp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sipp (see VARARGIN)

% Choose default command line output for sipp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = sipp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Menu_File_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Batch_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_File_Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global structArray;

if isempty(structArray)~=1
    structA = getdatacell(handles.MainForm);
	
	if isempty(structA)~=1&&isempty(structA.Fig)~=1
		setdatacell(handles.MainForm);		
	end    
end
delete(gcf);

% --------------------------------------------------------------------
function Menu_File_SaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File_SaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname]=uiputfile({'*.bmp;*.tiff;*.tif;*.jpg;*.jpeg;*.png;','image files(*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.png)'},...
	'Save the image file');

if fname~=0
    imfname=[pname,fname];
	
	structA = getdatacell(handles.MainForm);	

    if isempty(structA.cmap)~=1
        imwrite(structA.imgArray,structA.cmap,imfname);
    else
        imwrite(structA.imgArray,imfname);
    end
    imginfo = imfinfo(imfname);
	setdatacell(handles.MainForm,structA.imgArray,structA.cmap,0,imfname,imginfo);
	set(handles.MainForm,'Name',[mfilename,'  --  ',imfname]);
end

% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Help_About_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ScrSize=get(0,'ScreenSize');

fig=openfig('Aboutfig.fig','new');
figSize=get(fig,'Position');
set(fig,'Position',...
    [(ScrSize(1,3)-figSize(1,3))./2,(ScrSize(1,4)-figSize(1,4))./2,...
     figSize(1,3),figSize(1,4)]);


% --- Executes when user attempts to close MainForm.
function MainForm_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MainForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global structArray;

if isempty(structArray)~=1
    structA = getdatacell(handles.MainForm);
	
	if isempty(structA) ==1
		delete(hObject);
		return;
	end
	
	if isempty(structA.Fig)~=1
		setdatacell(handles.MainForm);
	end
end

delete(hObject);


function Menu_File_Open_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname]=uigetfile({'*.bmp;*.tiff;*.tif;*.jpg;*.jpeg;*.png;','image files(*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.png)'},...
	'Choose the image file');

if fname~=0
    imfname = [pname,fname];
    [imgArray,cmap] = imread(imfname);
    [img_height,img_width,page] = size(imgArray);
	
	if isempty(cmap)~=1
		imgArray = ind2rgb(imgArray,cmap);
		imgArray = uint8(255*imgArray);
	end

	if page == 1
		imgIn(:,:,1) = imgArray;
		imgIn(:,:,2) = imgArray;
		imgIn(:,:,3) = imgArray;
		
		imgArray = imgIn;
	end
	
    img_info=imfinfo(imfname);
    
    hAxes=get(handles.MainForm,'CurrentAxes');
        
    if isempty(hAxes)
        setdatacell(handles.MainForm,imgArray,[],0,imfname,img_info);          
        
        ScrSize = get(0,'ScreenSize');
        scr_left= ScrSize(1,1);
        scr_bottom = ScrSize(1,2);
        scr_width = ScrSize(1,3);
        scr_height = ScrSize(1,4);
        
        left_pos=0;
        bottom_pos=0;
        pos_height = 0;
        pos_width = 0;
        ratio = img_height/img_width;
        
        if (img_height/img_width>=(scr_height)/(scr_width))
            left_pos = scr_left + (scr_width-scr_height*0.8/ratio)/2;
            bottom_pos = scr_bottom+scr_height*0.1;
            pos_width = scr_height*0.8/ratio;
            pos_height = scr_height*0.8;
        else
            left_pos = scr_left+scr_width*0.1;
            bottom_pos = scr_bottom + (scr_height-scr_width*0.8*ratio)/2;
            pos_width = scr_width*0.8;
            pos_height = scr_height*0.8*ratio;
        end
        
        pos = [left_pos, bottom_pos, pos_width,pos_height];
        set(handles.MainForm,'Position',pos);
    else
        sipp_newfigure(imgArray,[],imfname,0,img_info); 
    end
end


% --- Executes when MainForm is resized.
function MainForm_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to MainForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles)==1
    return;
end 

structA = getdatacell(handles.MainForm);
if isempty(structA) ==1
    return;
end

imgArray = structA.imgArray;
[img_height,img_width,page] = size(imgArray);
if isempty(imgArray)
    return;
end 

hAxes=get(handles.MainForm,'CurrentAxes');
    
if isempty(hAxes)
    subplot(1,1,1);
    
    if page == 1
        imagesc(imgArray,[0,255]);
        colormap(gray);
    else
        imagesc(imgArray);
    end
end

hAxes=get(handles.MainForm,'CurrentAxes');
set(hAxes,'Units','pixels');

%zoom out the big size images
space = 160;

ScrSize = get(handles.MainForm,'Position');
scr_left= ScrSize(1,1);
scr_bottom = ScrSize(1,2);
scr_width = ScrSize(1,3);
scr_height = ScrSize(1,4);

if(scr_width-space<=0)||(scr_height-space<=0)
    return;
end

%set the figure title
imfname = structA.imgfilename;
set(handles.MainForm,'Name',[mfilename,'  --  ',imfname]);

%show the menu items
set(handles.Menu_Filter,'Visible','On');
set(handles.Menu_File_SaveAs,'Visible','On');

ratio = 1.;

left_pos=0;
bottom_pos=0;
if (img_height/img_width>=(scr_height-space)/(scr_width-space))
    if (img_height<=(scr_height-space))
        ratio = 1;
    else
        ratio = (scr_height-space)/img_height;
    end
    left_pos = space/2+(scr_width-space-img_width*ratio)/2;
    bottom_pos = space/2+(scr_height-space-img_height*ratio)/2;    
else
    if (img_width<=(scr_width-space))
        ratio = 1;
    else
        ratio = (scr_width-space)/img_width;
    end
    left_pos = space/2+(scr_width-space-img_width*ratio)/2;
    bottom_pos = space/2+(scr_height-space-img_height*ratio)/2;
end

set(hAxes,'Position',[left_pos, bottom_pos,img_width*ratio,img_height*ratio]);


