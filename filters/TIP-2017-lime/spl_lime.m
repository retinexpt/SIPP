function varargout = spl_lime(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% @article{Guo2017LIME,
%   title={{LIME}: Low-Light Image Enhancement via Illumination Map Estimation},
%   author={Guo, Xiaojie and Li, Yu and Ling, Haibin},
%   journal={IEEE Trans Image Process},
%   volume={26},
%   number={2},
%   pages={982-993},
%   year={2017},
%  }
 
if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2017-LIME';
	return;
end

if strcmpi(option,'get_parameter')==1
	param(1).name = 'lamda';
    param(1).value = '0.15';
    
    param(2).name = 'sigma';
    param(2).value = '2';    
    
    param(3).name = 'gamma';
    param(3).value = '0.8';
    
    varargout{1} = param;
	
	return;
end

if strcmpi(option,'run')==1

	if isempty(varargin) == 1
		inputtitle='Input the cell parameters';
		parameters={'lamda','sigma','gamma\original 0.8'};
		
		lines=1;
		default={'0.15','2','0.8'};
		para_set = inputdlg(parameters,inputtitle,lines,default);	
        if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end		
	else
		para_set = varargin{1};		
    end
    
  	para.lambda = str2double(para_set{1});
	para.sigma = str2double(para_set{2});
	para.gamma = str2double(para_set{3});				
  
    tic;
	[I, T_ini,T_ref] = LIME(imgSrc,para);
   
	varargout{1} = I;
		
	elap_time = toc;
	title = sprintf('%s - g-%f %f s', 'LIME',para.gamma,elap_time);
	varargout{2} = title;	
end


