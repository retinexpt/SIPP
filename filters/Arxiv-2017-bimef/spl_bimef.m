function varargout = spl_bimef(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @article{ying2017bio,
%   title={A bio-inspired multi-exposure fusion framework for low-light image enhancement},
%   author={Ying, Zhenqiang and Li, Ge and Gao, Wen},
%   journal={arXiv preprint arXiv:1711.00591},
%   year={2017}
% }

if strcmpi(option,'ui_name');
	varargout{1} = 'Arxiv\2017-BIMEF';
	return;
end

if strcmpi(option,'get_parameter');
	varargout{1} = [];
	return;
end

if strcmpi(option,'run');	
	
	tic;
	%%%
	rslt = BIMEF(imgSrc);
	varargout{1} = uint8(rslt*255);
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'BIMEF',elap_time);
	varargout{2} = title;
	%%%
end


