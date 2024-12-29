function [srcdir, dstdir, imgfmt] = batchcfgdir()

[response, srcdir, dstdir] = ui_get_batch_dir;
response = lower(response);

switch response
	case 'cancel'
		srcdir = [];
		dstdir = [];
		imgfmt = [];
		return;
end

inputtitle='set the output image format';
parameters={'format (bmp/jpg/tif)'};

lines=1;
default={'jpg'};

param_set = inputdlg(parameters,inputtitle,lines,default);

imgfmt = [];

if isempty(param_set) 	
	srcdir = [];
	dstdir = [];
	return;
end

if strcmpi(param_set{1}, 'bmp') == 0 && strcmpi(param_set{1},'jpg') == 0 && strcmpi(param_set{1},'tif') == 0
	srcdir = [];
	dstdir = [];
	return;
end

srcdir = [srcdir,'\'];
dstdir = [dstdir,'\'];
imgfmt = param_set{1};

mkdir(dstdir);