function filter_callback(handles,eventdata,varargin)

global spl_list;

idx = varargin{1};
[path,fun_name,ext] = fileparts(spl_list(idx).filter_name);

global structArray;

structA = getdatacell(varargin{2});

img_info=structA.imginfo;

[imgOut, strinfo] = feval(fun_name,'run',structA.imgArray,img_info.Filename);

if isempty(imgOut)~=1
	sipp_newfigure(imgOut,structA.cmap,strinfo,1,img_info, structA.Fig);
end