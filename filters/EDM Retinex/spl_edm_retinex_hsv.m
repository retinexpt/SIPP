function varargout = spl_edm_retinex_hsv(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% Exploratory data model(EDM) based Retinex
% Author: Tian Pu
% Institute:University of Electronic Science and Technology of China
 

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Misc\EDM retinex_hsv';
    return;
end

if strcmpi(option,'get_parameter')==1
    
    param(1).name = 'Gaussian Surround';
    param(1).value = '1,20';
    
    param(2).name = 'gamma';
    param(2).value = '0.45';
    
    varargout{1} = param;
    
    return;
end

if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'Gaussian surround:','gamma:'};
        lines=1;
        
        str_sigma = sprintf('1,%d',20);
        default={str_sigma,'0.45'};
        para_set=inputdlg(parameters,inputtitle,lines,default);
        
        if isempty(para_set)
            varargout{1} = [];
            varargout{2} = [];
            return;
        end
    else
        para_set = varargin{1};
    end
    
    tic;
    imgOut = edm_retinex_hsv(imgSrc,para_set);
    
    elap_time = toc;
    varargout{1} = imgOut;
    title = sprintf('%s - %f s','edm retinex result',elap_time);
    varargout{2} = title;
end

