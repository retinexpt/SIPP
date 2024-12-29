function varargout = mount_filter(filter_path)

if isempty(filter_path)
	return;
end

addpath(genpath(filter_path));

filter_dir = dir(filter_path);

is_sub = [filter_dir(:).isdir];
spl_folder = lower({filter_dir(is_sub).name}');

len = size(spl_folder);
spl_folder = spl_folder(3:len(1));

global spl_list;

dummy_curdir = cd;

spl_count = 1;
for idx = 1:length(spl_folder)
	folder = fullfile(filter_path,spl_folder{idx});
	
	cd(folder);
	
	spl = dir('spl_*.m');
	if isempty(spl)
		continue;
	end
	
	for cc = 1:length(spl)
		spl_list(spl_count).filter_name = fullfile(folder,spl(cc).name);
		[path,fun_name,ext] = fileparts(spl_list(spl_count).filter_name);
		spl_list(spl_count).ui_name = feval(fun_name,'ui_name');
		spl_count = spl_count+1;		
	end
end

cd(dummy_curdir);