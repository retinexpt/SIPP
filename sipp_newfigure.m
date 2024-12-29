function varargout = sipp_newfigure(imgArray,cmap,imgfilename,isModified,varargin)
%create new figure to display an image

fig = openfig('sipp.fig','new');

% Use system color scheme for figure:
set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

handles = guihandles(fig);
guidata(fig, handles);

set(handles.Menu_Filter,'Visible','On');

global spl_list;
filter_handle = handles.Menu_Filter;
batch_handle = handles.Menu_Batch;
for idx = 1:length(spl_list)
	ui_name = spl_list(idx).ui_name;
	if isempty(ui_name)
		continue;
	end
	config_Menu(filter_handle, ui_name, {'filter_callback',idx, handles.MainForm} );
	config_Menu(batch_handle, ui_name, {'batch_callback',idx, handles.MainForm} );
end

parentFrm = [];
if nargin==5
    setdatacell(handles.MainForm,imgArray,cmap,isModified,imgfilename,varargin{1});
elseif nargin == 6
    setdatacell(handles.MainForm,imgArray,cmap,isModified,imgfilename,varargin{1});
    parentFrm = varargin{2};
else
    setdatacell(handles.MainForm,imgArray,cmap,isModified,imgfilename,[]);
end

%set the figure title
if isModified==1
    set(handles.MainForm,'Name',[imgfilename,' - Unsaved']);       
else
    set(handles.MainForm,'Name',['sipp','  --  ',imgfilename]);       
end

[img_height,img_width,page] = size(imgArray);
left_pos=0;
bottom_pos=0;
pos_height = 0;
pos_width = 0;

if isempty(parentFrm) ~= 1
    parentfrm_pos = get(parentFrm,'Position');
    pos = parentfrm_pos;
else
    ScrSize = get(0,'ScreenSize');
    scr_left= ScrSize(1,1);
    scr_bottom = ScrSize(1,2);
    scr_width = ScrSize(1,3);
    scr_height = ScrSize(1,4);    

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
end

set(handles.MainForm,'Position',pos);

varargout{1} = handles.MainForm;
