function varargout = spl_VFGLE(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% @article{tian2018variational,
% 	title={A variational-based fusion model for non-uniform illumination image enhancement via contrast optimization and color correction},
% 	author={Tian, Qi-Chong and Cohen, Laurent D},
% 	journal={Signal Processing},
% 	volume={153},
% 	pages={210--220},
% 	year={2018},
% 	publisher={Elsevier}
% }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Signal Processing\2018-VFGLE';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).name = 'alpha';
    param(1).value = '0.5';
    
    param(2).name = 'beta';
    param(2).value = '0.5';
    
    param(3).name = 'gamma';
    param(3).value = '1';
    
    param(3).name = 'tao';
    param(3).value = '0.02';
    
    param(3).name = 'iterNum (original = 20)';
    param(3).value = '20'; %original = 20;
    
    varargout{1} = param;
    
    return;
end

if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'alpha','beta','gamma','tao','iterNum (original = 20)'};
        
        lines=1;
        default={'0.5','0.5','1','0.02','20'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        
        if isempty(para_set)
            varargout{1} = [];
            varargout{2} = [];
            return;
        end
    else
        para_set = varargin{1};
    end
    
    alpha = str2double(para_set{1});
    beta = str2double(para_set{2});
    gamma = str2double(para_set{3});
    tao = str2double(para_set{4});
    iterNum = str2double(para_set{5});
    
    tic;    
    I = VFGLE(imgSrc,alpha,beta,gamma,tao,iterNum);
    varargout{1} = I;
    
    elap_time = toc;
    title = sprintf('%s - %f s', 'VFGLE',elap_time);
    varargout{2} = title;
    %%%
end


