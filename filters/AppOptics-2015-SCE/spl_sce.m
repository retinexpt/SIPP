function varargout = spl_sce(option, imgSrc, varargin)
% Interface function
% *************************
% 
% @article{luo2015structural,
%   title={Structural compensation enhancement method for nonuniform illumination images},
%   author={Luo, Yong and Guan, Ye-Peng},
%   journal={Applied optics},
%   volume={54},
%   number={10},
%   pages={2929--2938},
%   year={2015},
%   publisher={Optica Publishing Group}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Applied Optics\2015-SCE';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
		
	win=11; sigm=1.5;          % Default parameters of local ambient light estimation
	
	tic;
 	in = rgb2hsv(imgSrc);
 	out=SCE(in,win,sigm);      % SCE processing
 	
 	enhanced=hsv2rgb(out);   % HSV to RGB color space
	
	varargout{1} = (enhanced);
			
	elap_time = toc;
	title = sprintf('%s - %f s','SCE2 result',elap_time);
	varargout{2} = title;
end


