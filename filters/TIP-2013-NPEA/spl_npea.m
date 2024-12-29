function varargout = spl_npea(option,imgSrc, imgName, varargin)
% Interface function
% *************************

% @ARTICLE{6512558,
%   author={Wang, Shuhang and Zheng, Jin and Hu, Hai-Miao and Li, Bo},
%   journal={IEEE Transactions on Image Processing}, 
%   title={Naturalness Preserved Enhancement Algorithm for Non-Uniform Illumination Images}, 
%   year={2013},
%   volume={22},
%   number={9},
%   pages={3538-3548},
%   keywords={Lighting;Image enhancement;Light sources;Histograms;Image color analysis;Brightness;Image coding;Bi-log transformation;bright-pass filter;image enhancement;lightness-order-error measure;naturalness},
%   doi={10.1109/TIP.2013.2261309}
%   }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2013-NPEA';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	
	tic;
	
	imgOut = NPEA(imgName);
	varargout{1} = imgOut;
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'NPEA result',elap_time);
	
	varargout{2} = title;
end

