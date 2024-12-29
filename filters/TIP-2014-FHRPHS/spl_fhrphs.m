function varargout = spl_fhrphs(option,imgSrc,imgName,varargin)
% Interface function
% *************************

% @article{NikolovaFast,
%   title={Fast Hue and Range Preserving Histogram Specification: Theory and New Algorithms for Color Image Enhancement},
%   author={Nikolova, Mila and Steidl, Gabriele},
%   journal={IEEE Transactions on Image Processing},
%   volume={23},
%   number={9},
%   pages={4087-4100},
%   year={2014}, 
% }


if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2014-FHRPHS';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	tic;
	
	lrh = [0.0111,0.0111,0.5];
	average = 1;
	stretch = 0;
	largepixel = 1;
	
	R.idx_ordered = [];
	R.LargePixel.Results = [];
	R.idx_ordered = [];
	R.LargePixel.Results = [];
	
	[imgOut,R] = RGB_HP_ENHANCE(double(imgSrc),lrh,...
		'Visualization',0,...
		'Average',average,...
		'Stretch',stretch,...
		'LargePixel',largepixel,...
		'idx_ordered',R.idx_ordered,...
		'LargePixelResults',R.LargePixel.Results);
	varargout{1} = imgOut/255;
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'FHRPHS result',elap_time);
	varargout{2} = title;
end


