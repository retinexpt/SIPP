function varargout = spl_LECARM(option,imgSrc,varargin)
% % Interface function
% % *************************
% 
% @article{Yurui2018LECARM,
%   title={{LECARM}: Low-Light Image Enhancement Using the Camera Response Model},
%   author={Ren, Yurui and Ying, Zhenqiang and Li, Thomas H and Li, Ge},
%   journal={IEEE Transactions on Circuits and Systems for Video Technology},
%   volume={29},
%   number={4},
%   pages={968--981},
%   year={2018},
%   publisher={IEEE},
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans CSVT\2018-LECARM';
	return;
end

if strcmpi(option,'get_parameter')==1
	varargout{1} = [];
	return;
end

if strcmpi(option,'run')==1
	in = im2double(imgSrc);
	
	tic;
	%% select a camera response model
	model = CameraModels.Sigmoid();
% 	model = CameraModels.Beta();
% 	model = CameraModels.BetaGamma();
	
	%% enhance
	
	out = LECARM(in,model);
	out = abs(out);
	
	varargout{1} = uint8(out*255);
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'LECARM',elap_time);
	varargout{2} = title;
	%%%
end

