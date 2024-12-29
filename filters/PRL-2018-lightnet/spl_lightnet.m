function varargout = spl_lightnet(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @article{li2018lightennet,
%   title={LightenNet: A convolutional neural network for weakly illuminated image enhancement},
%   author={Li, Chongyi and Guo, Jichang and Porikli, Fatih and Pang, Yanwei},
%   journal={Pattern recognition letters},
%   volume={104},
%   pages={15--22},
%   year={2018},
%   publisher={Elsevier}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Pattern Recognition letters\2018-LightenNet';
	return;
end

if strcmpi(option,'get_parameter')==1  
   param(1).name = 'gamma\(original 1.7)';
    param(1).value = '1.7';
    
    varargout{1} = param;

    return;
end

if strcmpi(option,'run')==1

	if isempty(varargin) == 1
		inputtitle='Input the cell parameters';
		parameters={'gamma\original 1.7'};
		
		lines=1;
		default={'1.7'};
		para_set = inputdlg(parameters,inputtitle,lines,default);
        
		if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end			
	else
		para_set = varargin{1};					
    end
    
    gamma = str2double(para_set{1});
    
    tic;
    imgOut = lightnet_proc(imgSrc,gamma);
    
	varargout{1} = imgOut;
		
	elap_time = toc;
	strinfo = sprintf('%s - g-%f %f s', 'LightNet',gamma,elap_time);
	varargout{2} = strinfo;

end

