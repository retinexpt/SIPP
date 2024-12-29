function varargout = spl_wsh_mlls(option,imgSrc, imgName,varargin)
% Interface function
% *************************

% @article{WangNaturalness,
%   title={Naturalness preserved image enhancement using a priori multi-layer lightness statistics},
%   author={Wang, Shuhang and Luo, Gang},
%   journal={IEEE transactions on image processing},
%   volume={27},
%   number={2},
%   pages={938--948},
%   year={2018},
%   publisher={IEEE} 
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2018-NPIE_MLLS';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1	
	tic;
	
	rslt = NPIE_MLLS(imgSrc);
	varargout{1} = rslt;
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'NPIE_MLLS',elap_time);
	varargout{2} = title;
	
end

