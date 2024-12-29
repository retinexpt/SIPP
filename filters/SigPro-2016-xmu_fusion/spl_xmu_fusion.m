function varargout = spl_xmu_fusion(option, imgSrc, varargin)
% Interface function
% *************************

% @article{FuA,
%   title={A fusion-based enhancing method for weakly illuminated images},
%   author={Fu, Xueyang and Zeng, Delu and Huang, Yue and Liao, Yinghao and Ding, Xinghao and Paisley, John},
%   journal={Signal Processing},
%   volume={129},
%   pages={82--96},
%   year={2016},
%   publisher={Elsevier}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Signal Processing\2016-MultiFusion';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	tic;
	enhanced = multi_fusion( imgSrc );
	varargout{1} = (enhanced);
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'XMU FusionEA result',elap_time);
	varargout{2} = title;
end


