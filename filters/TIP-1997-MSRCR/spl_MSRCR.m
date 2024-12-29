function varargout = spl_MSRCR(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% @ARTICLE{597272,
%   author={Jobson, D.J. and Rahman, Z. and Woodell, G.A.},
%   journal={IEEE Transactions on Image Processing},
%   title={A multiscale retinex for bridging the gap between color images and the human observation of scenes},
%   year={1997},
%   volume={6},
%   number={7},
%   pages={965-976},
%   keywords={Color;Layout;Humans;Analog computers;Computer vision;Dynamic range;Image coding;Image restoration;Testing;Visual perception},
%   doi={10.1109/83.597272}
%  }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\1997-MSRCR';
    return;
end

if strcmpi(option,'get_parameter')==1
    
    param(1).name = 'Gain';
    param(1).value = '120';
    
    param(2).name = 'offset';
    param(2).value = '80';
    
    param(3).name = 'Alfa';
    param(3).value = '125';
    
    param(4).name = 'Gaussian Surround';
    param(4).value = '3,15,175';
    
    param(5).name = 'use post_correction(1-yes/0-no)';
    param(5).value = '1';
        
    varargout{1} = param;    
    return;
end


if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'Gain:','Offset:','Alfa:','Gaussian surround:','use post_correction(1-yes/0-no)'};
        lines=1;
        default={'150','85','125','3,15,175','1'};
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
    imgOut = MSRCR_process(imgSrc,para_set);
    
    elap_time = toc;
	
    title = sprintf('%s - %f s', '1997-MSRCR',elap_time);
    
    varargout{1} = imgOut;
    varargout{2} = title;
end

