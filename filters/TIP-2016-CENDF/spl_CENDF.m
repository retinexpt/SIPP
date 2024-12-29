function varargout = spl_CENDF(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @ARTICLE{7352346,
%   author={Liang, Zhetong and Liu, Weijian and Yao, Ruohe},
%   journal={IEEE Transactions on Image Processing}, 
%   title={Contrast Enhancement by Nonlinear Diffusion Filtering}, 
%   year={2016},
%   volume={25},
%   number={2},
%   pages={673-686},
%   keywords={Lighting;Estimation;Image edge detection;Reflectivity;Mathematical model;Smoothing methods;Image coding;contrast;image enhancement;illumination estimation;nonlinear diffusion;halo artifacts;Contrast;image enhancement;illumination estimation;nonlinear diffusion;halo artifacts},
%   doi={10.1109/TIP.2015.2507405}
%   }
%   
  
if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2016-CENDF';
	return;
end

if strcmpi(option,'get_parameter')==1      
    param(1).name = 'c';
    param(1).value = '0.0032';
    
    param(2).name = 'alpha';
    param(2).value = '1.2';    
        
    varargout{1} = param;
    return;
end

if strcmpi(option,'run')==1
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'c','alpha'};
        
        lines=1;
        default={'0.0032','1.2'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        
        para.c = str2double(para_set{1});
        para.alpha = str2double(para_set{2});
        
        [imgOut, strinfo] = CENDF(imgSrc,para.c,para.alpha);
    else
        para_set = varargin{1};
        
        para.c = str2double(para_set{1});
        para.alpha = str2double(para_set{2});
        [imgOut, strinfo] = CENDF(imgSrc,para.c,para.alpha);
    end
    
    varargout{1} = imgOut;
    varargout{2} = strinfo;
end
