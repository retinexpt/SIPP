function varargout = spl_plme_hsv(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @article{yu2019low,
%   title={Low-illumination image enhancement algorithm based on a physical lighting model},
%   author={Yu, Shun-Yuan and Zhu, Hong},
%   journal={IEEE Transactions on Circuits and Systems for Video Technology},
%   volume={29},
%   number={1},
%   pages={28--37},
%   year={2019},
%   publisher={IEEE}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans CSVT\2019-PLME';
	return;
end

if strcmpi(option,'get_parameter')==1
	
	param(1).name = 'guided filter size';
    param(1).value = '200';
    varargout{1} = param;
	return;
end

if strcmpi(option,'run')	

	if isempty(varargin) == 1
		
		inputtitle='Input the cell parameters';
		parameters={'guided filter size '};
		
		lines=1;
		default={'200'};
		para_set = inputdlg(parameters,inputtitle,lines,default);		
		if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end		
	else					
		para_set = varargin{1};	
    end
    
    para.width = str2double(para_set{1});
	tic;		
	rslt = PLME_HSV(imgSrc, para);

	varargout{1} = uint8(rslt*255);
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'PLME_HSV',elap_time);
	varargout{2} = title;
	%%%
end


