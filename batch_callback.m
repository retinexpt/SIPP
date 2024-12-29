function batch_callback(handles,eventdata,varargin)

global spl_list;

idx = varargin{1};
[path,func_name,postfix] = fileparts(spl_list(idx).filter_name);

[srcdir, dstdir, dstimgfmt] = batchcfgdir();
if isempty(srcdir) || isempty(dstdir)
	return;
end

param_set = [];
param_set = feval(func_name,'get_parameter');

if isempty(param_set) ~= 1
    inputtitle='Input the cell parameters';
	lines=1;    

    for idx = 1:length(param_set)
        parameters{idx} = param_set(idx).name;
        default{idx} = param_set(idx).value;
    end
    
	param_set = inputdlg(parameters,inputtitle,lines,default);
    if isempty(param_set) == 1
        return;
    end
end


elap_all = 0;

cd(srcdir);
srcfile = dir(srcdir);
countfiles = size(srcfile);
for k = 1:countfiles(1)
	if srcfile(k).isdir | srcfile(k).bytes == 0
		continue;
	end
    
	[path,name,postfix] = fileparts(srcfile(k).name);
	postfix = lower(postfix);
	
	switch postfix
		case '.jpg'
		case '.jpeg'
		case '.bmp'
		case '.tif'
		case '.tiff'
        case '.png'
		otherwise
			disp('not supported format!');
			continue;
	end
	
	fullname = [srcdir, srcfile(k).name];
	[imgArray,cmap] = imread(fullname);
	
	if isempty(cmap)~=1
		imgArray = ind2rgb(imgArray,cmap);
		imgArray = uint8(255*imgArray);		
	end
	
    strcmdinfo = sprintf('......processing %s', srcfile(k).name);
	disp(strcmdinfo);
    
	str_method = func_name(5:length(func_name)); 
	
	fulldstname = [dstdir,'\',name,'_',str_method,'.',dstimgfmt];
	
	exist_file = dir(fulldstname);
	tic;
    if size(exist_file)>0
		continue;
    else    
        [imgOut, strinfo] = feval(func_name,'run',imgArray,fullname,param_set);
        elap_time = toc;
				
		imwrite(imgOut,fulldstname);
    end    
    
    elap_all = elap_all+elap_time;
		
	strcmdinfo = sprintf('......%d/%d done %s in %f s',k, countfiles(1), srcfile(k).name, elap_time);
	disp(strcmdinfo);
end
disp('...Done...');