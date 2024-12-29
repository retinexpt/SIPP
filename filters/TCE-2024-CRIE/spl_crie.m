function varargout = spl_crie(option,imgSrc, imgName, varargin)
% Interface function
% *************************
% 
% @article{pu2024non,
% author={Pu, Tian and Zhu, Qingsong},
% journal={IEEE Transactions on Consumer Electronics}, 
% title={Non-Uniform Illumination Image Enhancement via a Retinal Mechanism Inspired Decomposition}, 
% year={2024},
% volume={70},
% number={1},
% pages={747-756},
% keywords={Lighting;Mathematical models;Image enhancement;Retina;Histograms;Visualization;Consumer electronics;Image enhancement;vision-based exploratory data model;contrast;residual image},
% doi={10.1109/TCE.2024.3377110}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Consumer Electronics\2024-CRIE';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	
	tic;
	
	imgOut = CRIE_HSV(imgSrc);
	varargout{1} = imgOut;
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'CRIE result',elap_time);
	
	varargout{2} = title;
end

