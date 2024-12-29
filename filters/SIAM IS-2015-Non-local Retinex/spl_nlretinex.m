function varargout = spl_nlretinex(option,imgSrc, imgName, varargin)
% Interface function
% 
% **************
% @article{zosso2015non,
%   title={Non-local Retinex---A unifying framework and beyond},
%   author={Zosso, Dominique and Tran, Giang and Osher, Stanley J},
%   journal={SIAM Journal on Imaging Sciences},
%   volume={8},
%   number={2},
%   pages={787--826},
%   year={2015},
%   publisher={SIAM}
% }
%

if strcmpi(option,'ui_name')==1
	varargout{1} = 'SIAM Image Science\2015-Nonlocal retinex';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	tic;
	
	imgOut = ContrastEnhancement(imgName);
	varargout{1} = imgOut;
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'NL-Retinex result',elap_time);
	
	varargout{2} = title;
end

